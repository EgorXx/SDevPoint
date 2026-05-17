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
                .withZone(ZoneId.of(contentViewProperties.timezone()));
    }

    public String format(Instant time) {
        if (time == null) {return "";}

        return dateTimeFormatter.format(time);
    }

    public String formatRemainingTime(long ttlSeconds) {
        if (ttlSeconds <= 0) {
            return "несколько секунд";
        }

        if (ttlSeconds < 60) {
            return ttlSeconds + " " + plural(
                    ttlSeconds,
                    "секунду",
                    "секунды",
                    "секунд"
            );
        }

        long minutes = ttlSeconds / 60;
        long seconds = ttlSeconds % 60;

        if (minutes < 60) {
            if (seconds == 0) {
                return minutes + " " + plural(
                        minutes,
                        "минуту",
                        "минуты",
                        "минут"
                );
            }

            return minutes + " " + plural(
                    minutes,
                    "минуту",
                    "минуты",
                    "минут"
            ) + " " + seconds + " " + plural(
                    seconds,
                    "секунду",
                    "секунды",
                    "секунд"
            );
        }

        long hours = minutes / 60;
        long remainingMinutes = minutes % 60;

        if (remainingMinutes == 0) {
            return hours + " " + plural(
                    hours,
                    "час",
                    "часа",
                    "часов"
            );
        }

        return hours + " " + plural(
                hours,
                "час",
                "часа",
                "часов"
        ) + " " + remainingMinutes + " " + plural(
                remainingMinutes,
                "минуту",
                "минуты",
                "минут"
        );
    }

    private String plural(long value, String one, String few, String many) {
        long mod10 = value % 10;
        long mod100 = value % 100;

        if (mod10 == 1 && mod100 != 11) {
            return one;
        }

        if (mod10 >= 2 && mod10 <= 4 && (mod100 < 12 || mod100 > 14)) {
            return few;
        }

        return many;
    }
}
