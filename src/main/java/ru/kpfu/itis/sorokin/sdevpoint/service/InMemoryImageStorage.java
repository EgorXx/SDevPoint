package ru.kpfu.itis.sorokin.sdevpoint.service;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import ru.kpfu.itis.sorokin.sdevpoint.dto.StoredImageInfo;
import ru.kpfu.itis.sorokin.sdevpoint.exception.ImageStorageException;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.UUID;

@Service
public class InMemoryImageStorage implements ImageStorage {
    private static final Path root = Path.of("images").toAbsolutePath().normalize();

    @Override
    public StoredImageInfo save(MultipartFile file) {
        String extension = extractExtension(file.getOriginalFilename());
        String generatedName = UUID.randomUUID() + extension;

        Path imagePath = root.resolve(generatedName).normalize();

        if (!imagePath.startsWith(root)) {
            throw new ImageStorageException("Invalid image path");
        }

        try {
            Files.createDirectories(root);

            try (InputStream is = file.getInputStream()) {
                Files.copy(is, imagePath);
            }

            return new StoredImageInfo(generatedName);
            
        } catch (IOException e) {
            throw new ImageStorageException("Failed to store file: " + e);
        }
    }

    @Override
    public byte[] get(String storageKey) {
        Path imagePath = root.resolve(storageKey).normalize();

        if (!imagePath.startsWith(root)) {
            throw new ImageStorageException("Invalid image path");
        }

        try {
            return Files.readAllBytes(imagePath);
        } catch (IOException e) {
            throw new ImageStorageException("Error loading an image, storageKey=" + storageKey);
        }
    }

    @Override
    public void delete(String storageKey) {
        Path imagePath = root.resolve(storageKey).normalize();

        if (!imagePath.startsWith(root)) {
            throw new ImageStorageException("Invalid image path");
        }

        try {
            Files.delete(imagePath);
        } catch (IOException e) {
            throw new ImageStorageException("Error deleting an image, storageKey=" + storageKey);
        }
    }

    private String extractExtension(String originalFilename) {
        if (originalFilename == null) {
            return "";
        }

        int dotIndex = originalFilename.lastIndexOf('.');
        if (dotIndex < 0) {
            return "";
        }

        return originalFilename.substring(dotIndex);
    }
}
