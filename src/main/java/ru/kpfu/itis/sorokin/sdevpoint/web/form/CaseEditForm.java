package ru.kpfu.itis.sorokin.sdevpoint.web.form;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import ru.kpfu.itis.sorokin.sdevpoint.entity.Visibility;

public record CaseEditForm(
        @NotBlank(message = "Название не должно быть пустым")
        @Size(max = 100, message = "Название не должно быть длиннее 100 символов")
        String title,

        @NotBlank(message = "Описание кейса не должно быть пустым")
        @Size(max = 50_000, message = "Описание кейса слишком длинное")
        String description,

        boolean hasSolution,

        @NotNull(message = "Решение кейса не должно быть пустым")
        @Size(max = 100_000, message = "Решение кейса слишком длинное")
        String solution,

        @NotNull(message = "Выберите доступность статьи")
        Visibility visibility
) {}
