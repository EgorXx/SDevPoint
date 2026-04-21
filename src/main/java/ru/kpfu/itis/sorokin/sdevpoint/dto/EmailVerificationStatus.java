package ru.kpfu.itis.sorokin.sdevpoint.dto;

public enum EmailVerificationStatus {
    VERIFIED,
    EXPIRED_NEW_TOKEN_SENT,
    ALREADY_VERIFIED,
    INVALID_TOKEN
}
