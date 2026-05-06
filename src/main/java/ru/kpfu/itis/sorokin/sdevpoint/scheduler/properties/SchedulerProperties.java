package ru.kpfu.itis.sorokin.sdevpoint.scheduler.properties;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "app.scheduler")
public record SchedulerProperties(
) {}
