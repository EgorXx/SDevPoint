package ru.kpfu.itis.sorokin.sdevpoint.api.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RestController;
import ru.kpfu.itis.sorokin.sdevpoint.api.generated.api.ArticlesApi;
import ru.kpfu.itis.sorokin.sdevpoint.api.generated.dto.ArticleCreateRequest;
import ru.kpfu.itis.sorokin.sdevpoint.api.generated.dto.ArticleResponse;
import ru.kpfu.itis.sorokin.sdevpoint.api.generated.dto.ArticleUpdateRequest;
import ru.kpfu.itis.sorokin.sdevpoint.service.ArticleService;
import ru.kpfu.itis.sorokin.sdevpoint.service.CurrentUserProvider;

import java.util.List;

@RestController
@RequiredArgsConstructor
public class ApiArticleController implements ArticlesApi {
    private final CurrentUserProvider currentUserProvider;
    private final ArticleService articleService;

    @Override
    public ResponseEntity<ArticleResponse> createArticle(ArticleCreateRequest articleCreateRequest) {
        Long userId = currentUserProvider.getCurrentUserId();
        return ResponseEntity.status(HttpStatus.CREATED).body(articleService.createArticle(userId, articleCreateRequest));
    }

    @Override
    public ResponseEntity<Void> deleteArticle(Long id) {
        Long userId = currentUserProvider.getCurrentUserId();
        articleService.deleteArticle(userId, id);
        return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
    }

    @Override
    public ResponseEntity<ArticleResponse> getArticleById(Long id) {
        return ResponseEntity.ok(articleService.getArticleById(id));
    }

    @Override
    public ResponseEntity<List<ArticleResponse>> getArticles() {
        return ResponseEntity.ok(articleService.getArticles());
    }

    @Override
    public ResponseEntity<ArticleResponse> updateArticle(Long id, ArticleUpdateRequest articleUpdateRequest) {
        Long userId = currentUserProvider.getCurrentUserId();
        return ResponseEntity.ok(articleService.updateArticle(userId, id, articleUpdateRequest));
    }
}
