package ru.kpfu.itis.sorokin.sdevpoint.dto;

public record ArticleView(
        Long id,
        String title,
        String owner,
        String htmlText,
        String createdAt,
        String updatedAt
) {}
