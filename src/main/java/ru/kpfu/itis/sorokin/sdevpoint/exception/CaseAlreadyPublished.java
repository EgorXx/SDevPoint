package ru.kpfu.itis.sorokin.sdevpoint.exception;

import lombok.Getter;

@Getter
public class CaseAlreadyPublished extends RuntimeException {

    private final Long contentItemId;

    public CaseAlreadyPublished(Long contentItemId) {
        super("Кейс уже опубликован");
        this.contentItemId = contentItemId;
    }
}
