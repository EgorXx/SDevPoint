package ru.kpfu.itis.sorokin.sdevpoint.ai.properties;

import jakarta.validation.Valid;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.validation.annotation.Validated;

import java.time.Duration;

@Validated
@ConfigurationProperties(prefix = "app.ai.usage-limit")
public record AiUsageLimitProperties(
        @Valid
        @NotNull
        Limit summary,

        @Valid
        @NotNull
        Limit explainTerm
) {
    public record Limit(
            @NotNull
            Duration cooldown,

            @Min(1)
            int dailyLimit
    ) {}
}
