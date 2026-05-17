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
import ru.kpfu.itis.sorokin.sdevpoint.exception.ForbiddenException;
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
public class CaseService {
    private final UserRepository userRepository;
    private final ContentItemRepository contentItemRepository;
    private final CaseRepository caseRepository;
    private final FavoriteRepository favoriteRepository;
    private final ContentViewRepository contentViewRepository;
    private final ContentViewService contentViewService;
    private final MarkdownRenderService markdownRenderService;
    private final ContentImageCleanupService contentImageCleanupService;
    private final StorageDeletionTaskRepository storageDeletionTaskRepository;
    private final ReactionService reactionService;
    private final ContentLimitService contentLimitService;

    private static final String CASE_NOT_FOUND_MESSAGE = "Кейс не найден";


    @Transactional
    public Long getOrCreateDraft(Long userId) {
        User owner = userRepository.findById(userId)
                .orElseThrow(CurrentUserNotFoundException::new);

        Optional<Long> optionalContentItemId =
                contentItemRepository.findDraftByUserIdAndItemType(userId, ItemType.CASE)
                        .map(ContentItem::getId);

        if (optionalContentItemId.isPresent()) {
            return optionalContentItemId.get();
        }

        contentLimitService.checkCountContentLimit(userId);

        ContentItem contentItem = ContentItem.createDraft(owner, ItemType.CASE);
        contentItemRepository.save(contentItem);

        return contentItem.getId();
    }

    public CaseCreateView getCaseDraft(Long draftId, Long userId) {
        ContentItem contentItem = getEditableDraft(draftId, userId);

        Optional<Case> optionalCase = caseRepository.findByContentItemId(draftId);

        boolean hasSolution = false;
        String description = "";
        String solution = "";

        if (optionalCase.isPresent()) {
            description = optionalCase.get().getDescription();
            solution = optionalCase.get().getSolution();
        }

        hasSolution = !solution.isEmpty();

        String title = ContentItem.isGenerateTitle(contentItem.getTitle()) ? "" : contentItem.getTitle();

        return new CaseCreateView(
                draftId,
                title,
                description,
                hasSolution,
                solution,
                contentItem.getVisibility()
        );
    }

    @Transactional
    public void updateDraft(CaseCreateDto caseCreateDto, Long userId) {
        ContentItem contentItem = getEditableDraft(caseCreateDto.draftId(), userId);

        applyDraftData(contentItem, caseCreateDto);
    }

    @Transactional
    public void publishDraft(CaseCreateDto caseCreateDto, Long userId) {
        ContentItem contentItem = getEditableDraft(caseCreateDto.draftId(), userId);

        applyDraftData(contentItem, caseCreateDto);

        contentItem.setContentStatus(ContentStatus.PENDING_REVIEW);

        contentImageCleanupService.cleanupUnusedImages(
                contentItem.getId(),
                List.of(caseCreateDto.description(), caseCreateDto.solution())
        );
    }

    @Transactional
    public CaseView getCaseView(Long contentItemId, Long userId) {
        Case caseEntity = caseRepository.findByContentItemId(contentItemId)
                .orElseThrow(() -> new NotFoundException(CASE_NOT_FOUND_MESSAGE));

        ContentItem contentItem = caseEntity.getContentItem();

        checkCaseViewAccess(contentItem, userId);

        if (userId != null) {
            contentViewRepository.insertIfNotExists(contentItemId, userId);
        }

        long countViews = contentViewRepository.countViewsContent(contentItemId);

        ReactionResponse reactionResponse = reactionService.getReactionInfo(
                contentItemId,
                userId
        );

        boolean reactionAllowed = contentItem.getContentStatus() == ContentStatus.PUBLISHED;

        return new CaseView(
                contentItem.getId(),
                contentItem.getTitle(),
                contentItem.getOwner().getUsername(),
                markdownRenderService.renderToSafeHtml(caseEntity.getDescription()),
                !caseEntity.getSolution().isEmpty(),
                markdownRenderService.renderToSafeHtml(caseEntity.getSolution()),
                contentViewService.formatDate(contentItem.getCreatedAt()),
                contentViewService.formatDate(contentItem.getUpdatedAt()),
                countViews,
                reactionResponse,
                reactionAllowed
        );
    }

    private ContentItem getEditableDraft(Long draftId, Long userId) {
        return contentItemRepository.findDraftByIdAndOwnerId(draftId, userId, ItemType.CASE)
                .orElseThrow(() -> new NotFoundException("Контент не найден"));
    }

    private Case applyDraftData(ContentItem contentItem, CaseCreateDto dto) {
        contentItem.setTitle(dto.title());
        contentItem.setPreview(contentViewService.formatPreviewFromText(dto.description()));
        contentItem.setVisibility(dto.visibility());

        Case caseEntity = caseRepository.findByContentItemId(contentItem.getId())
                .orElseGet(() -> new Case(
                        null,
                        contentItem,
                        dto.description(),
                        dto.hasSolution() ? dto.solution() : ""
                ));

        caseEntity.setDescription(dto.description());
        caseEntity.setSolution(dto.hasSolution() ? dto.solution() : "");

        return caseRepository.save(caseEntity);
    }

    @Transactional(readOnly = true)
    public CaseEditView getCaseToEdit(Long contentId, Long userId) {
        Case caseEntity = caseRepository.findByContentItemId(contentId)
                .orElseThrow(() -> new NotFoundException(CASE_NOT_FOUND_MESSAGE));

        ContentItem contentItem = caseEntity.getContentItem();

        checkCaseEditAccess(contentItem, userId);

        return new CaseEditView(
                contentId,
                contentItem.getTitle(),
                caseEntity.getDescription(),
                !caseEntity.getSolution().isEmpty(),
                caseEntity.getSolution(),
                contentItem.getVisibility()
        );
    }

    @Transactional
    public void update(CaseEditDto caseEditDto, Long userId) {
        Case caseEntity = caseRepository.findByContentItemId(caseEditDto.contentItemId())
                .orElseThrow(() -> new NotFoundException(CASE_NOT_FOUND_MESSAGE));

        ContentItem contentItem = caseEntity.getContentItem();

        checkCaseEditAccess(contentItem, userId);

        contentItem.setTitle(caseEditDto.title());
        contentItem.setVisibility(caseEditDto.visibility());
        contentItem.setPreview(contentViewService.formatPreviewFromText(caseEditDto.description()));
        contentItem.setUpdatedAt(Instant.now());
        contentItem.setContentStatus(ContentStatus.PENDING_REVIEW);

        caseEntity.setDescription(caseEditDto.description());
        caseEntity.setSolution(caseEditDto.hasSolution() ? caseEditDto.solution() : "");

        contentImageCleanupService.cleanupUnusedImages(
                contentItem.getId(),
                List.of(caseEditDto.description(), caseEditDto.solution())
        );
    }

    @Transactional
    public void deleteCase(Long contentItemId, Long userId) {
        ContentItem contentItem = contentItemRepository.findByIdAndOwnerIdAndItemType(
                contentItemId,
                userId,
                ItemType.CASE
        ).orElseThrow(() -> new NotFoundException(CASE_NOT_FOUND_MESSAGE));

        storageDeletionTaskRepository.save(
                StorageDeletionTask.createContentDirectoryDeletion(contentItem.getId())
        );

        contentItemRepository.delete(contentItem);
    }

    @Transactional(readOnly = true)
    public CasePageView getPublishedCases(Long userId, int page, int size) {
        int safePage = Math.max(0, page);
        int safeSize = Math.clamp(size, 1, 50);

        Pageable pageable = PageRequest.of(
                safePage,
                safeSize,
                Sort.by(Sort.Direction.DESC, "createdAt")
        );

        Page<ContentItem> contentItems = contentItemRepository.findContentItemsByContentStatusAndItemTypeAndVisibility(
                ContentStatus.PUBLISHED,
                ItemType.CASE,
                Visibility.PUBLIC,
                pageable
        );

        List<Long> contentIds = contentItems.map(ContentItem::getId).toList();

        Set<Long> favoriteContentIds = userId == null || contentIds.isEmpty() ?
                Set.of() : favoriteRepository.findFavoriteContentIds(userId, contentIds);

        List<CaseCardView> caseCardViews = contentItems.map(
                contentItem -> new CaseCardView(
                        contentItem.getId(),
                        contentItem.getOwner().getUsername(),
                        contentItem.getTitle(),
                        contentItem.getPreview(),
                        contentViewService.formatDate(contentItem.getCreatedAt()),
                        favoriteContentIds.contains(contentItem.getId())
                ))
                .toList();

        return new CasePageView(
                caseCardViews,
                contentItems.getNumber(),
                contentItems.getSize(),
                contentItems.getTotalElements(),
                contentItems.getTotalPages(),
                contentItems.hasPrevious(),
                contentItems.hasNext()
        );
    }

    private void checkCaseViewAccess(ContentItem contentItem, Long userId) {
        ContentStatus status = contentItem.getContentStatus();

        switch (status) {
            case DRAFT -> throw new NotFoundException(CASE_NOT_FOUND_MESSAGE);

            case PENDING_REVIEW, REJECTED -> {
                if (!isOwner(contentItem, userId)) {
                    throw new NotFoundException(CASE_NOT_FOUND_MESSAGE);
                }
            }

            case PUBLISHED -> {
                if (contentItem.getVisibility() == Visibility.PRIVATE
                        && !isOwner(contentItem, userId)) {
                    throw new NotFoundException(CASE_NOT_FOUND_MESSAGE);
                }
            }

            default -> throw new NotFoundException(CASE_NOT_FOUND_MESSAGE);
        }
    }

    private void checkCaseEditAccess(ContentItem contentItem, Long userId) {
        if (!isOwner(contentItem, userId)) {
            throw new NotFoundException(CASE_NOT_FOUND_MESSAGE);
        }

        switch (contentItem.getContentStatus()) {
            case DRAFT -> throw new NotFoundException(CASE_NOT_FOUND_MESSAGE);

            case PENDING_REVIEW -> throw new NotFoundException(CASE_NOT_FOUND_MESSAGE);

            case PUBLISHED, REJECTED -> {
                // редактирование разрешено владельцу
            }

            default -> throw new NotFoundException(CASE_NOT_FOUND_MESSAGE);
        }
    }

    public boolean isOwner(ContentItem contentItem, Long userId) {
        return contentItem.getOwner().getId().equals(userId);
    }
}
