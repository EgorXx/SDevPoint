package ru.kpfu.itis.sorokin.sdevpoint.web.controller.page;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import ru.kpfu.itis.sorokin.sdevpoint.dto.CaseDiscussionPageView;
import ru.kpfu.itis.sorokin.sdevpoint.exception.BadRequestException;
import ru.kpfu.itis.sorokin.sdevpoint.service.CaseCommentService;
import ru.kpfu.itis.sorokin.sdevpoint.service.CustomUserDetails;
import ru.kpfu.itis.sorokin.sdevpoint.web.form.CaseCommentCreateForm;

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

    @PostMapping("/cases/{contentId}/comments")
    public String addComment(
            @PathVariable("contentId") Long contentId,
            @Valid @ModelAttribute("form") CaseCommentCreateForm form,
            BindingResult bindingResult,
            @AuthenticationPrincipal CustomUserDetails customUserDetails,
            RedirectAttributes redirectAttributes
    ) {
        if (bindingResult.hasErrors()) {
            String errorMessage = bindingResult.getFieldError("text") != null
                    ? bindingResult.getFieldError("text").getDefaultMessage()
                    : "Комментарий заполнен некорректно";

            redirectAttributes.addFlashAttribute("commentError", errorMessage);
            redirectAttributes.addFlashAttribute("commentText", form.text());

            return "redirect:/cases/" + contentId + "/comments";
        }

        try {
            caseCommentService.createComment(
                    form.text(),
                    contentId,
                    customUserDetails.getUserId());
        } catch (BadRequestException e) {
            redirectAttributes.addFlashAttribute("commentError", e.getMessage());
            redirectAttributes.addFlashAttribute("commentText", form.text());
        }

        return "redirect:/cases/" + contentId + "/comments";
    }
}
