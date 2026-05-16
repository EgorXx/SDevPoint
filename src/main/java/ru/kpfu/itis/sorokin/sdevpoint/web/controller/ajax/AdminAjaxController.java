package ru.kpfu.itis.sorokin.sdevpoint.web.controller.ajax;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import ru.kpfu.itis.sorokin.sdevpoint.service.ContentService;
import ru.kpfu.itis.sorokin.sdevpoint.service.CustomUserDetails;
import ru.kpfu.itis.sorokin.sdevpoint.web.form.RejectContentForm;

@RestController
@RequiredArgsConstructor
public class AdminAjaxController {
    private final ContentService contentService;

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

    @PostMapping("api/admin/content/{contentId}/approve")
    public ResponseEntity<Void> approveContent(
            @PathVariable Long contentId,
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        contentService.approveContent(
                contentId,
                userDetails.getUserId()
        );

        return ResponseEntity.noContent().build();
    }
}
