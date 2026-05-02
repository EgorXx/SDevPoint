package ru.kpfu.itis.sorokin.sdevpoint.exception;

public class BadRequestException extends RuntimeException {
    public BadRequestException(String message) {
        super(message);
    }
}
