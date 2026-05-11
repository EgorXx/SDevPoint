package ru.kpfu.itis.sorokin.sdevpoint.dto;

public record ContentCardView(
        Long contentItemId,
        String itemType,
        String owner,
        String title,
        String preview,
        String createdAt
) {}
