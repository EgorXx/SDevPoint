package ru.kpfu.itis.sorokin.sdevpoint.properties;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.validation.annotation.Validated;

@Validated
@ConfigurationProperties(prefix = "app.bootstrap.admin")
public record AdminBootstrapProperties(
        boolean enabled,

        @NotBlank
        String username,

        @NotBlank
        String email,

        @NotBlank
        @Size(min = 4, max = 32)
        String password
) {
}
