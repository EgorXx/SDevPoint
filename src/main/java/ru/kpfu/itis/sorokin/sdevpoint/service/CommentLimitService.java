package ru.kpfu.itis.sorokin.sdevpoint.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import ru.kpfu.itis.sorokin.sdevpoint.exception.BadRequestException;
import ru.kpfu.itis.sorokin.sdevpoint.properties.ContentLimitProperties;
import ru.kpfu.itis.sorokin.sdevpoint.redis.CooldownStore;

@Service
@RequiredArgsConstructor
public class CommentLimitService {

    private final CooldownStore cooldownStore;
    private final DateTimeFormatService dateTimeFormatService;
    private final ContentLimitProperties contentLimitProperties;

    public void checkCommentCooldown(Long userId) {
        String subject = "case-comment:user:" + userId;

        if (!cooldownStore.tryAcquire(subject, contentLimitProperties.commentCooldown())) {
            long ttl = cooldownStore.getRemainingSeconds(subject);
            String waitTime = dateTimeFormatService.formatRemainingTime(ttl);

            throw new BadRequestException(
                    "Комментарий можно отправлять не чаще одного раза в минуту. Попробуйте через " + waitTime
            );
        }
    }
}
