package ru.kpfu.itis.sorokin.sdevpoint.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import ru.kpfu.itis.sorokin.sdevpoint.dto.*;
import ru.kpfu.itis.sorokin.sdevpoint.entity.ContentItem;
import ru.kpfu.itis.sorokin.sdevpoint.entity.ContentItemImage;
import ru.kpfu.itis.sorokin.sdevpoint.entity.StorageDeletionTask;
import ru.kpfu.itis.sorokin.sdevpoint.entity.Visibility;
import ru.kpfu.itis.sorokin.sdevpoint.exception.BadRequestException;
import ru.kpfu.itis.sorokin.sdevpoint.exception.ForbiddenException;
import ru.kpfu.itis.sorokin.sdevpoint.exception.ImageStorageException;
import ru.kpfu.itis.sorokin.sdevpoint.exception.NotFoundException;
import ru.kpfu.itis.sorokin.sdevpoint.properties.ImageUploadProperties;
import ru.kpfu.itis.sorokin.sdevpoint.repository.ContentItemImageRepository;
import ru.kpfu.itis.sorokin.sdevpoint.repository.ContentItemRepository;
import ru.kpfu.itis.sorokin.sdevpoint.repository.StorageDeletionTaskRepository;
import ru.kpfu.itis.sorokin.sdevpoint.web.routes.ImageRoutes;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.time.Instant;
import java.util.List;
import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
public class ImageService {
    private final ContentItemRepository contentItemRepository;
    private final ContentItemImageRepository contentItemImageRepository;
    private final ImageStorage imageStorage;
    private final StorageDeletionTaskRepository storageDeletionTaskRepository;
    private final ImageUploadProperties imageUploadProperties;


    @Transactional
    public ImageUploadResponse upload(MultipartFile image, Long contentItemId, Long userId) {
        ValidatedImage validatedImage = validateUploadImage(image);

        ContentItem contentItem = contentItemRepository
                .findByIdForImageUpload(contentItemId)
                .orElseThrow(() -> new NotFoundException("Контент не найден"));

        checkOwner(contentItem, userId);

        long newTotalSize = checkImageLimits(contentItemId, userId, validatedImage.size());

        UUID publicId = UUID.randomUUID();

        StoredImageInfo storedImageInfo;

        try {
            storedImageInfo = imageStorage.save(
                    image,
                    contentItemId,
                    publicId,
                    resolveExtension(validatedImage.contentType())
            );
        } catch (ImageStorageException e) {
            log.error("Error saving the image: {}", e.getMessage());
            throw new ImageStorageException("Что-то пошло не так, не удалось сохранить изображение");
        }

        ContentItemImage contentItemImage = new ContentItemImage(
                null,
                contentItem,
                validatedImage.originalName(),
                storedImageInfo.storageKey(),
                validatedImage.size(),
                validatedImage.height(),
                validatedImage.width(),
                validatedImage.contentType(),
                Instant.now(),
                publicId
        );

        contentItemImageRepository.save(contentItemImage);

        return new ImageUploadResponse(
                publicId,
                validatedImage.contentType(),
                validatedImage.originalName(),
                validatedImage.size(),
                ImageRoutes.imageUrl(publicId),
                new ImageLimitView(
                        newTotalSize,
                        imageUploadProperties.maxTotalSizePerContent().toBytes()
                )
        );
    }

    @Transactional(readOnly = true)
    public ImageContent getImage(UUID publicId, Long userId) {
        ContentItemImage contentItemImage = contentItemImageRepository.findByPublicId(publicId)
                .orElseThrow(() -> new NotFoundException("Изображение не найдено"));

        ContentItem contentItem = contentItemImage.getContentItem();

        if (contentItem.getVisibility() == Visibility.PRIVATE) {
            checkOwner(contentItem, userId);
        }

        byte[] content;

        try {
            content = imageStorage.get(contentItemImage.getStorageKey());
        } catch (ImageStorageException e) {
            log.error("Error loading the image: {}", e.getMessage());
            throw new ImageStorageException("Что-то пошло не так, не удалось загрузить изображение");
        }

        return new ImageContent(
                contentItemImage.getContentType(),
                contentItemImage.getSize(),
                content
        );
    }

    @Transactional(readOnly = true)
    public ContentImagesView getContentImages(Long contentItemId, Long userId) {
        ContentItem contentItem = contentItemRepository.findWithOwnerById(contentItemId)
                .orElseThrow(() -> new NotFoundException("Контент не найден"));

        checkOwner(contentItem, userId);

        List<ContentImageView> images = contentItemImageRepository.findByContentItemId(contentItemId)
                .stream()
                .map(image -> new ContentImageView(
                        image.getPublicId(),
                        image.getOriginalName(),
                        image.getSize(),
                        image.getContentType(),
                        ImageRoutes.imageUrl(image.getPublicId())
                ))
                .toList();

        long totalContentSize = contentItemImageRepository.sumSizeByContentItemId(contentItemId);

        return new ContentImagesView(
                images,
                new ImageLimitView(
                        totalContentSize,
                        imageUploadProperties.maxTotalSizePerContent().toBytes()
                )
        );
    }

    @Transactional
    public ImageLimitView deleteContentImage(Long contentItemId, UUID publicId, Long userId) {
        ContentItem contentItem = contentItemRepository
                .findByIdForImageUpload(contentItemId)
                .orElseThrow(() -> new NotFoundException("Контент не найден"));

        checkOwner(contentItem, userId);

        long sumContentSize = contentItemImageRepository.sumSizeByContentItemId(contentItemId);

        ContentItemImage image = contentItemImageRepository
                .findByContentItemIdAndPublicId(contentItemId, publicId)
                .orElseThrow(() -> new NotFoundException("Изображение не найдено"));

        storageDeletionTaskRepository.save(
                StorageDeletionTask.createFileDeletion(image.getStorageKey())
        );

        contentItemImageRepository.delete(image);

        return new ImageLimitView(
                sumContentSize - image.getSize(),
                imageUploadProperties.maxTotalSizePerContent().toBytes()
        );
    }

    public void checkOwner(ContentItem contentItem, Long userId) {
        if (!contentItem.getOwner().getId().equals(userId)) {
            log.debug("Access is denied ownerId={}, userId={}", contentItem.getOwner().getId(), userId);
            throw new ForbiddenException("Доступ к контенту запрещен запрещен");
        }
    }

    private String resolveExtension(String contentType) {
        return switch (contentType) {
            case "image/png" -> ".png";
            case "image/jpeg" -> ".jpg";
            case "image/webp" -> ".webp";
            case "image/gif" -> ".gif";
            default -> throw new BadRequestException("Недопустимый тип изображения");
        };
    }

    private long checkImageLimits(Long contentItemId, Long userId, long newImageSize) {
        long maxContentSize = imageUploadProperties.maxTotalSizePerContent().toBytes();
        long maxUserSize = imageUploadProperties.maxTotalSizePerUser().toBytes();

        long currentContentSize = contentItemImageRepository.sumSizeByContentItemId(contentItemId);
        long newContentSize = currentContentSize + newImageSize;

        if (newContentSize > maxContentSize) {
            throw new BadRequestException("Превышен лимит объёма изображений для этого контента");
        }

        long currentUserSize = contentItemImageRepository.sumSizeByOwnerId(userId);
        long newUserSize = currentUserSize + newImageSize;

        if (newUserSize > maxUserSize) {
            throw new BadRequestException("Превышен общий лимит объёма изображений для пользователя");
        }

        return newContentSize;
    }

    private ValidatedImage validateUploadImage(MultipartFile file) {
        if (file.isEmpty()) {
            throw new BadRequestException("Изображение пустое");
        }

        if (file.getSize() > imageUploadProperties.maxFileSize().toBytes()) {
            throw new BadRequestException("Размер изображения слишком большой");
        }

        String contentType = file.getContentType();
        if (contentType == null || !contentType.startsWith("image/")) {
            throw new BadRequestException("Недопустимый тип изображения");
        }

        byte[] bytes;
        try {
            bytes = file.getBytes();
        } catch (IOException e) {
            throw new BadRequestException("Невозможно обработать изображение");
        }

        BufferedImage image;
        try (ByteArrayInputStream in = new ByteArrayInputStream(bytes)) {
            image = ImageIO.read(in);
        } catch (IOException e) {
            throw new BadRequestException("Недопустимый формат изображения");
        }

        if (image == null) {
            throw new BadRequestException("Недопустимый формат изображения");
        }

        return new ValidatedImage(
                file.getOriginalFilename(),
                file.getContentType(),
                image.getHeight(),
                image.getWidth(),
                file.getSize()
        );
    }
}
