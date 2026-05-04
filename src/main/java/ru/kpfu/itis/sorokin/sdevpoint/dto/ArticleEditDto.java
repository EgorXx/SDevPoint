package ru.kpfu.itis.sorokin.sdevpoint.dto;

import ru.kpfu.itis.sorokin.sdevpoint.entity.Visibility;

public record ArticleEditDto(
        Long articleId,
        String title,
        String text,
        Visibility visibility
) {
}
