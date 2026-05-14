package ru.kpfu.itis.sorokin.sdevpoint.markdown;

import org.springframework.stereotype.Component;

import java.util.Collection;
import java.util.HashSet;
import java.util.Set;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Component
public class MarkdownImageReferenceExtractor {
    private static final Pattern IMAGE_URL_PATTERN =
            Pattern.compile("/api/image/([0-9a-fA-F\\-]{36})");

    public Set<UUID> extractPublicIds(Collection<String> markdownTexts) {
        Set<UUID> result = new HashSet<>();

        for (String markdown : markdownTexts) {
            if (markdown == null || markdown.isBlank()) {
                continue;
            }

            Matcher matcher = IMAGE_URL_PATTERN.matcher(markdown);

            while (matcher.find()) {
                try {
                    result.add(UUID.fromString(matcher.group(1)));
                } catch (IllegalArgumentException e) {
                    // Игнор некорректных UUID
                }
            }
        }

        return result;
    }
}
