package ru.kpfu.itis.sorokin.sdevpoint.dto;

public record EmailConfirmView(
        String title,
        String message,
        String status,
        boolean showLoginButton
) {}
