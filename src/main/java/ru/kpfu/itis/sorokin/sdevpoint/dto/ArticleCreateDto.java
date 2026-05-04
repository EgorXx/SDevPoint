package ru.kpfu.itis.sorokin.sdevpoint.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import ru.kpfu.itis.sorokin.sdevpoint.entity.Visibility;

public record ArticleCreateDto(
        Long userId,
        Long draftId,
        String title,
        String text,
        Visibility visibility
) {}
