--liquibase formatted sql

--changeset egor.sorokin:create-favorite-table
CREATE TABLE IF NOT EXISTS favorite
(
    id              BIGSERIAL PRIMARY KEY,
    content_item_id BIGINT NOT NULL,
    user_id         BIGINT NOT NULL,

    FOREIGN KEY (content_item_id) REFERENCES content_item (id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
    CONSTRAINT favorite_unique_user_content UNIQUE (user_id, content_item_id)
);