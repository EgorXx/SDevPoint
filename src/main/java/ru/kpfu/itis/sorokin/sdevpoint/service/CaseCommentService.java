package ru.kpfu.itis.sorokin.sdevpoint.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ru.kpfu.itis.sorokin.sdevpoint.dto.CaseCommentView;
import ru.kpfu.itis.sorokin.sdevpoint.dto.CaseDiscussionPageView;
import ru.kpfu.itis.sorokin.sdevpoint.entity.*;
import ru.kpfu.itis.sorokin.sdevpoint.exception.DraftContentAccessException;
import ru.kpfu.itis.sorokin.sdevpoint.exception.NotFoundException;
import ru.kpfu.itis.sorokin.sdevpoint.markdown.MarkdownRenderService;
import ru.kpfu.itis.sorokin.sdevpoint.repository.CaseCommentRepository;
import ru.kpfu.itis.sorokin.sdevpoint.repository.CaseRepository;
import ru.kpfu.itis.sorokin.sdevpoint.repository.UserRepository;

import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class CaseCommentService {
    private final CaseCommentRepository caseCommentRepository;
    private final CaseRepository caseRepository;
    private final ContentViewService contentViewService;
    private final UserRepository userRepository;
    private final MarkdownRenderService markdownRenderService;

    @Transactional(readOnly = true)
    public CaseDiscussionPageView getDiscussionPage(Long userId, Long contentId, int page, int size) {
        Case caseEntity = caseRepository.findByContentItemId(contentId)
                .orElseThrow(() -> new NotFoundException("Кейс не найден"));

        boolean isAdmin = userId != null && userRepository.existsByIdAndRole(userId, Role.ROLE_ADMIN);

        ContentItem contentItem = caseEntity.getContentItem();

        checkAccess(contentItem, userId);

        int safePage = Math.max(page, 0);
        int safeSize = Math.clamp(size, 1, 50);

        Pageable pageable = PageRequest.of(
                safePage,
                safeSize,
                Sort.by(Sort.Direction.DESC, "createdAt")
        );

        Page<CaseComment> caseComments = caseCommentRepository.findByCaseEntityId(
                caseEntity.getId(),
                pageable
        );

        List<CaseCommentView> caseCommentViews = caseComments.map(
                caseComment -> new CaseCommentView(
                        caseComment.getId(),
                        caseComment.getUser().getUsername(),
                        contentViewService.formatDate(caseComment.getCreatedAt()),
                        caseComment.getText(),
                        isCanDelete(userId, isAdmin, caseComment)

                ))
                .toList();

        return new CaseDiscussionPageView(
                contentId,
                contentItem.getOwner().getUsername(),
                contentItem.getTitle(),
                markdownRenderService.renderToSafeHtml(caseEntity.getDescription()),
                contentViewService.formatDate(contentItem.getCreatedAt()),
                caseCommentViews,
                caseComments.getNumber(),
                caseComments.getSize(),
                caseComments.getTotalElements(),
                caseComments.getTotalPages(),
                caseComments.hasPrevious(),
                caseComments.hasNext()
        );
    }

    private boolean isCanDelete(Long userId, boolean isAdmin, CaseComment caseComment) {
        if (userId == null) {return false;}

        return isAdmin || caseComment.getUser().getId().equals(userId);
    }

    private void checkAccess(ContentItem contentItem, Long userId) {
        if (contentItem.getContentStatus() == ContentStatus.DRAFT) {
            if (isOwner(contentItem, userId)) {
                throw new DraftContentAccessException(
                        contentItem.getId(),
                        contentItem.getItemType()
                );
            }

            throw new NotFoundException("Контент не найден");
        }

        if (contentItem.getVisibility() == Visibility.PRIVATE && !isOwner(contentItem, userId)) {
            throw new NotFoundException("Контент не найден");
        }
    }

    private boolean isOwner(ContentItem contentItem, Long userId) {
        if (userId == null) {return false;}

        return contentItem.getOwner().getId().equals(userId);
    }
}
