package ru.kpfu.itis.sorokin.sdevpoint.properties;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "mail")
public record MailProperties(
        String sender,
        String from,
        String subject,
        String baseUrl
) {}
