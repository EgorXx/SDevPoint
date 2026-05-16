package ru.kpfu.itis.sorokin.sdevpoint.web.form;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record RejectContentForm(
        @NotBlank(message = "Укажите причину отклонения")
        @Size(max = 2000, message = "Комментарий слишком длинный")
        String comment
) {}
