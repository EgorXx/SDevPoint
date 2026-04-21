package ru.kpfu.itis.sorokin.sdevpoint.redis;

import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import java.time.Duration;

@Service
@RequiredArgsConstructor
public class WindowRateLimitStore {
    private final StringRedisTemplate redisTemplate;

    public long incrementRate(String subjectId, String windowId, Duration ttl) {
        String key = "attempts:" + subjectId + ":" + windowId;

        Long count = redisTemplate.opsForValue().increment(key);

        if (count == 1) {
            redisTemplate.expire(key, ttl);
        }

        return count;
    }

    public long getRemainingSeconds(String subjectId, String windowId) {
        String key = "attempts:" + subjectId + ":" + windowId;
        Long ttl = redisTemplate.getExpire(key);
        return ttl == null ? -1 : ttl;
    }
}
