package ru.kpfu.itis.sorokin.sdevpoint.dto;

import java.util.List;

public record ContentPageView(
        List<ContentCardView> contents,
        int currentPage,
        int size,
        long totalElements,
        int totalPages,
        boolean hasPrevious,
        boolean hasNext
) {}
