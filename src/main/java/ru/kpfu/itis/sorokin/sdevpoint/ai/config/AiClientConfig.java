package ru.kpfu.itis.sorokin.sdevpoint.ai.config;

import lombok.RequiredArgsConstructor;
import okhttp3.OkHttpClient;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import ru.kpfu.itis.sorokin.sdevpoint.ai.client.deepseek.properties.AiDeepSeekProperties;
import ru.kpfu.itis.sorokin.sdevpoint.ai.client.openrouter.properties.AiOpenRouterProperties;

@Configuration
@RequiredArgsConstructor
public class AiClientConfig {

    private final AiOpenRouterProperties openRouterProperties;
    private final AiDeepSeekProperties deepSeekProperties;

    @Bean(name = "openRouterOkHttpClient")
    public OkHttpClient openRouterOkHttpClient() {
        return new OkHttpClient.Builder()
                .connectTimeout(openRouterProperties.connectTimeout())
                .readTimeout(openRouterProperties.readTimeout())
                .build();
    }

    @Bean(name = "deepSeekOkHttpClient")
    public OkHttpClient deepSeekOkHttpClient() {
        return new OkHttpClient.Builder()
                .connectTimeout(deepSeekProperties.connectTimeout())
                .readTimeout(deepSeekProperties.readTimeout())
                .build();
    }
}
