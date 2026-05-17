package ru.kpfu.itis.sorokin.sdevpoint.dto;

public record EmailVerificationResendResponse(
        EmailVerificationResendStatus resendStatus,
        String message
) {
}
