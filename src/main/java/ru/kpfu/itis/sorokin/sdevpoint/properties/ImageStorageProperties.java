package ru.kpfu.itis.sorokin.sdevpoint.properties;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "app.image-storage")
public record ImageStorageProperties(
        String path
) {
}
