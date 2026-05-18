package ru.kpfu.itis.sorokin.sdevpoint.ai.properties;

import jakarta.validation.constraints.Min;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.validation.annotation.Validated;

@Validated
@ConfigurationProperties(prefix = "app.ai.content")
public record AiContentProperties(
        @Min(1000)
        int maxSummaryInputChars,

        @Min(1000)
        int maxExplainInputChars,

        @Min(1)
        int maxTermLength
) {}
