--liquibase formatted sql

--changeset egor.sorokin:create-content-item-image-table
CREATE TABLE IF NOT EXISTS content_item_image
(
    id              BIGSERIAL PRIMARY KEY,
    content_item_id BIGINT       NOT NULL,
    original_name   VARCHAR(512) NOT NULL,
    storage_key     VARCHAR(512) NOT NULL,
    size            BIGINT       NOT NULL,
    height          INTEGER      NOT NULL,
    width           INTEGER      NOT NULL,
    content_type    VARCHAR(128) NOT NULL,
    created_at      TIMESTAMPTZ  NOT NULL,
    public_id       uuid         NOT NULL,

    FOREIGN KEY (content_item_id) REFERENCES content_item (id) ON DELETE CASCADE,
    CONSTRAINT unique_storage_key UNIQUE (storage_key),
    CONSTRAINT unique_content_item_image_public_id UNIQUE (public_id)
);