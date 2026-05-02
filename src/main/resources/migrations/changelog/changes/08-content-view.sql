--liquibase formatted sql

--changeset egor.sorokin:create-content-view-table
CREATE TABLE IF NOT EXISTS content_view
(
    id              BIGSERIAL PRIMARY KEY,
    content_item_id BIGINT NOT NULL,
    user_id         BIGINT NOT NULL,

    FOREIGN KEY (content_item_id) REFERENCES content_item (id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
    CONSTRAINT content_view_unique_user_content UNIQUE (user_id, content_item_id)
);