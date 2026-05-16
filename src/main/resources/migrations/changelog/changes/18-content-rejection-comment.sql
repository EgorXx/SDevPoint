--liquibase formatted sql

--changeset egor.sorokin:create-content-rejection-comment-table
CREATE TABLE IF NOT EXISTS content_rejection_comment (
    id BIGSERIAL PRIMARY KEY,
    content_item_id BIGINT NOT NULL,
    comment TEXT NOT NULL,
    created_at timestamptz NOT NULL,

    FOREIGN KEY (content_item_id) REFERENCES content_item (id) ON DELETE CASCADE,
    CONSTRAINT unique_content_rejection_comment_content_item UNIQUE (content_item_id)
)
