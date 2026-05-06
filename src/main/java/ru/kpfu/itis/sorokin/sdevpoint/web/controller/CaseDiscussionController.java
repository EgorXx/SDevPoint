package ru.kpfu.itis.sorokin.sdevpoint.web.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import ru.kpfu.itis.sorokin.sdevpoint.dto.CaseDiscussionPageView;
import ru.kpfu.itis.sorokin.sdevpoint.entity.CaseComment;
import ru.kpfu.itis.sorokin.sdevpoint.service.CaseCommentService;
import ru.kpfu.itis.sorokin.sdevpoint.service.CustomUserDetails;

@Controller
@RequiredArgsConstructor
public class CaseDiscussionController {
    private final CaseCommentService caseCommentService;

    @GetMapping("/cases/{contentId}/comments")
    public String getDiscussion(
            @PathVariable("contentId") Long contentId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @AuthenticationPrincipal CustomUserDetails customUserDetails,
            Model model
    ) {
        Long currentUserId = customUserDetails == null ? null : customUserDetails.getUserId();

        CaseDiscussionPageView caseDiscussionPageView = caseCommentService.getDiscussionPage(
                currentUserId,
                contentId,
                page,
                size
        );

        model.addAttribute("discussionPage", caseDiscussionPageView);

        return "case/discussion/view";
    }
}
