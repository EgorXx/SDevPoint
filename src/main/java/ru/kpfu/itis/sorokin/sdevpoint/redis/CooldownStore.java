package ru.kpfu.itis.sorokin.sdevpoint.redis;

import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import java.time.Duration;

@Service
@RequiredArgsConstructor
public class CooldownStore {
    private final StringRedisTemplate redisTemplate;

    public boolean tryAcquire(String subjectId, Duration cooldown) {
        String key = "cooldown:" + subjectId;

        Boolean created = redisTemplate.opsForValue()
                .setIfAbsent(key, "1", cooldown);

        return Boolean.TRUE.equals(created);
    }

    public long getRemainingSeconds(String subjectId) {
        String key = "cooldown:" + subjectId;
        Long ttl = redisTemplate.getExpire(key);
        return ttl == null ? -1 : ttl;
    }
}
