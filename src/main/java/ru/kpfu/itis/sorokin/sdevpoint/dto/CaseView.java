package ru.kpfu.itis.sorokin.sdevpoint.dto;

public record CaseView(
        Long contentId,
        String title,
        String owner,
        String htmlTextDescription,
        boolean hasSolution,
        String htmlTextSolution,
        String createdAt,
        String updatedAt,
        Long countViews
) {}
