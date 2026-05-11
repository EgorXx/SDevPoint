package ru.kpfu.itis.sorokin.sdevpoint.dto;

public record CaseCommentView(
        Long commentId,
        String owner,
        String createdAt,
        String text,
        boolean canDelete,
        boolean isAuthor
) {}
