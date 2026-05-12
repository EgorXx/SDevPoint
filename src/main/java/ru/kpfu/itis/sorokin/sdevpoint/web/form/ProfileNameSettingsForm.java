package ru.kpfu.itis.sorokin.sdevpoint.web.form;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record ProfileNameSettingsForm(
        @NotBlank(message = "Имя не должно быть пустым")
        @Size(max = 50, message = "Имя не должно быть длиннее 50 символов")
        String username
) {}
