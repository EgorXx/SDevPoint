package ru.kpfu.itis.sorokin.sdevpoint.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.Instant;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "storage_deletion_task")
public class StorageDeletionTask {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "storage_key", nullable = false)
    private String storageKey;

    @Enumerated(EnumType.STRING)
    @Column(name = "target_type", nullable = false)
    private StorageDeletionTargetType targetType;

    @Enumerated(EnumType.STRING)
    @Column(name = "task_status", nullable = false)
    private StorageDeletionTaskStatus taskStatus;

    @Column(name = "attempts", nullable = false)
    private Integer attempts;

    @Column(name = "created_at", nullable = false)
    private Instant createdAt;

    @Column(name = "updated_at", nullable = false)
    private Instant updatedAt;

    public static StorageDeletionTask createFileDeletion(String storageKey) {
        Instant now = Instant.now();

        return new StorageDeletionTask(
                null,
                storageKey,
                StorageDeletionTargetType.FILE,
                StorageDeletionTaskStatus.NEW,
                0,
                now,
                now
        );
    }

    public static StorageDeletionTask createContentDirectoryDeletion(Long contentItemId) {
        Instant now = Instant.now();

        return new StorageDeletionTask(
                null,
                contentItemId.toString(),
                StorageDeletionTargetType.DIRECTORY,
                StorageDeletionTaskStatus.NEW,
                0,
                now,
                now
        );
    }

    public void markFailed() {
        this.taskStatus = StorageDeletionTaskStatus.FAILED;
        this.attempts++;
        this.updatedAt = Instant.now();
    }

    public void markDead() {
        this.taskStatus = StorageDeletionTaskStatus.DEAD;
        this.updatedAt = Instant.now();
    }
}