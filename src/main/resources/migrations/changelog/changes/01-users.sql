--liquibase formatted sql

--changeset egor.sorokin:create-users-table
CREATE TABLE IF NOT EXISTS users
(
    id             BIGSERIAL PRIMARY KEY,
    username       VARCHAR(256) NOT NULL,
    email          VARCHAR(256) NOT NULL,
    password       VARCHAR(256) NOT NULL,
    role           VARCHAR(32)  NOT NULL,
    email_verified boolean      NOT NULL,
    avatar_key     VARCHAR(100) NOT NULL,

    CONSTRAINT unique_email UNIQUE (email),
    CONSTRAINT role_check CHECK ( role IN ('ROLE_USER', 'ROLE_ADMIN') )
);