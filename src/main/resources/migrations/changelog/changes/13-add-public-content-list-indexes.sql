--liquibase formatted sql

--changeset egor.sorokin:add-public-content-list-indexes:indexes
CREATE INDEX idx_content_item_visibility
    ON content_item (item_type, created_at, id)
    WHERE content_status = 'PUBLISHED'
        AND visibility = 'PUBLIC';