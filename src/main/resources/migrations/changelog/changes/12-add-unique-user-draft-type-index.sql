--liquibase formatted sql

--changeset egor.sorokin:add-unique-user-draft-type-index:indexes
CREATE UNIQUE INDEX idx_unique_draft_user_by_item
    ON content_item (user_id, item_type)
    WHERE content_status = 'DRAFT';