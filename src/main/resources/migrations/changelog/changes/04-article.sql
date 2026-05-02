--liquibase formatted sql

--changeset egor.sorokin:create-article-table
CREATE TABLE IF NOT EXISTS article
(
    id              BIGSERIAL PRIMARY KEY,
    content_item_id BIGINT NOT NULL,
    text            TEXT   NOT NULL,

    FOREIGN KEY (content_item_id) REFERENCES content_item(id) ON DELETE CASCADE,
    CONSTRAINT article_unique_content_item UNIQUE (content_item_id)
);