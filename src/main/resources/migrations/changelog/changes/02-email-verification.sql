--liquibase formatted sql

--changeset egor.sorokin:create-email_verification-table
CREATE TABLE IF NOT EXISTS email_verification
(
    id        BIGSERIAL PRIMARY KEY,
    token     UUID        NOT NULL,
    user_id   BIGINT      NOT NULL,
    expires_at timestamptz NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
    CONSTRAINT unique_token UNIQUE (token),
    CONSTRAINT unique_user_id UNIQUE (user_id)
);