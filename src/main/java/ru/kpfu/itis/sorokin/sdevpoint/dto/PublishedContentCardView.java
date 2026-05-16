package ru.kpfu.itis.sorokin.sdevpoint.dto;

public record PublishedContentCardView(
        Long contentItemId,
        String itemType,
        String owner,
        String title,
        String preview,
        String createdAt
) {}
