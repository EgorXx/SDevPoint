package ru.kpfu.itis.sorokin.sdevpoint.web.controller.ajax;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import ru.kpfu.itis.sorokin.sdevpoint.dto.ContentRejectionCommentView;
import ru.kpfu.itis.sorokin.sdevpoint.service.ContentService;
import ru.kpfu.itis.sorokin.sdevpoint.service.CustomUserDetails;
import ru.kpfu.itis.sorokin.sdevpoint.web.form.RejectContentForm;

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

    @PostMapping("api/admin/content/{contentId}/reject")
    public ResponseEntity<Void> rejectContent(
            @PathVariable Long contentId,
            @Valid @RequestBody RejectContentForm form,
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        contentService.rejectContent(
                contentId,
                userDetails.getUserId(),
                form.comment()
        );

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
