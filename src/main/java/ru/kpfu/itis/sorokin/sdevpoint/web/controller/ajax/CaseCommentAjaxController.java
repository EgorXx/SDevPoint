package ru.kpfu.itis.sorokin.sdevpoint.web.controller.ajax;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import ru.kpfu.itis.sorokin.sdevpoint.service.CaseCommentService;
import ru.kpfu.itis.sorokin.sdevpoint.service.CustomUserDetails;

@RestController
@RequiredArgsConstructor
public class CaseCommentAjaxController {
    private final CaseCommentService caseCommentService;

    @DeleteMapping("api/cases/{contentId}/comments/{commentId}")
    public ResponseEntity<Void> deleteComment(
            @PathVariable("contentId") Long contentId,
            @PathVariable("commentId") Long commentId,
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        caseCommentService.deleteComment(contentId, commentId, userDetails.getUserId());

        return ResponseEntity.noContent().build();
    }
}
