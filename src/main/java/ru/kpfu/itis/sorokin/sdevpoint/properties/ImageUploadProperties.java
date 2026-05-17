package ru.kpfu.itis.sorokin.sdevpoint.properties;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.util.unit.DataSize;

@ConfigurationProperties(prefix = "app.image.upload")
public record ImageUploadProperties(
        DataSize maxFileSize,
        DataSize maxTotalSizePerContent,
        DataSize maxTotalSizePerUser
) {}
