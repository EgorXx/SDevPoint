package ru.kpfu.itis.sorokin.sdevpoint.dto;

import java.util.List;

public record ArticlePageView(
        List<ArticleCardView> articles,
        int currentPage,
        int size,
        long totalElements,
        int totalPages,
        boolean hasPrevious,
        boolean hasNext
) {}
