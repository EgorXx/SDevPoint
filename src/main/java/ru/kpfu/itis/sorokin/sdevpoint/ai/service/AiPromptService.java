package ru.kpfu.itis.sorokin.sdevpoint.ai.service;

import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;
import lombok.RequiredArgsConstructor;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.stereotype.Service;
import ru.kpfu.itis.sorokin.sdevpoint.ai.exception.AiPromptsProperties;

import java.io.IOException;
import java.io.StringWriter;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class AiPromptService {
    private final Configuration freemarkerConfiguration;
    private final AiPromptsProperties aiPromptsProperties;

    public String buildSummarySystemPrompt() {
        return render(aiPromptsProperties.summarySystemPromptPath(), Map.of());
    }

    public String buildSummaryUserPrompt(String content) {
        return render(aiPromptsProperties.summaryUserPromptPath(), Map.of(
                "content", content
        ));
    }

    public String buildExplainTermSystemPrompt() {
        return render(aiPromptsProperties.explainTermSystemPromptPath(), Map.of());
    }

    public String buildExplainTermUserPrompt(String term, String content) {
        return render(aiPromptsProperties.explainTermUserPromptPath(), Map.of(
                "term", term,
                "content", content
        ));
    }

    private String render(String templatePath, Map<String, Object> model) {
        try {
            Template template = freemarkerConfiguration.getTemplate(templatePath);

            StringWriter writer = new StringWriter();
            template.process(model, writer);

            return writer.toString();
        } catch (IOException | TemplateException e) {
            throw new IllegalStateException("Не удалось собрать AI prompt: " + templatePath, e);
        }
    }
}
