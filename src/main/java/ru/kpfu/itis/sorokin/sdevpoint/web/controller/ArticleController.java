package ru.kpfu.itis.sorokin.sdevpoint.web.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import ru.kpfu.itis.sorokin.sdevpoint.dto.*;
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
        return "redirect:/articles/drafts/" + draftId + "/edit";
    }

    @GetMapping("/articles/drafts/{draftId}/edit")
    public String getDraftArticleEdit(
            @PathVariable Long draftId,
            @AuthenticationPrincipal CustomUserDetails customUserDetails,
            Model model) {

        ArticleCreateView articleCreateView = articleService.getArticleDraft(draftId, customUserDetails.getUserId());

        ArticleCreateForm articleCreateForm = new ArticleCreateForm(
                articleCreateView.title(),
                articleCreateView.text(),
                articleCreateView.visibility()
        );

        model.addAttribute("draftId", draftId);
        model.addAttribute("form", articleCreateForm);

        return "article/draft-create";
    }

    @PostMapping("articles/drafts/{draftId}")
    public String editArticleDraft(
            @PathVariable("draftId") Long draftId,
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
                draftId,
                articleCreateForm.title(),
                articleCreateForm.text(),
                articleCreateForm.visibility()
        );


        articleService.updateDraft(articleCreateDto, customUserDetails.getUserId());

        return "redirect:/articles/drafts/" + draftId + "/edit";
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
                draftId,
                articleCreateForm.title(),
                articleCreateForm.text(),
                articleCreateForm.visibility()
        );

        Long articleId = articleService.publishDraft(articleCreateDto, customUserDetails.getUserId());

        return "redirect:/articles/" + articleId;
    }

    @GetMapping("/articles/{contentId}")
    public String getArticle(
            @PathVariable("contentId") Long contentId,
            @AuthenticationPrincipal CustomUserDetails customUserDetails,
            Model model
    ) {
        Long currentUserId = customUserDetails == null
                ? null
                : customUserDetails.getUserId();


        ArticleView articleView = articleService.getArticleView(
                contentId,
                currentUserId
        );

        model.addAttribute("article", articleView);

        return "article/view";
    }

    @GetMapping("/articles/{contentId}/edit")
    public String getArticleEdit(
            @PathVariable("contentId") Long contentId,
            @AuthenticationPrincipal CustomUserDetails customUserDetails,
            Model model
    ) {
        ArticleEditView articleEditView = articleService.getArticleToEdit(
                contentId,
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

    @PostMapping("/articles/{contentId}")
    public String editArticle(
            @PathVariable("contentId") Long contentId,
            @AuthenticationPrincipal CustomUserDetails customUserDetails,
            @Valid @ModelAttribute("form") ArticleEditForm articleEditForm,
            BindingResult bindingResult,
            Model model
    ) {
        if (bindingResult.hasErrors()) {
            Long contentItemId = articleService.getArticleToEdit(
                    contentId,
                    customUserDetails.getUserId()
            ).contentItemId();

            model.addAttribute("contentItemId", contentItemId);
        }

        ArticleEditDto articleEditDto = new ArticleEditDto(
                contentId,
                articleEditForm.title(),
                articleEditForm.text(),
                articleEditForm.visibility()
        );

        articleService.update(articleEditDto, customUserDetails.getUserId());

        return "redirect:/articles/" + contentId;
    }

    @DeleteMapping("/articles/{contentId}")
    public String deleteArticle(
            @PathVariable("contentId") Long id,
            @AuthenticationPrincipal CustomUserDetails customUserDetails
    ) {
        articleService.deleteArticle(id, customUserDetails.getUserId());

        return "redirect:/articles/public";
    }

    @GetMapping("/articles/public")
    public String getArticlesPublic(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            Model model
    ) {
        ArticlePageView articlePage = articleService.getPublishedArticles(page, size);

        model.addAttribute("page", articlePage);

        return "article/public_list";
    }

}
