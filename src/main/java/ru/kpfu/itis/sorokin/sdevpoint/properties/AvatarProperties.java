package ru.kpfu.itis.sorokin.sdevpoint.properties;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "app.avatar")
public record AvatarProperties(
        int count,
        String urlPrefix,
        String filePrefix,
        String extension
) {
}
