package ru.kpfu.itis.sorokin.sdevpoint.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.cache.annotation.CacheEvict;
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
import ru.kpfu.itis.sorokin.sdevpoint.properties.ContentLimitProperties;
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
    private final ContentLimitService contentLimitService;

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

        contentLimitService.checkCountContentLimit(userId);

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

        boolean isFavourite = userId != null
                && favoriteRepository.findByUserIdAndContentItemId(userId, contentItemId).isPresent();

        return new ArticleView(
                contentItem.getId(),
                contentItem.getTitle(),
                contentItem.getOwner().getUsername(),
                markdownRenderService.renderToSafeHtml(article.getText()),
                contentViewService.formatDate(contentItem.getCreatedAt()),
                contentViewService.formatDate(contentItem.getUpdatedAt()),
                countViews,
                reactionResponse,
                reactionAllowed,
                isFavourite
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

    @CacheEvict(cacheNames = "aiSummary", key = "#articleEditDto.contentItemId")
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

    @CacheEvict(cacheNames = "aiSummary", key = "#contentItemId")
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
        if (isAdmin(userId)) {
            return;
        }

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

    public boolean isAdmin(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(CurrentUserNotFoundException::new);

        return user.getRole() == Role.ROLE_ADMIN;
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
}
