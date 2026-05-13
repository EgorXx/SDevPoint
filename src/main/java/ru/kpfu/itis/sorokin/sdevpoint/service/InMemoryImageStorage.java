package ru.kpfu.itis.sorokin.sdevpoint.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import ru.kpfu.itis.sorokin.sdevpoint.dto.StoredImageInfo;
import ru.kpfu.itis.sorokin.sdevpoint.exception.ImageStorageException;
import ru.kpfu.itis.sorokin.sdevpoint.properties.ImageStorageProperties;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.*;
import java.nio.file.attribute.BasicFileAttributes;
import java.util.UUID;

@Slf4j
@Service
public class InMemoryImageStorage implements ImageStorage {
    private final Path root;
    private static final String FILE_PREFIX = "content-items/";

    public InMemoryImageStorage(ImageStorageProperties imageStorageProperties) {
        this.root = Path.of(imageStorageProperties.path()).toAbsolutePath().normalize();
    }

    @Override
    public StoredImageInfo save(
            MultipartFile file,
            Long contentItemId,
            UUID imageId,
            String extension) {

        String storageKey =  FILE_PREFIX + "%d/%s%s"
                .formatted(contentItemId, imageId, extension);

        Path targetPath = root.resolve(storageKey).normalize();

        if (!targetPath.startsWith(root)) {
            throw new ImageStorageException("Invalid image path");
        }

        try {
            Files.createDirectories(targetPath.getParent());

            try (InputStream is = file.getInputStream()) {
                Files.copy(is, targetPath, StandardCopyOption.REPLACE_EXISTING);
            }

            return new StoredImageInfo(storageKey);
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

    @Override
    public void deleteDirectory(String contentItemId) {
        String storageKey = FILE_PREFIX + contentItemId;

        Path directoryPath = root.resolve(storageKey).normalize();

        if (Files.notExists(directoryPath)) {
            return;
        }

        try {
            Files.walkFileTree(directoryPath, new SimpleFileVisitor<>() {

                @Override
                public FileVisitResult visitFile(Path file, BasicFileAttributes attrs)
                        throws IOException {
                    Files.delete(file);
                    return FileVisitResult.CONTINUE;
                }

                @Override
                public FileVisitResult postVisitDirectory(Path dir, IOException exc)
                        throws IOException {
                    if (exc != null) {
                        throw exc;
                    }

                    Files.delete(dir);
                    return FileVisitResult.CONTINUE;
                }
            });
        } catch (IOException e) {
            throw new ImageStorageException("Failed to delete directory: " + directoryPath);
        }
    }
}
