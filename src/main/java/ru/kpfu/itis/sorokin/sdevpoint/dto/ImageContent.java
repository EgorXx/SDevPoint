package ru.kpfu.itis.sorokin.sdevpoint.dto;

public record ImageContent(
        String contentType,
        long contentLength,
        byte[] bytes
) {}
