package ru.kpfu.itis.sorokin.sdevpoint.scheduler;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import ru.kpfu.itis.sorokin.sdevpoint.service.DraftCleanupService;

@Slf4j
@Component
@RequiredArgsConstructor
public class DraftCleanupScheduler {
    private final DraftCleanupService draftCleanupService;

    @Scheduled(cron = "${app.scheduler.cleanup-drafts-cron}")
    public void cleanupDrafts() {
        log.info("Starting draft cleaning");
        draftCleanupService.cleanupExpiredDrafts();
    }
}
