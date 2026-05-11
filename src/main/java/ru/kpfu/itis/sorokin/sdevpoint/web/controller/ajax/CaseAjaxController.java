package ru.kpfu.itis.sorokin.sdevpoint.web.controller.ajax;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import ru.kpfu.itis.sorokin.sdevpoint.service.CaseService;
import ru.kpfu.itis.sorokin.sdevpoint.service.CustomUserDetails;

@RestController
@RequiredArgsConstructor
public class CaseAjaxController {
    private final CaseService caseService;

    @DeleteMapping("/cases/{contentId}")
    public ResponseEntity<Void> deleteCase(
            @PathVariable Long contentId,
            @AuthenticationPrincipal CustomUserDetails customUserDetails
    ) {
        caseService.deleteCase(contentId, customUserDetails.getUserId());

        return ResponseEntity.noContent().build();
    }
}
