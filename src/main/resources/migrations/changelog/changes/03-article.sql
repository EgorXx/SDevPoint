--liquibase formatted sql

--changeset egor.sorokin:create-article-table
CREATE TABLE IF NOT EXISTS article
(
    id         BIGSERIAL PRIMARY KEY,
    user_id    BIGINT        NOT NULL,
    created_at timestamptz   NOT NULL,
    preview    VARCHAR(256)  NOT NULL,
    title      VARCHAR(1024) NOT NULL,
    text       TEXT          NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
    CONSTRAINT unique_title_by_user UNIQUE (user_id, title)
);