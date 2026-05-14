--liquibase formatted sql

--changeset egor.sorokin:add-storage-deletion-task--indexes:indexes
CREATE INDEX IF NOT EXISTS idx_storage_task_active_updated_at
    ON storage_deletion_task (updated_at)
    WHERE task_status IN ('NEW', 'FAILED');