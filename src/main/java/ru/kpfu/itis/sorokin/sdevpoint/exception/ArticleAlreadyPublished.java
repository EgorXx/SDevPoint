package ru.kpfu.itis.sorokin.sdevpoint.exception;

import lombok.Getter;

@Getter
public class ArticleAlreadyPublished extends RuntimeException {

    private final Long contentItemId;

    public ArticleAlreadyPublished(Long contentItemId) {
        super("Статья уже опубликована");
        this.contentItemId = contentItemId;
    }
}
