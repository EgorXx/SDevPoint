package ru.kpfu.itis.sorokin.sdevpoint.properties;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.validation.annotation.Validated;

import java.time.Duration;

@Validated
@ConfigurationProperties(prefix = "app.email-verification")
public record EmailVerificationProperties(
        @NotNull
        Duration tokenLifetime,

        @NotNull
        Duration resendCooldown,

        @NotNull
        Duration rateLimitWindow,

        @Min(1)
        int rateLimitCount
) {}
