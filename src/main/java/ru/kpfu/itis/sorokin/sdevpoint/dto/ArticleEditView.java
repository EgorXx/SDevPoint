package ru.kpfu.itis.sorokin.sdevpoint.dto;

import ru.kpfu.itis.sorokin.sdevpoint.entity.Visibility;

public record ArticleEditView(
        Long articleId,
        Long contentItemId,
        String title,
        String text,
        Visibility visibility
) {}
