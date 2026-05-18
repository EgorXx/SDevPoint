package ru.kpfu.itis.sorokin.sdevpoint.web.controller.ajax;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.Resource;
import org.springframework.http.CacheControl;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import ru.kpfu.itis.sorokin.sdevpoint.api.generated.api.ImagesApi;
import ru.kpfu.itis.sorokin.sdevpoint.api.generated.dto.ContentImageView;
import ru.kpfu.itis.sorokin.sdevpoint.api.generated.dto.ContentImagesView;
import ru.kpfu.itis.sorokin.sdevpoint.api.generated.dto.ImageLimitView;
import ru.kpfu.itis.sorokin.sdevpoint.api.generated.dto.ImageUploadResponse;
import ru.kpfu.itis.sorokin.sdevpoint.dto.ImageContent;
import ru.kpfu.itis.sorokin.sdevpoint.service.CurrentUserProvider;
import ru.kpfu.itis.sorokin.sdevpoint.service.CustomUserDetails;
import ru.kpfu.itis.sorokin.sdevpoint.service.ImageService;

import java.net.URI;
import java.time.Duration;
import java.util.List;
import java.util.UUID;

@Slf4j
@RestController
@RequiredArgsConstructor
public class ImageUploadAjaxController implements ImagesApi {
    private final ImageService imageService;
    private final CurrentUserProvider currentUserProvider;
    private static final Duration MAX_AGE_DURATION = Duration.ofDays(30);

    @Override
    public ResponseEntity<ImageUploadResponse> uploadImage(MultipartFile file, Long contentItemId) {
        log.info("Received request upload image");

        Long userId = currentUserProvider.getCurrentUserId();

        ru.kpfu.itis.sorokin.sdevpoint.dto.ImageUploadResponse response =
                imageService.upload(file, contentItemId, userId);

        return ResponseEntity.ok(toGenerated(response));
    }

    @Override
    public ResponseEntity<Resource> getImage(UUID publicId) {
        log.info("Received request get image");

        Long currentUserId = getCurrentUserIdOrNull();

        ImageContent imageContent = imageService.getImage(publicId, currentUserId);

        return ResponseEntity.ok()
                .contentType(MediaType.parseMediaType(imageContent.contentType()))
                .contentLength(imageContent.contentLength())
                .cacheControl(CacheControl.maxAge(MAX_AGE_DURATION).cachePublic().immutable())
                .body(new ByteArrayResource(imageContent.bytes()));
    }

    @Override
    public ResponseEntity<ContentImagesView> getContentImages(Long contentItemId) {
        Long userId = currentUserProvider.getCurrentUserId();

        ru.kpfu.itis.sorokin.sdevpoint.dto.ContentImagesView view =
                imageService.getContentImages(contentItemId, userId);

        return ResponseEntity.ok(toGenerated(view));
    }

    @Override
    public ResponseEntity<ImageLimitView> deleteContentImage(Long contentItemId, UUID publicId) {
        Long userId = currentUserProvider.getCurrentUserId();

        ru.kpfu.itis.sorokin.sdevpoint.dto.ImageLimitView limitView =
                imageService.deleteContentImage(contentItemId, publicId, userId);

        return ResponseEntity.ok(toGenerated(limitView));
    }

    private Long getCurrentUserIdOrNull() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.isAuthenticated()
                && authentication.getPrincipal() instanceof CustomUserDetails userDetails) {
            return userDetails.getUserId();
        }
        return null;
    }

    private ImageUploadResponse toGenerated(
            ru.kpfu.itis.sorokin.sdevpoint.dto.ImageUploadResponse dto) {
        return new ImageUploadResponse(
                dto.publicId(),
                dto.contentType(),
                dto.originalName(),
                dto.size(),
                URI.create(dto.url()),
                toGenerated(dto.imageLimitView())
        );
    }

    private ImageLimitView toGenerated(ru.kpfu.itis.sorokin.sdevpoint.dto.ImageLimitView dto) {
        return new ImageLimitView(dto.currentSize(), dto.maxSize());
    }

    private ContentImagesView toGenerated(
            ru.kpfu.itis.sorokin.sdevpoint.dto.ContentImagesView dto) {
        List<ContentImageView> images = dto.images().stream()
                .map(this::toGenerated)
                .toList();
        return new ContentImagesView(images, toGenerated(dto.limit()));
    }

    private ContentImageView toGenerated(
            ru.kpfu.itis.sorokin.sdevpoint.dto.ContentImageView dto) {
        return new ContentImageView(
                dto.publicId(),
                dto.originalName(),
                dto.size(),
                dto.contentType(),
                URI.create(dto.url())
        );
    }
}
