package ru.kpfu.itis.sorokin.sdevpoint.ai.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import ru.kpfu.itis.sorokin.sdevpoint.ai.entity.AiUsageType;
import ru.kpfu.itis.sorokin.sdevpoint.ai.properties.AiUsageLimitProperties;
import ru.kpfu.itis.sorokin.sdevpoint.exception.BadRequestException;
import ru.kpfu.itis.sorokin.sdevpoint.redis.CooldownStore;
import ru.kpfu.itis.sorokin.sdevpoint.redis.WindowRateLimitStore;
import ru.kpfu.itis.sorokin.sdevpoint.service.DateTimeFormatService;

import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class AiUsageLimitService {

    private final CooldownStore cooldownStore;
    private final WindowRateLimitStore rateLimitStore;
    private final DateTimeFormatService dateTimeFormatService;
    private final AiUsageLimitProperties properties;

    public void checkAndConsume(Long userId, AiUsageType usageType) {
        AiUsageLimitProperties.Limit limit = resolveLimit(usageType);

        String subject = buildSubject(userId, usageType);

        if (!cooldownStore.tryAcquire(subject, limit.cooldown())) {
            long ttl = cooldownStore.getRemainingSeconds(subject);
            String waitTime = dateTimeFormatService.formatRemainingTime(ttl);

            throw new BadRequestException(
                    "AI-запросы этого типа можно отправлять не так часто. Попробуйте через " + waitTime
            );
        }

        String window = LocalDate.now().toString();

        long count = rateLimitStore.incrementRate(
                subject,
                window,
                durationUntilNextDay()
        );

        if (count > limit.dailyLimit()) {
            long ttl = rateLimitStore.getRemainingSeconds(subject, window);
            String waitTime = dateTimeFormatService.formatRemainingTime(ttl);

            throw new BadRequestException(
                    "Превышен дневной лимит AI-запросов этого типа. Лимит обновится через " + waitTime
            );
        }
    }

    private AiUsageLimitProperties.Limit resolveLimit(AiUsageType usageType) {
        return switch (usageType) {
            case SUMMARY -> properties.summary();
            case EXPLAIN_TERM -> properties.explainTerm();
        };
    }

    private String buildSubject(Long userId, AiUsageType usageType) {
        return "ai:" + usageType.name().toLowerCase() + ":user:" + userId;
    }

    private Duration durationUntilNextDay() {
        LocalDateTime now = LocalDateTime.now();

        LocalDateTime nextDayStart = now.toLocalDate()
                .plusDays(1)
                .atStartOfDay();

        return Duration.between(now, nextDayStart);
    }
}
