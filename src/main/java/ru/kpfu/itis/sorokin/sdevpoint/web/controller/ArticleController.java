package ru.kpfu.itis.sorokin.sdevpoint.web.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import ru.kpfu.itis.sorokin.sdevpoint.dto.ArticleCreateDto;
import ru.kpfu.itis.sorokin.sdevpoint.dto.ArticleEditDto;
import ru.kpfu.itis.sorokin.sdevpoint.dto.ArticleEditView;
import ru.kpfu.itis.sorokin.sdevpoint.entity.ArticleView;
import ru.kpfu.itis.sorokin.sdevpoint.entity.Visibility;
import ru.kpfu.itis.sorokin.sdevpoint.service.ArticleService;
import ru.kpfu.itis.sorokin.sdevpoint.service.CustomUserDetails;
import ru.kpfu.itis.sorokin.sdevpoint.web.form.ArticleCreateForm;
import ru.kpfu.itis.sorokin.sdevpoint.web.form.ArticleEditForm;

@Controller
@RequiredArgsConstructor
public class ArticleController {
    private final ArticleService articleService;

    @PostMapping("/articles/drafts")
    public String createDraft(@AuthenticationPrincipal CustomUserDetails customUserDetails) {
        Long draftId = articleService.createDraft(customUserDetails.getUserId());
        return "redirect::/articles/drafts/" + draftId + "/edit";
    }

    @GetMapping("/articles/drafts/{draftId}/edit")
    public String getDraftArticleEdit(
            @PathVariable Long draftId,
            @AuthenticationPrincipal CustomUserDetails customUserDetails,
            Model model) {
        articleService.checkDraftAccess(draftId, customUserDetails.getUserId());

        model.addAttribute("draftId", draftId);
        model.addAttribute("form", new ArticleCreateForm("", "", Visibility.PUBLIC));

        return "article/draft-create";
    }

    @PostMapping("/articles/drafts/{draftId}/publish")
    public String publishArticle(
            @PathVariable Long draftId,
            @AuthenticationPrincipal CustomUserDetails customUserDetails,
            @Valid @ModelAttribute("form") ArticleCreateForm articleCreateForm,
            BindingResult bindingResult,
            Model model
    ) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("draftId", draftId);
            return "article/draft-create";
        }

        ArticleCreateDto articleCreateDto = new ArticleCreateDto(
                customUserDetails.getUserId(),
                draftId,
                articleCreateForm.title(),
                articleCreateForm.text(),
                articleCreateForm.visibility()
        );

        articleService.publishDraft(articleCreateDto);

        return "index";
    }

    @GetMapping("/articles/{id}")
    public String getArticle(
            @PathVariable("id") Long id,
            @AuthenticationPrincipal CustomUserDetails customUserDetails,
            Model model
    ) {
        ArticleView articleView = articleService.getArticleView(
                id,
                customUserDetails.getUserId()
        );

        model.addAttribute("article", articleView);

        return "article/view";
    }

    @GetMapping("/articles/{id}/edit")
    public String getArticleEdit(
            @PathVariable("id") Long id,
            @AuthenticationPrincipal CustomUserDetails customUserDetails,
            Model model
    ) {
        ArticleEditView articleEditView = articleService.getArticleToEdit(
                id,
                customUserDetails.getUserId()
        );

        ArticleEditForm articleEditForm = new ArticleEditForm(
                articleEditView.title(),
                articleEditView.text(),
                articleEditView.visibility()
        );

        model.addAttribute("articleId", articleEditView.articleId());
        model.addAttribute("contentItemId", articleEditView.contentItemId());
        model.addAttribute("form", articleEditForm);

        return "article/edit";
    }

    @PostMapping("/articles/{id}")
    public String editArticle(
            @PathVariable("id") Long id,
            @AuthenticationPrincipal CustomUserDetails customUserDetails,
            @Valid @ModelAttribute("form") ArticleEditForm articleEditForm,
            BindingResult bindingResult,
            Model model
    ) {
        if (bindingResult.hasErrors()) {
            Long contentItemId = articleService.getArticleToEdit(
                    id,
                    customUserDetails.getUserId()
            ).contentItemId();

            model.addAttribute("contentItemId", contentItemId);
        }

        ArticleEditDto articleEditDto = new ArticleEditDto(
                id,
                articleEditForm.title(),
                articleEditForm.text(),
                articleEditForm.visibility()
        );

        articleService.update(articleEditDto, customUserDetails.getUserId());

        return "redirect:/articles/" + id;
    }
}
