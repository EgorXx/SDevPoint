package ru.kpfu.itis.sorokin.sdevpoint.ai.service;

import org.springframework.stereotype.Component;

@Component
public class AiTextProcessor {

    public String trimToLimit(String text, int maxChars) {
        if (text == null || text.isBlank()) {
            return "";
        }

        String normalized = text
                .replaceAll("\\s+", " ")
                .trim();

        int length = normalized.codePointCount(0, normalized.length());

        if (length <= maxChars) {
            return normalized;
        }

        int endIndex = normalized.offsetByCodePoints(0, maxChars);

        return normalized.substring(0, endIndex).stripTrailing();
    }
}
