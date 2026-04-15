package ru.kpfu.itis.sorokin.sdevpoint.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record UserForm(
        @NotBlank
        @Email
        String email,

        @NotBlank
        @Size(min = 4, max = 32)
        String password
) {}
