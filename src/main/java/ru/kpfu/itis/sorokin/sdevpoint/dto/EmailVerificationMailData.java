package ru.kpfu.itis.sorokin.sdevpoint.dto;

import java.time.Instant;

public record EmailVerificationMailData(
        String email,
        String token,
        String username,
        Instant expiresAt
) {
}
