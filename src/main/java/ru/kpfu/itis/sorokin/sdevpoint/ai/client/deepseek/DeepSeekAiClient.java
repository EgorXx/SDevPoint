package ru.kpfu.itis.sorokin.sdevpoint.ai.client.deepseek;

import lombok.extern.slf4j.Slf4j;
import okhttp3.*;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Component;
import ru.kpfu.itis.sorokin.sdevpoint.ai.client.AiClient;
import ru.kpfu.itis.sorokin.sdevpoint.ai.client.deepseek.dto.DeepSeekChatRequest;
import ru.kpfu.itis.sorokin.sdevpoint.ai.client.deepseek.dto.DeepSeekChatResponse;
import ru.kpfu.itis.sorokin.sdevpoint.ai.client.deepseek.dto.DeepSeekMessage;
import ru.kpfu.itis.sorokin.sdevpoint.ai.client.deepseek.properties.AiDeepSeekProperties;
import ru.kpfu.itis.sorokin.sdevpoint.ai.dto.AiCompletionRequest;
import ru.kpfu.itis.sorokin.sdevpoint.ai.exception.AiProviderException;
import tools.jackson.core.JacksonException;
import tools.jackson.databind.ObjectMapper;

import java.io.IOException;
import java.util.List;

@Slf4j
@Component
@ConditionalOnProperty(prefix = "app.ai", name = "provider", havingValue = "deepseek")
public class DeepSeekAiClient implements AiClient {
    private static final MediaType JSON_MEDIA_TYPE =
            MediaType.get("application/json; charset=utf-8");

    private static final String CHAT_COMPLETIONS_PATH = "/chat/completions";

    private final OkHttpClient okHttpClient;
    private final ObjectMapper objectMapper;
    private final AiDeepSeekProperties properties;

    public DeepSeekAiClient(
            @Qualifier("deepSeekOkHttpClient") OkHttpClient okHttpClient,
            ObjectMapper objectMapper,
            AiDeepSeekProperties properties
    ) {
        this.okHttpClient = okHttpClient;
        this.objectMapper = objectMapper;
        this.properties = properties;
    }

    @Override
    public String complete(AiCompletionRequest request) {
        DeepSeekChatRequest deepSeekRequest = toDeepSeekRequest(request);

        String requestJson = writeJson(deepSeekRequest);

        Request httpRequest = new Request.Builder()
                .url(buildChatCompletionsUrl())
                .post(RequestBody.create(requestJson, JSON_MEDIA_TYPE))
                .header("Authorization", "Bearer " + properties.apiKey())
                .header("Content-Type", "application/json")
                .build();

        try (Response response = okHttpClient.newCall(httpRequest).execute()) {
            String responseBody = response.body() == null
                    ? ""
                    : response.body().string();

            if (!response.isSuccessful()) {
                log.warn(
                        "DeepSeek request failed, status={}, body={}",
                        response.code(),
                        responseBody
                );

                throw new AiProviderException("AI-сервис временно недоступен");
            }

            return extractContent(responseBody);
        } catch (IOException e) {
            log.error("DeepSeek request IO error", e);
            throw new AiProviderException("Не удалось выполнить запрос к AI-сервису");
        }
    }

    private String extractContent(String responseBody) {
        try {
            DeepSeekChatResponse response = objectMapper.readValue(
                    responseBody,
                    DeepSeekChatResponse.class
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
            log.error("Cannot parse DeepSeek response, body={}", responseBody, e);
            throw new AiProviderException("Не удалось разобрать ответ AI-сервиса");
        }
    }

    private DeepSeekChatRequest toDeepSeekRequest(AiCompletionRequest request) {
        List<DeepSeekMessage> messages = request.messages()
                .stream()
                .map(message -> new DeepSeekMessage(
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

        return new DeepSeekChatRequest(
                properties.model(),
                messages,
                maxTokens,
                temperature
        );
    }

    private String writeJson(DeepSeekChatRequest request) {
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
