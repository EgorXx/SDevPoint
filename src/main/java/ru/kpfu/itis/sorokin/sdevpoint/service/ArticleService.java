package ru.kpfu.itis.sorokin.sdevpoint.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ru.kpfu.itis.sorokin.sdevpoint.dto.*;
import ru.kpfu.itis.sorokin.sdevpoint.entity.*;
import ru.kpfu.itis.sorokin.sdevpoint.exception.CurrentUserNotFoundException;
import ru.kpfu.itis.sorokin.sdevpoint.exception.NotFoundException;
import ru.kpfu.itis.sorokin.sdevpoint.markdown.MarkdownRenderService;
import ru.kpfu.itis.sorokin.sdevpoint.repository.*;
import ru.kpfu.itis.sorokin.sdevpoint.service.clean.ContentImageCleanupService;

import java.time.Instant;
import java.util.List;
import java.util.Optional;
import java.util.Set;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ArticleService {
    private final ArticleRepository articleRepository;
    private final UserRepository userRepository;
    private final ContentItemRepository contentItemRepository;
    private final ContentViewService contentViewService;
    private final FavoriteRepository favoriteRepository;
    private final ContentViewRepository contentViewRepository;
    private final MarkdownRenderService markdownRenderService;
    private final ContentImageCleanupService contentImageCleanupService;
    private final StorageDeletionTaskRepository storageDeletionTaskRepository;
    private final ReactionService reactionService;

    private static final String ARTICLE_NOT_FOUND_MESSAGE = "Статья не найдена";

    @Transactional
    public Long getOrCreateDraft(Long userId) {
        User owner = userRepository.findById(userId)
                .orElseThrow(CurrentUserNotFoundException::new);

        Optional<Long> optionalContentItemId =
                contentItemRepository.findDraftByUserIdAndItemType(userId, ItemType.ARTICLE)
                        .map(ContentItem::getId);

        if (optionalContentItemId.isPresent()) {
            return optionalContentItemId.get();
        }

        ContentItem contentItem = ContentItem.createDraft(owner, ItemType.ARTICLE);
        contentItemRepository.save(contentItem);

        return contentItem.getId();
    }

    @Transactional(readOnly = true)
    public ArticleCreateView getArticleDraft(Long draftId, Long userId) {
        ContentItem contentItem = getEditableDraft(draftId, userId);

        String text = articleRepository.findByContentItem(contentItem)
                .map(Article::getText)
                .orElse("");

        String title = ContentItem.isGenerateTitle(contentItem.getTitle()) ? "" : contentItem.getTitle();

        return new ArticleCreateView(
                draftId,
                title,
                text,
                contentItem.getVisibility()
        );
    }

    @Transactional
    public void publishDraft(ArticleCreateDto articleCreateDto, Long userId) {
        ContentItem contentItem = getEditableDraft(articleCreateDto.draftId(), userId);

        applyDraftData(contentItem, articleCreateDto);

        contentItem.setContentStatus(ContentStatus.PENDING_REVIEW);

        contentImageCleanupService.cleanupUnusedImages(
                contentItem.getId(),
                List.of(articleCreateDto.text())
        );
    }

    @Transactional
    public ArticleView getArticleView(Long contentItemId, Long userId) {
        Article article = articleRepository.findByContentItemId(contentItemId)
                .orElseThrow(() -> new NotFoundException(ARTICLE_NOT_FOUND_MESSAGE));

        ContentItem contentItem = article.getContentItem();

        checkArticleViewAccess(contentItem, userId);

        if (userId != null) {
            contentViewRepository.insertIfNotExists(contentItemId, userId);
        }

        long countViews = contentViewRepository.countViewsContent(contentItemId);

        ReactionResponse reactionResponse = reactionService.getReactionInfo(
                contentItemId,
                userId
        );

        boolean reactionAllowed = contentItem.getContentStatus() == ContentStatus.PUBLISHED;

        return new ArticleView(
                contentItem.getId(),
                contentItem.getTitle(),
                contentItem.getOwner().getUsername(),
                markdownRenderService.renderToSafeHtml(article.getText()),
                contentViewService.formatDate(contentItem.getCreatedAt()),
                contentViewService.formatDate(contentItem.getUpdatedAt()),
                countViews,
                reactionResponse,
                reactionAllowed
        );
    }

    @Transactional(readOnly = true)
    public ArticleEditView getArticleToEdit(Long contentItemId, Long userId) {
        Article article = articleRepository.findByContentItemId(contentItemId)
                .orElseThrow(() -> new NotFoundException(ARTICLE_NOT_FOUND_MESSAGE));

        ContentItem contentItem = article.getContentItem();

        checkArticleEditAccess(contentItem, userId);

        return new ArticleEditView(
                contentItem.getId(),
                contentItem.getTitle(),
                article.getText(),
                contentItem.getVisibility()
        );
    }

    @Transactional
    public void update(ArticleEditDto articleEditDto, Long userId) {
        Article article = articleRepository.findByContentItemId(articleEditDto.contentItemId())
                .orElseThrow(() -> new NotFoundException(ARTICLE_NOT_FOUND_MESSAGE));

        ContentItem contentItem = article.getContentItem();

        checkArticleEditAccess(contentItem, userId);

        contentItem.setTitle(articleEditDto.title());
        contentItem.setVisibility(articleEditDto.visibility());
        contentItem.setPreview(contentViewService.formatPreviewFromText(articleEditDto.text()));
        contentItem.setUpdatedAt(Instant.now());
        contentItem.setContentStatus(ContentStatus.PENDING_REVIEW);

        article.setText(articleEditDto.text());

        contentImageCleanupService.cleanupUnusedImages(
                contentItem.getId(),
                List.of(articleEditDto.text())
        );
    }

    @Transactional
    public void updateDraft(ArticleCreateDto articleCreateDto, Long userId) {
        ContentItem contentItem = getEditableDraft(articleCreateDto.draftId(), userId);

        applyDraftData(contentItem, articleCreateDto);
    }

    @Transactional
    public void deleteArticle(Long contentItemId, Long userId) {
        ContentItem contentItem = contentItemRepository.findByIdAndOwnerIdAndItemType(
                contentItemId,
                userId,
                ItemType.ARTICLE
        ).orElseThrow(() -> new NotFoundException(ARTICLE_NOT_FOUND_MESSAGE));

        storageDeletionTaskRepository.save(
                StorageDeletionTask.createContentDirectoryDeletion(contentItem.getId())
        );

        contentItemRepository.delete(contentItem);
    }

    @Transactional(readOnly = true)
    public ArticlePageView getPublishedArticles(Long userId, int page, int size) {
        int safePage = Math.max(page, 0);
        int safeSize = Math.clamp(size, 1, 50);

        Pageable pageable = PageRequest.of(
                safePage,
                safeSize,
                Sort.by(Sort.Direction.DESC, "createdAt")
        );

        Page<ContentItem> contentItems = contentItemRepository.findContentItemsByContentStatusAndItemTypeAndVisibility(
                ContentStatus.PUBLISHED,
                ItemType.ARTICLE,
                Visibility.PUBLIC,
                pageable
        );

        List<Long> contentIds = contentItems.map(ContentItem::getId).toList();

        Set<Long> favoriteContentIds = userId == null || contentIds.isEmpty() ?
                Set.of() : favoriteRepository.findFavoriteContentIds(userId, contentIds);

        List<ArticleCardView> articleCardViews = contentItems.map(
                contentItem -> new ArticleCardView(
                        contentItem.getId(),
                        contentItem.getOwner().getUsername(),
                        contentItem.getTitle(),
                        contentItem.getPreview(),
                        contentViewService.formatDate(contentItem.getCreatedAt()),
                        favoriteContentIds.contains(contentItem.getId())
                ))
                .toList();

        return new ArticlePageView(
                articleCardViews,
                contentItems.getNumber(),
                contentItems.getSize(),
                contentItems.getTotalElements(),
                contentItems.getTotalPages(),
                contentItems.hasPrevious(),
                contentItems.hasNext()
        );
    }

    private void checkArticleViewAccess(ContentItem contentItem, Long userId) {
        ContentStatus status = contentItem.getContentStatus();

        switch (status) {
            case DRAFT -> throw new NotFoundException(ARTICLE_NOT_FOUND_MESSAGE);

            case PENDING_REVIEW, REJECTED -> {
                if (!isOwner(contentItem, userId)) {
                    throw new NotFoundException(ARTICLE_NOT_FOUND_MESSAGE);
                }
            }

            case PUBLISHED -> {
                if (contentItem.getVisibility() == Visibility.PRIVATE
                        && !isOwner(contentItem, userId)) {
                    throw new NotFoundException(ARTICLE_NOT_FOUND_MESSAGE);
                }
            }

            default -> throw new NotFoundException(ARTICLE_NOT_FOUND_MESSAGE);
        }
    }

    private void checkArticleEditAccess(ContentItem contentItem, Long userId) {
        if (!isOwner(contentItem, userId)) {
            throw new NotFoundException(ARTICLE_NOT_FOUND_MESSAGE);
        }

        switch (contentItem.getContentStatus()) {
            case DRAFT -> throw new NotFoundException(ARTICLE_NOT_FOUND_MESSAGE);

            case PENDING_REVIEW -> throw new NotFoundException(ARTICLE_NOT_FOUND_MESSAGE);

            case PUBLISHED, REJECTED -> {
                // редактирование разрешено владельцу
            }

            default -> throw new NotFoundException(ARTICLE_NOT_FOUND_MESSAGE);
        }
    }

    public boolean isOwner(ContentItem contentItem, Long userId) {
        return contentItem.getOwner().getId().equals(userId);
    }

    private ContentItem getEditableDraft(Long draftId, Long userId) {
        return contentItemRepository.findDraftByIdAndOwnerId(draftId, userId, ItemType.ARTICLE)
                .orElseThrow(() -> new NotFoundException("Контент не найден"));
    }

    private void applyDraftData(ContentItem contentItem, ArticleCreateDto dto) {
        contentItem.setTitle(dto.title());
        contentItem.setPreview(contentViewService.formatPreviewFromText(dto.text()));
        contentItem.setVisibility(dto.visibility());

        Article article = articleRepository.findByContentItem(contentItem)
                .orElseGet(() -> new Article(
                        null,
                        contentItem,
                        dto.text()
                ));

        article.setText(dto.text());

        articleRepository.save(article);
    }


    //------------ МЕТОДЫ ДЛЯ РАБОТЫ С REST API ------------

//    @Transactional(readOnly = true)
//    public List<ArticleResponse> getArticles() {
//        return articleRepository.findAllPublicPublished()
//                .stream()
//                .map(this::toResponse)
//                .toList();
//    }
//
//    @Transactional(readOnly = true)
//    public ArticleResponse getArticleById(Long contentItemId) {
//        ContentItem contentItem = contentItemRepository.findById(contentItemId)
//                .orElseThrow(() -> new NotFoundException(ARTICLE_NOT_FOUND_MESSAGE));
//
//        Article article = articleRepository.findByContentItem(contentItem)
//                .orElseThrow(() -> new NotFoundException(ARTICLE_NOT_FOUND_MESSAGE));
//
//        return toResponse(article);
//    }
//
//
//    @Transactional
//    public ArticleResponse createArticle(Long userId, ArticleCreateRequest request) {
//        User user = userRepository.findById(userId)
//                .orElseThrow(() -> new NotFoundException("Пользователь не найден"));
//
//        ContentItem contentItem = new ContentItem();
//        contentItem.setOwner(user);
//        contentItem.setTitle(request.getTitle());
//        contentItem.setItemType(ItemType.ARTICLE);
//        contentItem.setContentStatus(ContentStatus.PUBLISHED);
//        contentItem.setVisibility(toDomainVisibility(request.getVisibility()));
//        contentItem.setPreview(extractPreview(request.getText()));
//        contentItem.setCreatedAt(Instant.now());
//        contentItem.setUpdatedAt(Instant.now());
//
//        ContentItem savedContentItem = contentItemRepository.save(contentItem);
//
//        Article article = new Article();
//        article.setContentItem(savedContentItem);
//        article.setText(request.getText());
//
//        Article savedArticle = articleRepository.save(article);
//
//        return toResponse(savedArticle);
//    }
//
//    @Transactional
//    public ArticleResponse updateArticle(Long userId, Long contentItemId, ArticleUpdateRequest request) {
//        ContentItem contentItem = contentItemRepository.findById(contentItemId)
//                .orElseThrow(() -> new NotFoundException(ARTICLE_NOT_FOUND_MESSAGE));
//
//        Article article = articleRepository.findByContentItem(contentItem)
//                .orElseThrow(() -> new NotFoundException(ARTICLE_NOT_FOUND_MESSAGE));
//
//
//        if (!contentItem.getOwner().getId().equals(userId)) {
//            log.debug("Access is denied ownerId={}, userId={}", contentItem.getOwner().getId(), userId);
//            throw new ForbiddenException("Доступ к статье запрещен");
//        }
//
//        contentItem.setTitle(request.getTitle());
//        contentItem.setVisibility(toDomainVisibility(request.getVisibility()));
//        contentItem.setPreview(extractPreview(request.getText()));
//
//        article.setText(request.getText());
//
//        return toResponse(article);
//    }
//
//    @Transactional
//    public void deleteArticle(Long userId, Long contentItemId) {
//        ContentItem contentItem = contentItemRepository.findById(contentItemId)
//                .orElseThrow(() -> new NotFoundException(ARTICLE_NOT_FOUND_MESSAGE));
//
//        if (contentItem.getItemType() != ItemType.ARTICLE) {
//            throw new NotFoundException(ARTICLE_NOT_FOUND_MESSAGE);
//        }
//
//        if (!contentItem.getOwner().getId().equals(userId)) {
//            log.debug("Access is denied ownerId={}, userId={}", contentItem.getOwner().getId(), userId);
//            throw new ForbiddenException("Доступ к статье запрещен");
//        }
//
//        contentItemRepository.delete(contentItem);
//    }
//
//    private Visibility toDomainVisibility(
//            ru.kpfu.itis.sorokin.sdevpoint.api.generated.dto.Visibility visibility) {
//        return Visibility.valueOf(visibility.name());
//    }
//
//    private ru.kpfu.itis.sorokin.sdevpoint.api.generated.dto.Visibility toApiVisibility(Visibility visibility) {
//        return ru.kpfu.itis.sorokin.sdevpoint.api.generated.dto.Visibility.valueOf(visibility.name());
//    }
//
//    private ru.kpfu.itis.sorokin.sdevpoint.api.generated.dto.ContentStatus toApiContentStatus(ContentStatus status) {
//        return ru.kpfu.itis.sorokin.sdevpoint.api.generated.dto.ContentStatus.valueOf(status.name());
//    }
//
//    private OffsetDateTime toOffsetDateTime(Instant instant) {
//        if (instant == null) {
//            return null;
//        }
//
//        return instant.atOffset(ZoneOffset.UTC);
//    }
//
//    private ArticleResponse toResponse(Article article) {
//        ContentItem contentItem = article.getContentItem();
//
//        ArticleResponse response = new ArticleResponse();
//        response.setId(contentItem.getId());
//        response.setTitle(contentItem.getTitle());
//        response.setText(article.getText());
//        response.setVisibility(toApiVisibility(contentItem.getVisibility()));
//        response.setStatus(toApiContentStatus(contentItem.getContentStatus()));
//        response.setPreview(contentItem.getPreview());
//        response.setCreatedAt(toOffsetDateTime(contentItem.getCreatedAt()));
//        response.setUpdatedAt(toOffsetDateTime(contentItem.getUpdatedAt()));
//
//        return response;
//    }
}
