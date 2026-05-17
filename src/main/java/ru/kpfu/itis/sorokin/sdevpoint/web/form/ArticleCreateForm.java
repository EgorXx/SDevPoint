package ru.kpfu.itis.sorokin.sdevpoint.web.form;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import ru.kpfu.itis.sorokin.sdevpoint.entity.Visibility;

public record ArticleCreateForm(
        @NotBlank(message = "Название не должно быть пустым")
        @Size(max = 100, message = "Название не должно быть длиннее 100 символов")
        String title,

        @NotBlank(message = "Текст статьи не должен быть пустым")
        @Size(max = 100_000, message = "Текст статьи слишком длинный")
        String text,

        @NotNull(message = "Выберите доступность статьи")
        Visibility visibility
) {}
