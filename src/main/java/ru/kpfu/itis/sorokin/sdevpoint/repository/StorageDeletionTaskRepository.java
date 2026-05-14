package ru.kpfu.itis.sorokin.sdevpoint.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import ru.kpfu.itis.sorokin.sdevpoint.entity.StorageDeletionTask;
import ru.kpfu.itis.sorokin.sdevpoint.entity.StorageDeletionTaskStatus;

import java.util.List;

public interface StorageDeletionTaskRepository extends JpaRepository<StorageDeletionTask, Long> {
    @Query(value = """
        SELECT *
        FROM storage_deletion_task sdt
        WHERE sdt.task_status IN :statuses
        ORDER BY updated_at
        LIMIT :limit
        FOR UPDATE SKIP LOCKED
    """, nativeQuery = true)
    List<StorageDeletionTask> findTasks(
            @Param("statuses") List<String> statuses,
            @Param("limit") int limit
    );
}
