package ru.kpfu.itis.sorokin.sdevpoint.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import ru.kpfu.itis.sorokin.sdevpoint.dto.*;
import ru.kpfu.itis.sorokin.sdevpoint.entity.ContentItem;
import ru.kpfu.itis.sorokin.sdevpoint.entity.ContentItemImage;
import ru.kpfu.itis.sorokin.sdevpoint.exception.BadRequestException;
import ru.kpfu.itis.sorokin.sdevpoint.exception.ForbiddenException;
import ru.kpfu.itis.sorokin.sdevpoint.exception.ImageStorageException;
import ru.kpfu.itis.sorokin.sdevpoint.exception.NotFoundException;
import ru.kpfu.itis.sorokin.sdevpoint.repository.ContentItemImageRepository;
import ru.kpfu.itis.sorokin.sdevpoint.repository.ContentItemRepository;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.time.Instant;
import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
public class ImageService {
    private final ContentItemRepository contentItemRepository;
    private final ContentItemImageRepository contentItemImageRepository;
    private final ImageStorage imageStorage;

    private static final long SIZE_LIMIT = 5L * 1024 * 1024;
    private static final String ENDPOINT = "/api/image/";

    public ImageUploadResponse upload(MultipartFile image, Long contentItemId, Long userId) {
        ContentItem contentItem = contentItemRepository.findWithOwnerById(contentItemId)
                .orElseThrow(() -> new NotFoundException("Контент не найден"));

        if (!contentItem.getOwner().getId().equals(userId)) {
            log.debug("Access is denied ownerId={}, userId={}", contentItem.getOwner().getId(), userId);
            throw new ForbiddenException("Доступ к контенту запрещен запрещен");
        }

        ValidatedImage validatedImage = validateUploadImage(image);
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
                ENDPOINT + publicId
        );
    }

    public ImageContent getImage(UUID publicId) {
        ContentItemImage contentItemImage = contentItemImageRepository.findByPublicId(publicId)
                .orElseThrow(() -> new NotFoundException("Изображение не найдено"));

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

    public void deleteImage(String storageKey) {
        imageStorage.delete(storageKey);
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

    private ValidatedImage validateUploadImage(MultipartFile file) {
        if (file.isEmpty()) {
            throw new BadRequestException("Изображение пустое");
        }

        if (file.getSize() > SIZE_LIMIT) {
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
