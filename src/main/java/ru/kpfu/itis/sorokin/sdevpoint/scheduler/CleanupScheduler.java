package ru.kpfu.itis.sorokin.sdevpoint.scheduler;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import ru.kpfu.itis.sorokin.sdevpoint.service.clean.DraftCleanupService;
import ru.kpfu.itis.sorokin.sdevpoint.service.clean.ImageCleanupService;

@Slf4j
@Component
@RequiredArgsConstructor
public class CleanupScheduler {
    private final DraftCleanupService draftCleanupService;
    private final ImageCleanupService imageCleanupService;

    @Scheduled(cron = "${app.scheduler.cleanup-drafts-cron}")
    public void cleanupDrafts() {
        log.info("Starting draft cleaning");
        draftCleanupService.cleanupExpiredDrafts();
    }

    @Scheduled(cron = "${app.scheduler.cleanup-images-cron}")
    public void cleanupImages() {
        log.info("Starting images cleaning");
        imageCleanupService.cleanImages();
    }
}
