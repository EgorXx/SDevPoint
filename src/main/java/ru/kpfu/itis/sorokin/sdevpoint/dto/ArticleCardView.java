package ru.kpfu.itis.sorokin.sdevpoint.dto;

public record ArticleCardView(
        Long contentItemId,
        String owner,
        String title,
        String preview,
        String createdAt
) {}
