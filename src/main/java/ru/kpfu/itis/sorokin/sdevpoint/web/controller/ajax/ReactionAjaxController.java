package ru.kpfu.itis.sorokin.sdevpoint.web.controller.ajax;

import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import ru.kpfu.itis.sorokin.sdevpoint.dto.ReactionResponse;
import ru.kpfu.itis.sorokin.sdevpoint.entity.ReactionType;
import ru.kpfu.itis.sorokin.sdevpoint.service.CustomUserDetails;
import ru.kpfu.itis.sorokin.sdevpoint.service.ReactionService;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/content-items/{contentItemId}/reactions")
public class ReactionAjaxController {

    private final ReactionService reactionService;

    @PostMapping("/like")
    public ReactionResponse like(
            @PathVariable Long contentItemId,
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        return reactionService.react(
                contentItemId,
                userDetails.getUserId(),
                ReactionType.LIKE
        );
    }

    @PostMapping("/dislike")
    public ReactionResponse dislike(
            @PathVariable Long contentItemId,
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        return reactionService.react(
                contentItemId,
                userDetails.getUserId(),
                ReactionType.DISLIKE
        );
    }
}
