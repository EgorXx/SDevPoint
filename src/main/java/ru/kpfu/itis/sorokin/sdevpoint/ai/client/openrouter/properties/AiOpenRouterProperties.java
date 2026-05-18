package ru.kpfu.itis.sorokin.sdevpoint.ai.client.openrouter.properties;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.validation.annotation.Validated;

import java.time.Duration;

@Validated
@ConfigurationProperties(prefix = "app.ai.openrouter")
public record AiOpenRouterProperties(
        @NotBlank
        String baseUrl,

        @NotBlank
        String apiKey,

        @NotBlank
        String model,

        @NotNull
        Duration connectTimeout,

        @NotNull
        Duration readTimeout,

        @Min(0)
        @Max(2)
        double temperature,

        @Min(1)
        int maxTokens,

        String siteUrl,

        String siteTitle
) {}
