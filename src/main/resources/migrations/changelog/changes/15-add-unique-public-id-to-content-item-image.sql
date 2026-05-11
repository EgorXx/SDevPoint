--liquibase formatted sql

--changeset egor.sorokin:add-unique-public-id-to-content-item-image:constraint
ALTER TABLE sdevpoint.public.content_item_image
ADD CONSTRAINT unique_content_item_image_public_id UNIQUE (public_id);