package ru.kpfu.itis.sorokin.sdevpoint.dto;

import java.util.UUID;

public record ImageUploadResponse(
        UUID publicId,
        String contentType,
        String originalName,
        long size,
        String url
) {}
