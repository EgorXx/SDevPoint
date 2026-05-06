package ru.kpfu.itis.sorokin.sdevpoint.dto;

import java.util.List;

public record CaseDiscussionPageView(
        Long contentItemId,
        String owner,
        String title,
        String description,
        String createdAt,
        List<CaseCommentView> caseComments,
        int currentPage,
        int size,
        long totalElements,
        int totalPages,
        boolean hasPrevious,
        boolean hasNext
) {}
