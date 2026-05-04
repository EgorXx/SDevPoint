package ru.kpfu.itis.sorokin.sdevpoint.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ru.kpfu.itis.sorokin.sdevpoint.api.generated.dto.ArticleCreateRequest;
import ru.kpfu.itis.sorokin.sdevpoint.api.generated.dto.ArticleResponse;
import ru.kpfu.itis.sorokin.sdevpoint.api.generated.dto.ArticleUpdateRequest;
import ru.kpfu.itis.sorokin.sdevpoint.dto.ArticleCreateDto;
import ru.kpfu.itis.sorokin.sdevpoint.dto.ArticleEditDto;
import ru.kpfu.itis.sorokin.sdevpoint.dto.ArticleEditView;
import ru.kpfu.itis.sorokin.sdevpoint.entity.*;
import ru.kpfu.itis.sorokin.sdevpoint.exception.ArticleAlreadyPublished;
import ru.kpfu.itis.sorokin.sdevpoint.exception.CurrentUserNotFoundException;
import ru.kpfu.itis.sorokin.sdevpoint.exception.ForbiddenException;
import ru.kpfu.itis.sorokin.sdevpoint.exception.NotFoundException;
import ru.kpfu.itis.sorokin.sdevpoint.markdown.MarkdownRenderService;
import ru.kpfu.itis.sorokin.sdevpoint.markdown.MarkdownTextParser;
import ru.kpfu.itis.sorokin.sdevpoint.repository.ArticleRepository;
import ru.kpfu.itis.sorokin.sdevpoint.repository.ContentItemRepository;
import ru.kpfu.itis.sorokin.sdevpoint.repository.UserRepository;

import java.time.Instant;
import java.time.OffsetDateTime;
import java.time.ZoneId;
import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Optional;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ArticleService {
    private final ArticleRepository articleRepository;
    private final UserRepository userRepository;
    private final ContentItemRepository contentItemRepository;
    private final MarkdownTextParser markdownTextParser;
    private final MarkdownRenderService markdownRenderService;

    private static final int PREVIEW_SIZE = 100;

    private static final DateTimeFormatter ARTICLE_DATE_FORMATTER =
            DateTimeFormatter.ofPattern("dd.MM.yyyy HH:mm")
                    .withZone(ZoneId.of("Europe/Moscow"));

    @Transactional
    public Long createDraft(Long userId) {
        User owner = userRepository.findById(userId)
                .orElseThrow(CurrentUserNotFoundException::new);

        Optional<Long> optionalContentItemId =
                contentItemRepository.findDraftArticleByUserId(userId)
                        .map(ContentItem::getId);

        if (optionalContentItemId.isPresent()) {
            return optionalContentItemId.get();
        }

        ContentItem contentItem = ContentItem.createDraft(owner, ItemType.ARTICLE);
        contentItemRepository.save(contentItem);

        return contentItem.getId();
    }

    public void checkDraftAccess(Long draftId, Long userId) {
        ContentItem contentItem = contentItemRepository.findById(draftId)
                .orElseThrow(() -> {
                    log.debug("ContentItem not found id={}", draftId);
                    throw new NotFoundException("Статья не найдена");
                });

        checkAccess(contentItem, userId);

        //Проверка, что статья уже есть, тогда ошибка и редирект на ее редактирование
        if (articleRepository.findByContentItem(contentItem).isPresent()) {
            log.debug("Access is denied, article has already been published contentItemId={}", draftId);
            throw new ArticleAlreadyPublished("Статья уже опубликована");
        }
    }

    @Transactional
    public void publishDraft(ArticleCreateDto articleCreateDto) {
        checkDraftAccess(articleCreateDto.draftId(), articleCreateDto.userId());

        ContentItem contentItem = contentItemRepository.findById(articleCreateDto.draftId()).get();

        contentItem.setTitle(articleCreateDto.title());
        contentItem.setVisibility(articleCreateDto.visibility());
        contentItem.setPreview(extractPreview(articleCreateDto.text()));
        contentItem.setContentStatus(ContentStatus.PUBLISHED);

        Article article = new Article(
                null,
                contentItem,
                articleCreateDto.text()
        );

        articleRepository.save(article);

    }

    @Transactional(readOnly = true)
    public ArticleView getArticleView(Long articleId, Long userId) {
        Article article = articleRepository.findById(articleId)
                .orElseThrow(() -> new NotFoundException("Статья не найдена"));

        ContentItem contentItem = article.getContentItem();

        if (contentItem.getVisibility() == Visibility.PRIVATE) {
            checkAccess(contentItem, userId);
        }

        return new ArticleView(
                article.getId(),
                contentItem.getTitle(),
                contentItem.getOwner().getUsername(),
                markdownRenderService.renderToSafeHtml(article.getText()),
                ARTICLE_DATE_FORMATTER.format(contentItem.getCreatedAt()),
                ARTICLE_DATE_FORMATTER.format(contentItem.getUpdatedAt())
        );
    }

    @Transactional(readOnly = true)
    public ArticleEditView getArticleToEdit(Long articleId, Long userId) {
        Article article = articleRepository.findById(articleId)
                .orElseThrow(() -> new NotFoundException("Статья не найдена"));

        ContentItem contentItem = article.getContentItem();

        checkAccess(contentItem, userId);

        return new ArticleEditView(
                article.getId(),
                contentItem.getId(),
                contentItem.getTitle(),
                article.getText(),
                contentItem.getVisibility()
        );
    }

    @Transactional
    public void update(ArticleEditDto articleEditDto, Long userId) {
        Article article = articleRepository.findById(articleEditDto.articleId())
                .orElseThrow(() -> new NotFoundException("Статья не найдена"));

        ContentItem contentItem = article.getContentItem();

        checkAccess(contentItem, userId);

        contentItem.setTitle(articleEditDto.title());
        contentItem.setVisibility(articleEditDto.visibility());
        contentItem.setPreview(extractPreview(articleEditDto.text()));

        article.setText(articleEditDto.text());
    }

    private void checkAccess(ContentItem contentItem, Long userId) {
        if (!contentItem.getOwner().getId().equals(userId)) {
            log.debug("Access is denied ownerId={}, userId={}", contentItem.getOwner().getId(), userId);
            throw new ForbiddenException("Доступ к статье запрещен");
        }
    }

    private String extractPreview(String text) {
        return markdownTextParser.parse(text, PREVIEW_SIZE);
    }



    //------------ МЕТОДЫ ДЛЯ РАБОТЫ С REST API ------------

    @Transactional(readOnly = true)
    public List<ArticleResponse> getArticles() {
        return articleRepository.findAllPublicPublished()
                .stream()
                .map(this::toResponse)
                .toList();
    }

    @Transactional(readOnly = true)
    public ArticleResponse getArticleById(Long contentItemId) {
        ContentItem contentItem = contentItemRepository.findById(contentItemId)
                .orElseThrow(() -> new NotFoundException("Статья не найдена"));

        Article article = articleRepository.findByContentItem(contentItem)
                .orElseThrow(() -> new NotFoundException("Статья не найдена"));

        return toResponse(article);
    }


    @Transactional
    public ArticleResponse createArticle(Long userId, ArticleCreateRequest request) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new NotFoundException("Пользователь не найден"));

        ContentItem contentItem = new ContentItem();
        contentItem.setOwner(user);
        contentItem.setTitle(request.getTitle());
        contentItem.setItemType(ItemType.ARTICLE);
        contentItem.setContentStatus(ContentStatus.PUBLISHED);
        contentItem.setVisibility(toDomainVisibility(request.getVisibility()));
        contentItem.setPreview(extractPreview(request.getText()));
        contentItem.setCreatedAt(Instant.now());
        contentItem.setUpdatedAt(Instant.now());

        ContentItem savedContentItem = contentItemRepository.save(contentItem);

        Article article = new Article();
        article.setContentItem(savedContentItem);
        article.setText(request.getText());

        Article savedArticle = articleRepository.save(article);

        return toResponse(savedArticle);
    }

    @Transactional
    public ArticleResponse updateArticle(Long userId, Long contentItemId, ArticleUpdateRequest request) {
        ContentItem contentItem = contentItemRepository.findById(contentItemId)
                .orElseThrow(() -> new NotFoundException("Статья не найдена"));

        Article article = articleRepository.findByContentItem(contentItem)
                .orElseThrow(() -> new NotFoundException("Статья не найдена"));


        if (!contentItem.getOwner().getId().equals(userId)) {
            log.debug("Access is denied ownerId={}, userId={}", contentItem.getOwner().getId(), userId);
            throw new ForbiddenException("Доступ к статье запрещен");
        }

        contentItem.setTitle(request.getTitle());
        contentItem.setVisibility(toDomainVisibility(request.getVisibility()));
        contentItem.setPreview(extractPreview(request.getText()));

        article.setText(request.getText());

        return toResponse(article);
    }

    @Transactional
    public void deleteArticle(Long userId, Long contentItemId) {
        ContentItem contentItem = contentItemRepository.findById(contentItemId)
                .orElseThrow(() -> new NotFoundException("Статья не найдена"));

        if (contentItem.getItemType() != ItemType.ARTICLE) {
            throw new NotFoundException("Статья не найдена");
        }

        if (!contentItem.getOwner().getId().equals(userId)) {
            log.debug("Access is denied ownerId={}, userId={}", contentItem.getOwner().getId(), userId);
            throw new ForbiddenException("Доступ к статье запрещен");
        }

        contentItemRepository.delete(contentItem);
    }

    private Visibility toDomainVisibility(
            ru.kpfu.itis.sorokin.sdevpoint.api.generated.dto.Visibility visibility) {
        return Visibility.valueOf(visibility.name());
    }

    private ru.kpfu.itis.sorokin.sdevpoint.api.generated.dto.Visibility toApiVisibility(Visibility visibility) {
        return ru.kpfu.itis.sorokin.sdevpoint.api.generated.dto.Visibility.valueOf(visibility.name());
    }

    private ru.kpfu.itis.sorokin.sdevpoint.api.generated.dto.ContentStatus toApiContentStatus(ContentStatus status) {
        return ru.kpfu.itis.sorokin.sdevpoint.api.generated.dto.ContentStatus.valueOf(status.name());
    }

    private OffsetDateTime toOffsetDateTime(Instant instant) {
        if (instant == null) {
            return null;
        }

        return instant.atOffset(ZoneOffset.UTC);
    }

    private ArticleResponse toResponse(Article article) {
        ContentItem contentItem = article.getContentItem();

        ArticleResponse response = new ArticleResponse();
        response.setId(contentItem.getId());
        response.setTitle(contentItem.getTitle());
        response.setText(article.getText());
        response.setVisibility(toApiVisibility(contentItem.getVisibility()));
        response.setStatus(toApiContentStatus(contentItem.getContentStatus()));
        response.setPreview(contentItem.getPreview());
        response.setCreatedAt(toOffsetDateTime(contentItem.getCreatedAt()));
        response.setUpdatedAt(toOffsetDateTime(contentItem.getUpdatedAt()));

        return response;
    }
}
