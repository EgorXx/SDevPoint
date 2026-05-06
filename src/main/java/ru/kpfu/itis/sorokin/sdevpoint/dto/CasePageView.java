package ru.kpfu.itis.sorokin.sdevpoint.dto;

import java.util.List;

public record CasePageView(
        List<CaseCardView> cases,
        int currentPage,
        int size,
        long totalElements,
        int totalPages,
        boolean hasPrevious,
        boolean hasNext
) {}
