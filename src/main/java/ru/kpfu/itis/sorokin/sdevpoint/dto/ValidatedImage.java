package ru.kpfu.itis.sorokin.sdevpoint.dto;

public record ValidatedImage(
        String originalName,
        String contentType,
        Integer height,
        Integer width,
        Long size
) {}
