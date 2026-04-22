--liquibase formatted sql

--changeset egor.sorokin:create-article_image-table
CREATE TABLE IF NOT EXISTS article_image
(
    id            BIGSERIAL PRIMARY KEY,
    article_id    BIGINT       NOT NULL,
    original_name VARCHAR(255) NOT NULL,
    storage_key   VARCHAR(256) NOT NULL,
    size          BIGINT          NOT NULL CHECK (size > 0),
    height        INT          NOT NULL CHECK (height > 0),
    width         INT          NOT NULL CHECK (width > 0),
    content_type  VARCHAR(32)  NOT NULL,
    created_at    timestamptz  NOT NULL,

    FOREIGN KEY (article_id) REFERENCES article (id) ON DELETE CASCADE,
    CONSTRAINT unique_storage_key UNIQUE (storage_key)
);