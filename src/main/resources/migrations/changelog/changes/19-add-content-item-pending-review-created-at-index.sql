--liquibase formatted sql

--changeset egor.sorokin:add-content-item-pending-review-created-at-indexes:indexes
CREATE INDEX IF NOT EXISTS idx_content_item_pending_review_created_at
    ON content_item (created_at DESC)
    WHERE content_status = 'PENDING_REVIEW';