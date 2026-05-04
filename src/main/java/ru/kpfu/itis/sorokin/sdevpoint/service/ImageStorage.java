package ru.kpfu.itis.sorokin.sdevpoint.service;

import org.springframework.web.multipart.MultipartFile;
import ru.kpfu.itis.sorokin.sdevpoint.dto.StoredImageInfo;

import java.nio.file.Path;

public interface ImageStorage {
    StoredImageInfo save(MultipartFile file);

    byte[] get(String storageKey);
}
