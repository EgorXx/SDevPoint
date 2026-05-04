package ru.kpfu.itis.sorokin.sdevpoint.exception;

public class ArticleAlreadyPublished extends RuntimeException {
    public ArticleAlreadyPublished(String message) {
        super(message);
    }
}
