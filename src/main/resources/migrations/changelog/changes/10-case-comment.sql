--liquibase formatted sql

--changeset egor.sorokin:create-case-comment-table
CREATE TABLE IF NOT EXISTS case_comment
(
    id         BIGSERIAL PRIMARY KEY,
    user_id    BIGINT      NOT NULL,
    case_id    BIGINT      NOT NULL,
    text       TEXT        NOT NULL,
    created_at TIMESTAMPTZ NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
    FOREIGN KEY (case_id) REFERENCES cases (id) ON DELETE CASCADE
);