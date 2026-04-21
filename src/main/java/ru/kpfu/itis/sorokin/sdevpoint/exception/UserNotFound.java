package ru.kpfu.itis.sorokin.sdevpoint.exception;

public class UserNotFound extends RuntimeException {
    public UserNotFound(String message) {
        super(message);
    }
}
