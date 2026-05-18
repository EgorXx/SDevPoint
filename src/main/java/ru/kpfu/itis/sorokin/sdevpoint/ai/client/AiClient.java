package ru.kpfu.itis.sorokin.sdevpoint.ai.client;

import ru.kpfu.itis.sorokin.sdevpoint.ai.dto.AiCompletionRequest;

public interface AiClient {

    String complete(AiCompletionRequest request);
}
