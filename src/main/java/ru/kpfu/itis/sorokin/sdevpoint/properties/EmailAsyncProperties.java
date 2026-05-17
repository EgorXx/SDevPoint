package ru.kpfu.itis.sorokin.sdevpoint.properties;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.validation.annotation.Validated;

@Validated
@ConfigurationProperties(prefix = "app.async.email")
public record EmailAsyncProperties(
        @Min(1)
        int corePoolSize,

        @Min(1)
        int maxPoolSize,

        @Min(0)
        int queueCapacity,

        @NotBlank
        String threadNamePrefix,

        boolean waitForTasksToCompleteOnShutdown,

        @Min(0)
        int awaitTerminationSeconds
) {}
