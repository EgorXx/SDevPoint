--liquibase formatted sql

--changeset egor.sorokin:create-reaction-table
CREATE TABLE IF NOT EXISTS reaction
(
    id              BIGSERIAL PRIMARY KEY,
    user_id         BIGINT      NOT NULL,
    content_item_id BIGINT      NOT NULL,
    reaction_type   VARCHAR(32) NOT NULL,

    FOREIGN KEY (content_item_id) REFERENCES content_item (id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
    CONSTRAINT reaction_unique_user_content UNIQUE (user_id, content_item_id),
    CONSTRAINT reaction_type_check CHECK ( reaction_type IN ('LIKE', 'DISLIKE') )
);