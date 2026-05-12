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
import ru.kpfu.itis.sorokin.sdevpoint.exception.CaseAlreadyPublished;
import ru.kpfu.itis.sorokin.sdevpoint.exception.CurrentUserNotFoundException;
import ru.kpfu.itis.sorokin.sdevpoint.exception.ForbiddenException;
import ru.kpfu.itis.sorokin.sdevpoint.exception.NotFoundException;
import ru.kpfu.itis.sorokin.sdevpoint.markdown.MarkdownRenderService;
import ru.kpfu.itis.sorokin.sdevpoint.repository.CaseRepository;
import ru.kpfu.itis.sorokin.sdevpoint.repository.ContentItemRepository;
import ru.kpfu.itis.sorokin.sdevpoint.repository.FavoriteRepository;
import ru.kpfu.itis.sorokin.sdevpoint.repository.UserRepository;

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
    private final ContentViewService contentViewService;
    private final MarkdownRenderService markdownRenderService;


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
    public Long publishDraft(CaseCreateDto caseCreateDto, Long userId) {
        ContentItem contentItem = getEditableDraft(caseCreateDto.draftId(), userId);

        applyDraftData(contentItem, caseCreateDto);

        contentItem.setContentStatus(ContentStatus.PUBLISHED);

        return contentItem.getId();
    }

    @Transactional(readOnly = true)
    public CaseView getCaseView(Long contentItemId, Long userId) {
        Case caseEntity = caseRepository.findByContentItemId(contentItemId)
                .orElseThrow(() -> new NotFoundException("Кейс не найден"));

        ContentItem contentItem = caseEntity.getContentItem();

        if (contentItem.getVisibility() == Visibility.PRIVATE) {
            checkAccess(contentItem, userId);
        }

        return new CaseView(
                contentItem.getId(),
                contentItem.getTitle(),
                contentItem.getOwner().getUsername(),
                markdownRenderService.renderToSafeHtml(caseEntity.getDescription()),
                !caseEntity.getSolution().isEmpty(),
                markdownRenderService.renderToSafeHtml(caseEntity.getSolution()),
                contentViewService.formatDate(contentItem.getCreatedAt()),
                contentViewService.formatDate(contentItem.getUpdatedAt())
        );
    }

    private ContentItem getEditableDraft(Long draftId, Long userId) {
        ContentItem contentItem = contentItemRepository.findById(draftId)
                .orElseThrow(() -> new NotFoundException("Контент не найден"));

        checkAccess(contentItem, userId);

        if (contentItem.getContentStatus() == ContentStatus.PUBLISHED) {
            log.debug("Access is denied, case has already been published contentItemId={}", contentItem.getId());
            throw new CaseAlreadyPublished("Кейс уже опубликован");
        }

        return contentItem;
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

    private void checkAccess(ContentItem contentItem, Long userId) {
        if (userId == null) {
            throw new ForbiddenException("Доступ к кейсу запрещен");
        }

        if (!contentItem.getOwner().getId().equals(userId)) {
            log.debug("Access is denied ownerId={}, userId={}", contentItem.getOwner().getId(), userId);
            throw new ForbiddenException("Доступ к кейсу запрещен");
        }
    }

    @Transactional(readOnly = true)
    public CaseEditView getCaseToEdit(Long contentId, Long userId) {
        Case caseEntity = caseRepository.findByContentItemId(contentId)
                .orElseThrow(() -> new NotFoundException("Кейс не найден"));

        ContentItem contentItem = caseEntity.getContentItem();

        checkAccess(contentItem, userId);

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
                .orElseThrow(() -> new NotFoundException("Кейс не найден"));

        ContentItem contentItem = caseEntity.getContentItem();

        checkAccess(contentItem, userId);

        contentItem.setTitle(caseEditDto.title());
        contentItem.setVisibility(caseEditDto.visibility());
        contentItem.setPreview(contentViewService.formatPreviewFromText(caseEditDto.description()));
        contentItem.setUpdatedAt(Instant.now());

        caseEntity.setDescription(caseEditDto.description());
        caseEntity.setSolution(caseEditDto.hasSolution() ? caseEditDto.solution() : "");
    }

    @Transactional
    public void deleteCase(Long contentId, Long userId) {
        Case caseEntity = caseRepository.findByContentItemId(contentId)
                .orElseThrow(() -> new NotFoundException("Кейс не найден"));

        ContentItem contentItem = caseEntity.getContentItem();

        checkAccess(contentItem, userId);

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
}
