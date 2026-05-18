package ru.kpfu.itis.sorokin.sdevpoint.properties;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.validation.annotation.Validated;

import java.time.Duration;

@Validated
@ConfigurationProperties(prefix = "app.cache")
public record CacheProperties(
        @NotNull
        String prefixCacheName,

        @NotNull
        Duration defaultTtl,

        @Valid
        SpecificCache aiSummary
) {
    public record SpecificCache(
            @NotNull
            String cacheName,


            @NotNull
            Duration ttl
    ) {}
}
