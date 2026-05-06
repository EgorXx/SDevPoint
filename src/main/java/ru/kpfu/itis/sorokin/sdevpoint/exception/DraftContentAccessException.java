package ru.kpfu.itis.sorokin.sdevpoint.exception;

import ru.kpfu.itis.sorokin.sdevpoint.entity.ItemType;

public class DraftContentAccessException extends RuntimeException {
    private final Long draftId;
    private final ItemType itemType;

    public DraftContentAccessException(Long draftId, ItemType itemType) {
        super("Контент является черновиком");
        this.draftId = draftId;
        this.itemType = itemType;
    }

    public Long getDraftId() {
        return draftId;
    }

    public ItemType getItemType() {
        return itemType;
    }
}
