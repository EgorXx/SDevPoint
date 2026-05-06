package ru.kpfu.itis.sorokin.sdevpoint.dto;

import ru.kpfu.itis.sorokin.sdevpoint.entity.Visibility;

public record CaseCreateDto(
        Long draftId,
        String title,
        String description,
        boolean hasSolution,
        String solution,
        Visibility visibility
) {}
