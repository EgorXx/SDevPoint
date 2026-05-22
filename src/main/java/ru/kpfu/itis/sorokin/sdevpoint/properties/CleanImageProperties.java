package ru.kpfu.itis.sorokin.sdevpoint.properties;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.validation.annotation.Validated;

@Validated
@ConfigurationProperties(prefix = "app.clean.image")
public record CleanImageProperties(
        @NotNull
        @Min(1)
        Integer limitTasks,

        @NotNull
        @Min(1)
        Integer limitAttempts
) {
}
