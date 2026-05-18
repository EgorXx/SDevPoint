package ru.kpfu.itis.sorokin.sdevpoint.config;

import lombok.RequiredArgsConstructor;
import org.springframework.cache.CacheManager;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.cache.RedisCacheConfiguration;
import org.springframework.data.redis.cache.RedisCacheManager;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.data.redis.serializer.GenericJacksonJsonRedisSerializer;
import org.springframework.data.redis.serializer.RedisSerializationContext;
import org.springframework.data.redis.serializer.StringRedisSerializer;
import ru.kpfu.itis.sorokin.sdevpoint.properties.CacheProperties;
import tools.jackson.databind.ObjectMapper;

import java.util.Map;

@Configuration
@EnableCaching
@RequiredArgsConstructor
public class CacheConfig {
    private final CacheProperties cacheProperties;

    @Bean
    public CacheManager cacheManager(RedisConnectionFactory connectionFactory, ObjectMapper objectMapper) {
        RedisCacheConfiguration defaultConfig = RedisCacheConfiguration.defaultCacheConfig()
                .entryTtl(cacheProperties.defaultTtl())
                .disableCachingNullValues()
                .prefixCacheNameWith(cacheProperties.prefixCacheName())
                .serializeKeysWith(
                        RedisSerializationContext.SerializationPair.fromSerializer(new StringRedisSerializer())
                )
                .serializeValuesWith(
                        RedisSerializationContext.SerializationPair.fromSerializer(
                                GenericJacksonJsonRedisSerializer.builder()
                                        .typePropertyName("@class")
                                        .enableUnsafeDefaultTyping()
                                        .build()
                        )
                );

        Map<String, RedisCacheConfiguration> cacheConfigurations = Map.of(
                cacheProperties.aiSummary().cacheName(),
                defaultConfig.entryTtl(cacheProperties.aiSummary().ttl())
        );

        return RedisCacheManager.builder(connectionFactory)
                .cacheDefaults(defaultConfig)
                .withInitialCacheConfigurations(cacheConfigurations)
                .transactionAware()
                .build();
    }
}
