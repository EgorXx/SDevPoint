package ru.kpfu.itis.sorokin.sdevpoint.dto;

import java.util.UUID;

public record ContentImageView(
        UUID publicId,
        String originalName,
        long size,
        String contentType,
        String url
) {}
