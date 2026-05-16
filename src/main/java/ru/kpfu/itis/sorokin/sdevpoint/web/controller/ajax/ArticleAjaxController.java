package ru.kpfu.itis.sorokin.sdevpoint.web.controller.ajax;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;
import ru.kpfu.itis.sorokin.sdevpoint.service.ArticleService;
import ru.kpfu.itis.sorokin.sdevpoint.service.CustomUserDetails;

@RestController
@RequiredArgsConstructor
public class ArticleAjaxController {
    private final ArticleService articleService;

    @DeleteMapping("/articles/{contentId}")
    public ResponseEntity<Void> deleteArticle(
            @PathVariable("contentId") Long contentId,
            @AuthenticationPrincipal CustomUserDetails customUserDetails
    ) {
        articleService.deleteArticle(
                contentId,
                customUserDetails.getUserId()
        );

        return ResponseEntity.noContent().build();
    }
}
