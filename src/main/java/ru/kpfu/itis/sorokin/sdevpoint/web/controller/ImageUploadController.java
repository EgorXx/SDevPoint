package ru.kpfu.itis.sorokin.sdevpoint.web.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.Resource;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import ru.kpfu.itis.sorokin.sdevpoint.dto.ImageContent;
import ru.kpfu.itis.sorokin.sdevpoint.dto.ImageUploadResponse;
import ru.kpfu.itis.sorokin.sdevpoint.service.CustomUserDetails;
import ru.kpfu.itis.sorokin.sdevpoint.service.ImageService;

import java.util.UUID;

@Slf4j
@RestController
@RequiredArgsConstructor
public class ImageUploadController {
    private final ImageService imageService;

    @PostMapping(path ="/api/upload/image", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<ImageUploadResponse> uploadImage(
            @RequestParam("file") MultipartFile file,
            @RequestParam("contentItemId") Long contentItemId,
            @AuthenticationPrincipal CustomUserDetails customUserDetails
            ) {

        log.info("Received request upload image");
        if (file.isEmpty()) {
            throw new IllegalArgumentException("File is empty");
        }

        ImageUploadResponse imageUploadResponse = imageService.upload(
                file,
                contentItemId,
                customUserDetails.getUserId()
        );

        return ResponseEntity.ok(imageUploadResponse);
    }

    @GetMapping(path = "/api/image/{publicId}")
    public ResponseEntity<Resource> getImage(@PathVariable UUID publicId) {
        log.info("Received request get image");

        ImageContent imageContent = imageService.getImage(publicId);

        return ResponseEntity.ok()
                .contentType(MediaType.parseMediaType(imageContent.contentType()))
                .body(new ByteArrayResource(imageContent.bytes()));
    }
}
