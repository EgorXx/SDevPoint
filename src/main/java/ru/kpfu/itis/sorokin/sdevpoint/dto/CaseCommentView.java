package ru.kpfu.itis.sorokin.sdevpoint.dto;

public record CaseCommentView(
        Long commentId,
        Long ownerId,
        String owner,
        String ownerAvatarUrl,
        String createdAt,
        String text,
        boolean canDelete,
        boolean isAuthor
) {}
