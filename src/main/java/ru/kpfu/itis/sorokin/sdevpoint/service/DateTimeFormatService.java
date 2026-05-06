package ru.kpfu.itis.sorokin.sdevpoint.service;

import org.springframework.stereotype.Component;
import ru.kpfu.itis.sorokin.sdevpoint.properties.ContentViewProperties;

import java.time.Instant;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;

@Component
public class DateTimeFormatService {
    private DateTimeFormatter dateTimeFormatter;

    public DateTimeFormatService(ContentViewProperties contentViewProperties) {
        this.dateTimeFormatter = DateTimeFormatter.ofPattern(contentViewProperties.dateFormat())
                .withZone(ZoneId.of(contentViewProperties.timezone()));;
    }

    public String format(Instant time) {
        if (time == null) {return "";}

        return dateTimeFormatter.format(time);
    }
}
