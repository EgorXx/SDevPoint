--liquibase formatted sql

--changeset egor.sorokin:create-content-item-cleanup-drafts-indexes:indexes
CREATE INDEX idx_content_item_empty_draft_created_at ON content_item (created_at)
WHERE content_item.content_status = 'DRAFT' AND content_item.preview = '';

CREATE INDEX idx_content_item_draft_created_at ON content_item (updated_at)
WHERE content_item.content_status = 'DRAFT';