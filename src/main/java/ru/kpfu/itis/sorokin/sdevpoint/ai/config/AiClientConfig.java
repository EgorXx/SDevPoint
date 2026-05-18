package ru.kpfu.itis.sorokin.sdevpoint.ai.config;

import lombok.RequiredArgsConstructor;
import okhttp3.OkHttpClient;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import ru.kpfu.itis.sorokin.sdevpoint.ai.client.openrouter.properties.AiOpenRouterProperties;

@Configuration
@RequiredArgsConstructor
public class AiClientConfig {

    private final AiOpenRouterProperties openRouterProperties;

    @Bean(name = "openRouterOkHttpClient")
    public OkHttpClient openRouterOkHttpClient() {
        return new OkHttpClient.Builder()
                .connectTimeout(openRouterProperties.connectTimeout())
                .readTimeout(openRouterProperties.readTimeout())
                .build();
    }
}
