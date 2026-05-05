package ru.kpfu.itis.sorokin.sdevpoint.dto;

import ru.kpfu.itis.sorokin.sdevpoint.entity.Visibility;

public record ArticleCreateView(
        Long draftId,
        String title,
        String text,
        Visibility visibility
) {
}
