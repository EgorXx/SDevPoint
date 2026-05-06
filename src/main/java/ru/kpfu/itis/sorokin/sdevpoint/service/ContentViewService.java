package ru.kpfu.itis.sorokin.sdevpoint.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import ru.kpfu.itis.sorokin.sdevpoint.markdown.MarkdownTextParser;
import ru.kpfu.itis.sorokin.sdevpoint.properties.ContentViewProperties;

import java.time.Instant;

@Service
@RequiredArgsConstructor
public class ContentViewService {
    private final DateTimeFormatService dateTimeFormatService;
    private final ContentViewProperties contentViewProperties;
    private final MarkdownTextParser markdownTextParser;

    public String formatDate(Instant time) {
        if (time == null) {return "";}

        return dateTimeFormatService.format(time);
    }

    public String formatPreviewFromText(String text) {
        return markdownTextParser.parse(text, contentViewProperties.previewSize());
    }
}
