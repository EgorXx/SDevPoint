package ru.kpfu.itis.sorokin.sdevpoint.exception;

public class UserAlreadyExists extends RuntimeException {
    public UserAlreadyExists(String message) {
        super(message);
    }
}
