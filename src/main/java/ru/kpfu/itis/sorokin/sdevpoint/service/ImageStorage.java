package ru.kpfu.itis.sorokin.sdevpoint.service;

import org.springframework.web.multipart.MultipartFile;
import ru.kpfu.itis.sorokin.sdevpoint.dto.StoredImageInfo;

import java.nio.file.Path;
import java.util.UUID;

public interface ImageStorage {
    StoredImageInfo save(MultipartFile file, Long contentItemId, UUID imageId, String extension);

    byte[] get(String storageKey);

    void delete(String storageKey);
}
