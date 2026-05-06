package ru.kpfu.itis.sorokin.sdevpoint.dto;

import ru.kpfu.itis.sorokin.sdevpoint.entity.Visibility;

public record CaseEditDto(
        Long contentItemId,
        String title,
        String description,
        boolean hasSolution,
        String solution,
        Visibility visibility
) {}
