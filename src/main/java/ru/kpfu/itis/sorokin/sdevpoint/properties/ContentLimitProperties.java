package ru.kpfu.itis.sorokin.sdevpoint.properties;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.validation.annotation.Validated;

import java.time.Duration;

@Validated
@ConfigurationProperties(prefix = "app.content.limits")
public record ContentLimitProperties(
        @Positive
        int maxContentItemsPerUser,

        @NotNull
        Duration commentCooldown

) {
}
