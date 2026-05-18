package ru.kpfu.itis.sorokin.sdevpoint.ai.client.openrouter;

import com.fasterxml.jackson.core.JsonProcessingException;
import lombok.extern.slf4j.Slf4j;
import okhttp3.*;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;
import ru.kpfu.itis.sorokin.sdevpoint.ai.client.AiClient;
import ru.kpfu.itis.sorokin.sdevpoint.ai.client.openrouter.dto.OpenRouterChatRequest;
import ru.kpfu.itis.sorokin.sdevpoint.ai.client.openrouter.dto.OpenRouterChatResponse;
import ru.kpfu.itis.sorokin.sdevpoint.ai.client.openrouter.dto.OpenRouterMessage;
import ru.kpfu.itis.sorokin.sdevpoint.ai.client.openrouter.properties.AiOpenRouterProperties;
import ru.kpfu.itis.sorokin.sdevpoint.ai.dto.AiCompletionRequest;
import ru.kpfu.itis.sorokin.sdevpoint.ai.exception.AiProviderException;
import tools.jackson.core.JacksonException;
import tools.jackson.databind.ObjectMapper;

import java.io.IOException;
import java.util.List;

@Slf4j
@Component
public class OpenRouterAiClient implements AiClient {
    private static final MediaType JSON_MEDIA_TYPE =
            MediaType.get("application/json; charset=utf-8");

    private static final String CHAT_COMPLETIONS_PATH = "/chat/completions";

    private final OkHttpClient okHttpClient;
    private final ObjectMapper objectMapper;
    private final AiOpenRouterProperties properties;

    public OpenRouterAiClient(
            @Qualifier("openRouterOkHttpClient") OkHttpClient okHttpClient,
            ObjectMapper objectMapper,
            AiOpenRouterProperties properties
    ) {
        this.okHttpClient = okHttpClient;
        this.objectMapper = objectMapper;
        this.properties = properties;
    }

    @Override
    public String complete(AiCompletionRequest request) {
        OpenRouterChatRequest openRouterRequest = toOpenRouterRequest(request);

        String requestJson = writeJson(openRouterRequest);

        Request httpRequest = new Request.Builder()
                .url(buildChatCompletionsUrl())
                .post(RequestBody.create(requestJson, JSON_MEDIA_TYPE))
                .header("Authorization", "Bearer " + properties.apiKey())
                .header("Content-Type", "application/json")
                .header("HTTP-Referer", properties.siteUrl())
                .header("X-OpenRouter-Title", properties.siteTitle())
                .build();

        try (Response response = okHttpClient.newCall(httpRequest).execute()) {
            String responseBody = response.body() == null
                    ? ""
                    : response.body().string();

            if (!response.isSuccessful()) {
                log.warn(
                        "OpenRouter request failed, status={}, body={}",
                        response.code(),
                        responseBody
                );

                throw new AiProviderException("AI-сервис временно недоступен");
            }

            return extractContent(responseBody);
        } catch (IOException e) {
            log.error("OpenRouter request IO error", e);
            throw new AiProviderException("Не удалось выполнить запрос к AI-сервису");
        }
    }

    private String extractContent(String responseBody) {
        try {
            OpenRouterChatResponse response = objectMapper.readValue(
                    responseBody,
                    OpenRouterChatResponse.class
            );

            if (response.choices() == null || response.choices().isEmpty()) {
                throw new AiProviderException("AI-сервис вернул пустой ответ");
            }

            var message = response.choices().get(0).message();

            if (message == null || message.content() == null || message.content().isBlank()) {
                throw new AiProviderException("AI-сервис вернул пустой текст");
            }

            return message.content().trim();
        } catch (JacksonException e) {
            log.error("Cannot parse OpenRouter response, body={}", responseBody, e);
            throw new AiProviderException("Не удалось разобрать ответ AI-сервиса");
        }
    }

    private OpenRouterChatRequest toOpenRouterRequest(AiCompletionRequest request) {
        List<OpenRouterMessage> messages = request.messages()
                .stream()
                .map(message -> new OpenRouterMessage(
                        message.role(),
                        message.content()
                ))
                .toList();

        Integer maxTokens = request.maxTokens() != null
                ? request.maxTokens()
                : properties.maxTokens();

        Double temperature = request.temperature() != null
                ? request.temperature()
                : properties.temperature();

        return new OpenRouterChatRequest(
                properties.model(),
                messages,
                maxTokens,
                temperature
        );
    }

    private String writeJson(OpenRouterChatRequest request) {
        try {
            return objectMapper.writeValueAsString(request);
        } catch (JacksonException e) {
            throw new AiProviderException("Не удалось сформировать AI-запрос");
        }
    }

    private String buildChatCompletionsUrl() {
        String baseUrl = properties.baseUrl();

        if (baseUrl.endsWith("/")) {
            return baseUrl.substring(0, baseUrl.length() - 1) + CHAT_COMPLETIONS_PATH;
        }

        return baseUrl + CHAT_COMPLETIONS_PATH;
    }
}
