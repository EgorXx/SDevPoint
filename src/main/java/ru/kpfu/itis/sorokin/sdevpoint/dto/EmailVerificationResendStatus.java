package ru.kpfu.itis.sorokin.sdevpoint.dto;

public enum EmailVerificationResendStatus {
    TOO_MANY_REQUEST,
    RATE_LIMIT_REQUEST,
    ALREADY_VERIFIED,
    RESEND
}
