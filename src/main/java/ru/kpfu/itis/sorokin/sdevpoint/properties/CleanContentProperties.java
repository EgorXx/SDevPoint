package ru.kpfu.itis.sorokin.sdevpoint.properties;

import jakarta.validation.constraints.NotNull;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.validation.annotation.Validated;

import java.time.Duration;

@Validated
@ConfigurationProperties(prefix = "app.clean-content")
public record CleanContentProperties(
        @NotNull
        Duration limitEmptyDraft,

        @NotNull
        Duration limitSavedDraft
) {
}
