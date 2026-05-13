--liquibase formatted sql

--changeset egor.sorokin:create-storage-deletion-task-table
CREATE TABLE IF NOT EXISTS storage_deletion_task
(
    id          BIGSERIAL PRIMARY KEY,
    storage_key VARCHAR(256) NOT NULL,
    target_type VARCHAR(32)  NOT NULL,
    task_status VARCHAR(32)  NOT NULL,
    attempts    INT          NOT NULL DEFAULT 0,
    created_at  timestamptz  NOT NULL,
    updated_at  timestamptz  NOT NULL,

    CONSTRAINT storage_deletion_task_status_check
        CHECK (task_status IN ('NEW', 'FAILED', 'DEAD')),

    CONSTRAINT storage_deletion_task_target_type_check
        CHECK (target_type IN ('FILE', 'DIRECTORY'))
);