package ru.kpfu.itis.sorokin.sdevpoint.web.controller.ajax;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;
import ru.kpfu.itis.sorokin.sdevpoint.dto.ContentRejectionCommentView;
import ru.kpfu.itis.sorokin.sdevpoint.service.ContentService;
import ru.kpfu.itis.sorokin.sdevpoint.service.CustomUserDetails;

@RestController
@RequiredArgsConstructor
public class ContentAjaxController {
    private final ContentService contentService;

    @PostMapping("api/content/{contentId}/withdraw")
    public ResponseEntity<Void> withdrawContent(
            @PathVariable Long contentId,
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        contentService.withdrawContent(contentId, userDetails.getUserId());

        return ResponseEntity.ok().build();
    }

    @GetMapping("/api/my-content/{contentId}/rejection-comment")
    public ResponseEntity<ContentRejectionCommentView> getRejectionComment(
            @PathVariable Long contentId,
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        ContentRejectionCommentView comment = contentService.getRejectionComment(
                contentId,
                userDetails.getUserId()
        );

        return ResponseEntity.ok(comment);
    }
}
