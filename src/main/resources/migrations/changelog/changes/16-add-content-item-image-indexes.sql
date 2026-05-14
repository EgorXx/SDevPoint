--liquibase formatted sql

--changeset egor.sorokin:add-content-item-image-indexes:indexes
CREATE INDEX IF NOT EXISTS idx_content_item_image_content_item_id
    ON content_item_image (content_item_id);