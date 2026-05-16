package ru.kpfu.itis.sorokin.sdevpoint.web.controller.page;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import ru.kpfu.itis.sorokin.sdevpoint.dto.*;
import ru.kpfu.itis.sorokin.sdevpoint.service.CaseService;
import ru.kpfu.itis.sorokin.sdevpoint.service.CustomUserDetails;
import ru.kpfu.itis.sorokin.sdevpoint.web.form.CaseCreateForm;
import ru.kpfu.itis.sorokin.sdevpoint.web.form.CaseEditForm;

@Controller
@RequiredArgsConstructor
public class CaseController {

    private final CaseService caseService;

    @GetMapping("/cases/public")
    public String getCasesPublic(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @AuthenticationPrincipal CustomUserDetails customUserDetails,
            Model model
    ) {
        Long currentUserId = customUserDetails == null ?
                null : customUserDetails.getUserId();

        CasePageView casePage = caseService.getPublishedCases(
                currentUserId,
                page,
                size
        );

        model.addAttribute("page", casePage);

        return "case/public_list";
    }

    @PostMapping("/cases/drafts")
    public String createDraft(
            @AuthenticationPrincipal CustomUserDetails customUserDetails
    ) {
        Long draftId = caseService.getOrCreateDraft(customUserDetails.getUserId());

        return "redirect:/cases/drafts/" + draftId + "/edit";
    }

    @GetMapping("/cases/drafts/{draftId}/edit")
    public String getDraftCaseEdit(
            @PathVariable Long draftId,
            @AuthenticationPrincipal CustomUserDetails customUserDetails,
            Model model
    ) {
        CaseCreateView caseCreateView = caseService.getCaseDraft(
                draftId,
                customUserDetails.getUserId()
        );

        CaseCreateForm caseCreateForm = new CaseCreateForm(
                caseCreateView.title(),
                caseCreateView.description(),
                caseCreateView.hasSolution(),
                caseCreateView.solution(),
                caseCreateView.visibility()
        );

        model.addAttribute("draftId", draftId);
        model.addAttribute("form", caseCreateForm);

        return "case/draft-create";
    }

    @PostMapping("/cases/drafts/{draftId}")
    public String editCaseDraft(
            @PathVariable Long draftId,
            @AuthenticationPrincipal CustomUserDetails customUserDetails,
            @Valid @ModelAttribute("form") CaseCreateForm caseCreateForm,
            BindingResult bindingResult,
            Model model
    ) {
        if (caseCreateForm.hasSolution()
                && (caseCreateForm.solution() == null || caseCreateForm.solution().isBlank())) {
            bindingResult.rejectValue(
                    "solution",
                    "solution.empty",
                    "Введите решение или выберите, что решения пока нет"
            );
        }

        if (bindingResult.hasErrors()) {
            model.addAttribute("draftId", draftId);

            return "case/draft-create";
        }

        CaseCreateDto caseCreateDto = new CaseCreateDto(
                draftId,
                caseCreateForm.title(),
                caseCreateForm.description(),
                caseCreateForm.hasSolution(),
                caseCreateForm.solution(),
                caseCreateForm.visibility()
        );

        caseService.updateDraft(caseCreateDto, customUserDetails.getUserId());

        return "redirect:/cases/drafts/" + draftId + "/edit";
    }

    @PostMapping("/cases/drafts/{draftId}/publish")
    public String publishCase(
            @PathVariable Long draftId,
            @AuthenticationPrincipal CustomUserDetails customUserDetails,
            @Valid @ModelAttribute("form") CaseCreateForm caseCreateForm,
            BindingResult bindingResult,
            Model model
    ) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("draftId", draftId);

            return "case/draft-create";
        }

        CaseCreateDto caseCreateDto = new CaseCreateDto(
                draftId,
                caseCreateForm.title(),
                caseCreateForm.description(),
                caseCreateForm.hasSolution(),
                caseCreateForm.solution(),
                caseCreateForm.visibility()
        );

        caseService.publishDraft(
                caseCreateDto,
                customUserDetails.getUserId()
        );

        return "redirect:/my-content";
    }

    @GetMapping("/cases/{contentId}")
    public String getCase(
            @PathVariable Long contentId,
            @AuthenticationPrincipal CustomUserDetails customUserDetails,
            Model model
    ) {
        Long currentUserId = customUserDetails == null
                ? null
                : customUserDetails.getUserId();

        CaseView caseView = caseService.getCaseView(
                contentId,
                currentUserId
        );

        model.addAttribute("case", caseView);

        return "case/view";
    }

    @GetMapping("/cases/{contentId}/edit")
    public String getCaseEdit(
            @PathVariable Long contentId,
            @AuthenticationPrincipal CustomUserDetails customUserDetails,
            Model model
    ) {
        CaseEditView caseEditView = caseService.getCaseToEdit(
                contentId,
                customUserDetails.getUserId()
        );

        CaseEditForm caseEditForm = new CaseEditForm(
                caseEditView.title(),
                caseEditView.description(),
                caseEditView.hasSolution(),
                caseEditView.solution(),
                caseEditView.visibility()
        );

        model.addAttribute("contentItemId", caseEditView.contentId());
        model.addAttribute("form", caseEditForm);

        return "case/edit";
    }

    @PostMapping("/cases/{contentId}")
    public String editCase(
            @PathVariable Long contentId,
            @AuthenticationPrincipal CustomUserDetails customUserDetails,
            @Valid @ModelAttribute("form") CaseEditForm caseEditForm,
            BindingResult bindingResult,
            Model model
    ) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("contentItemId", contentId);

            return "case/edit";
        }

        CaseEditDto caseEditDto = new CaseEditDto(
                contentId,
                caseEditForm.title(),
                caseEditForm.description(),
                caseEditForm.hasSolution(),
                caseEditForm.solution(),
                caseEditForm.visibility()
        );

        caseService.update(caseEditDto, customUserDetails.getUserId());

        return "redirect:/my-content";
    }
}