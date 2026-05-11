--liquibase formatted sql

--changeset egor.sorokin:add-case-comment-indexes:indexes
CREATE INDEX idx_case_comment_created_at_case_id
    ON case_comment (case_id, created_at);