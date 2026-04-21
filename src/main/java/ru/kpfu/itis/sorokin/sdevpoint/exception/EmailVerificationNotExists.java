package ru.kpfu.itis.sorokin.sdevpoint.exception;

public class EmailVerificationNotExists extends RuntimeException {
    public EmailVerificationNotExists(String message) {
        super(message);
    }
}
