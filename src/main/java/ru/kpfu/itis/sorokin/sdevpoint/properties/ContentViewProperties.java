package ru.kpfu.itis.sorokin.sdevpoint.properties;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "app.content-view")
public record ContentViewProperties(
        String dateFormat,
        String timezone,
        int previewSize
) {
}