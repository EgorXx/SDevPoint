package ru.kpfu.itis.sorokin.sdevpoint.exception;

public class EmailVerificationExpired extends RuntimeException {
    public EmailVerificationExpired(String message) {
        super(message);
    }
}
