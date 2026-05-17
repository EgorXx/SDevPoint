package ru.kpfu.itis.sorokin.sdevpoint.web.form;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record CaseCommentCreateForm(
        @NotBlank(message = "Комментарий не должен быть пустым")
        @Size(max = 2000, message = "Комментарий слишком длинный")
        String text
) {}
