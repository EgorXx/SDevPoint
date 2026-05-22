package ru.kpfu.itis.sorokin.sdevpoint.service.clean;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ru.kpfu.itis.sorokin.sdevpoint.entity.StorageDeletionTask;
import ru.kpfu.itis.sorokin.sdevpoint.entity.StorageDeletionTaskStatus;
import ru.kpfu.itis.sorokin.sdevpoint.properties.CleanImageProperties;
import ru.kpfu.itis.sorokin.sdevpoint.repository.StorageDeletionTaskRepository;
import ru.kpfu.itis.sorokin.sdevpoint.service.ImageStorage;

import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class ImageCleanupService {
    private final StorageDeletionTaskRepository storageDeletionTaskRepository;
    private final ImageStorage imageStorage;
    private final CleanImageProperties cleanImageProperties;

    @Transactional
    public void cleanImages() {
        List<StorageDeletionTask> tasks = storageDeletionTaskRepository
                .findTasks(
                        List.of(
                                StorageDeletionTaskStatus.NEW.name(),
                                StorageDeletionTaskStatus.FAILED.name()
                        ),
                        cleanImageProperties.limitTasks()
                );

        for (StorageDeletionTask task : tasks) {
            processTask(task);
        }
    }

    private void processTask(StorageDeletionTask task) {
        if (task.getAttempts() >= cleanImageProperties.limitAttempts()) {
            task.markDead();
            log.warn(
                    "Storage deletion task marked as DEAD, taskId={}, storageKey={}, targetType={}, attempts={}",
                    task.getId(),
                    task.getStorageKey(),
                    task.getTargetType(),
                    task.getAttempts()
            );
            return;
        }

        try {
            deleteStorageTarget(task);

            storageDeletionTaskRepository.delete(task);

            log.info(
                    "Storage deletion task completed, taskId={}, storageKey={}, targetType={}",
                    task.getId(),
                    task.getStorageKey(),
                    task.getTargetType()
            );
        } catch (Exception e) {
            task.markFailed();

            log.warn(
                    "Couldn't delete storage target, taskId={}, storageKey={}, targetType={}, attempts={}",
                    task.getId(),
                    task.getStorageKey(),
                    task.getTargetType(),
                    task.getAttempts(),
                    e
            );
        }
    }

    private void deleteStorageTarget(StorageDeletionTask task) {
        switch (task.getTargetType()) {
            case FILE -> imageStorage.delete(task.getStorageKey());
            case DIRECTORY -> imageStorage.deleteDirectory(task.getStorageKey());
            default -> throw new IllegalArgumentException("Invalid StorageDeletionTaskTargetType");
        }
    }
}
