--liquibase formatted sql

--changeset egor.sorokin:create-cases-table
CREATE TABLE IF NOT EXISTS cases
(
    id              BIGSERIAL PRIMARY KEY,
    content_item_id BIGINT NOT NULL,
    description     TEXT   NOT NULL,
    solution        TEXT   NOT NULL,

    FOREIGN KEY (content_item_id) REFERENCES content_item (id) ON DELETE CASCADE,
    CONSTRAINT cases_unique_content_item UNIQUE (content_item_id)
);