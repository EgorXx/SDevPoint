--liquibase formatted sql

--changeset egor.sorokin:create-content-item-table
CREATE TABLE IF NOT EXISTS content_item
(
    id             BIGSERIAL PRIMARY KEY,
    user_id        BIGINT       NOT NULL,
    title          VARCHAR(256) NOT NULL,
    item_type      VARCHAR(32)  NOT NULL,
    created_at     TIMESTAMPTZ  NOT NULL,
    updated_at     TIMESTAMPTZ  NOT NULL,
    content_status VARCHAR(32)  NOT NULL,
    visibility     VARCHAR(32)  NOT NULL,
    preview        VARCHAR(512) NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users (id),
    CONSTRAINT visibility_check CHECK ( visibility IN ('PUBLIC', 'PRIVATE') ),
    CONSTRAINT item_type_check CHECK ( item_type IN ('ARTICLE', 'CASE') ),
    CONSTRAINT content_status_check CHECK ( content_status IN ('DRAFT', 'PUBLISHED', 'PENDING_REVIEW', 'REJECTED') ),
    CONSTRAINT unique_title_by_user UNIQUE (user_id, title)
);