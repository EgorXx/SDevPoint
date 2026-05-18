package ru.kpfu.itis.sorokin.sdevpoint.web.controller.ajax;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.Resource;
import org.springframework.http.CacheControl;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import ru.kpfu.itis.sorokin.sdevpoint.dto.*;
import ru.kpfu.itis.sorokin.sdevpoint.service.CustomUserDetails;
import ru.kpfu.itis.sorokin.sdevpoint.service.ImageService;

import java.time.Duration;
import java.util.List;
import java.util.UUID;

@Slf4j
@RestController
@RequiredArgsConstructor
public class ImageUploadAjaxController {
    private final ImageService imageService;
    private static final Duration MAX_AGE_DURATION = Duration.ofDays(30);

    @PostMapping(path ="/api/upload/image", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<ImageUploadResponse> uploadImage(
            @RequestParam("file") MultipartFile file,
            @RequestParam("contentItemId") Long contentItemId,
            @AuthenticationPrincipal CustomUserDetails customUserDetails
            ) {

        log.info("Received request upload image");

        ImageUploadResponse imageUploadResponse = imageService.upload(
                file,
                contentItemId,
                customUserDetails.getUserId()
        );

        return ResponseEntity.ok(imageUploadResponse);
    }

    @GetMapping(path = "/api/image/{publicId}")
    public ResponseEntity<Resource> getImage(
            @PathVariable UUID publicId,
            @AuthenticationPrincipal CustomUserDetails customUserDetails
    ) {
        log.info("Received request get image");

        Long currentUserId = customUserDetails != null
                ? customUserDetails.getUserId()
                : null;

        ImageContent imageContent = imageService.getImage(publicId, currentUserId);

        return ResponseEntity.ok()
                .contentType(MediaType.parseMediaType(imageContent.contentType()))
                .contentLength(imageContent.contentLength())
                .cacheControl(CacheControl.maxAge(MAX_AGE_DURATION).cachePublic().immutable())
                .body(new ByteArrayResource(imageContent.bytes()));
    }

    @GetMapping("/api/content-items/{contentItemId}/images")
    public ResponseEntity<ContentImagesView> getContentImages(
            @PathVariable Long contentItemId,
            @AuthenticationPrincipal CustomUserDetails customUserDetails
    ) {
        ContentImagesView imagesView = imageService.getContentImages(
                contentItemId,
                customUserDetails.getUserId()
        );

        return ResponseEntity.ok(imagesView);
    }

    @DeleteMapping("/api/content-items/{contentItemId}/images/{publicId}")
    public ResponseEntity<ImageLimitView> deleteContentImage(
            @PathVariable Long contentItemId,
            @PathVariable UUID publicId,
            @AuthenticationPrincipal CustomUserDetails customUserDetails
    ) {
        ImageLimitView imageLimitView = imageService.deleteContentImage(
                contentItemId,
                publicId,
                customUserDetails.getUserId()
        );

        return ResponseEntity.ok(imageLimitView);
    }
}
