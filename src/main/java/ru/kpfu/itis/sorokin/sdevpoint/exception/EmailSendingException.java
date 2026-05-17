package ru.kpfu.itis.sorokin.sdevpoint.exception;

public class EmailSendingException extends RuntimeException {
    public EmailSendingException(String message) {
        super(message);
    }
}
