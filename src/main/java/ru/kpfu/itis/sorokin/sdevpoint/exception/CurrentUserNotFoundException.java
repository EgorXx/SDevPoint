package ru.kpfu.itis.sorokin.sdevpoint.exception;

public class CurrentUserNotFoundException extends RuntimeException {
    public CurrentUserNotFoundException() {
        super("Current authenticated user was not found");
    }
}
