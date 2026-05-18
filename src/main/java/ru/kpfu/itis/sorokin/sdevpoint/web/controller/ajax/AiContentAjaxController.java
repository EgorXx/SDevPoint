package ru.kpfu.itis.sorokin.sdevpoint.web.controller.ajax;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import ru.kpfu.itis.sorokin.sdevpoint.ai.dto.AiExplainTermResponse;
import ru.kpfu.itis.sorokin.sdevpoint.ai.dto.AiSummaryResponse;
import ru.kpfu.itis.sorokin.sdevpoint.ai.service.AiContentService;
import ru.kpfu.itis.sorokin.sdevpoint.service.CustomUserDetails;
import ru.kpfu.itis.sorokin.sdevpoint.web.dto.ExplainTermRequest;

@RestController
@RequiredArgsConstructor
public class AiContentAjaxController {

    private final AiContentService aiContentService;

    @PostMapping("/api/content/{contentId}/ai/summary")
    public AiSummaryResponse summarize(
            @PathVariable Long contentId,
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        return aiContentService.getSummary(
                contentId,
                userDetails.getUserId()
        );
    }

    @PostMapping("/api/content/{contentId}/ai/explain")
    public AiExplainTermResponse explainTerm(
            @PathVariable Long contentId,
            @Valid @RequestBody ExplainTermRequest request,
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        return aiContentService.explainTerm(
                contentId,
                userDetails.getUserId(),
                request.term()
        );
    }
}
