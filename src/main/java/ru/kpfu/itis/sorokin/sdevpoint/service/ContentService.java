package ru.kpfu.itis.sorokin.sdevpoint.service;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ru.kpfu.itis.sorokin.sdevpoint.dto.ContentCardView;
import ru.kpfu.itis.sorokin.sdevpoint.dto.ContentPageView;
import ru.kpfu.itis.sorokin.sdevpoint.dto.ContentRejectionCommentView;
import ru.kpfu.itis.sorokin.sdevpoint.entity.ContentItem;
import ru.kpfu.itis.sorokin.sdevpoint.entity.ContentRejectionComment;
import ru.kpfu.itis.sorokin.sdevpoint.entity.ContentStatus;
import ru.kpfu.itis.sorokin.sdevpoint.exception.BadRequestException;
import ru.kpfu.itis.sorokin.sdevpoint.exception.NotFoundException;
import ru.kpfu.itis.sorokin.sdevpoint.repository.ContentItemRepository;
import ru.kpfu.itis.sorokin.sdevpoint.repository.ContentRejectionCommentRepository;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ContentService {
    private final ContentItemRepository contentItemRepository;
    private final ContentViewService contentViewService;
    private final ContentRejectionCommentRepository contentRejectionCommentRepository;

    @Transactional(readOnly = true)
    public ContentPageView getMyContent(Long userId, int page, int size) {
        int safePage = Math.max(page, 0);
        int safeSize = Math.clamp(size, 1, 50);

        Pageable pageable = PageRequest.of(
                safePage,
                safeSize,
                Sort.by(Sort.Order.desc("createdAt"))
        );

        Page<ContentItem> contentItems = contentItemRepository.findByOwnerId(
                userId,
                pageable
        );

        List<ContentCardView> cards = contentItems
                .map(contentItem -> new ContentCardView(
                        contentItem.getId(),
                        contentItem.getItemType().toString(),
                        contentItem.getOwner().getUsername(),
                        contentItem.getTitle(),
                        contentItem.getPreview(),
                        contentViewService.formatDate(contentItem.getCreatedAt()),
                        contentItem.getContentStatus().toString(),
                        contentItem.getVisibility().toString()
                ))
                .toList();

        return new ContentPageView(
                cards,
                contentItems.getNumber(),
                contentItems.getSize(),
                contentItems.getTotalElements(),
                contentItems.getTotalPages(),
                contentItems.hasPrevious(),
                contentItems.hasNext()
        );
    }

    @Transactional
    public void withdrawContent(Long contentId, Long userId) {
        ContentItem contentItem = contentItemRepository
                .findByIdAndOwnerId(contentId, userId)
                .orElseThrow(() -> new NotFoundException("Контент не найден"));

        if (contentItem.getContentStatus() != ContentStatus.PENDING_REVIEW) {
            throw new BadRequestException("Отозвать можно только контент на проверке");
        }

        contentItem.setContentStatus(ContentStatus.REJECTED);

        String comment = "Вы отклонили публикацию сами";

        contentRejectionCommentRepository.findByContentItemId(contentId)
                .ifPresentOrElse(
                        rejectionComment -> rejectionComment.updateComment(comment),
                        () -> contentRejectionCommentRepository.save(
                                ContentRejectionComment.create(contentItem, comment)
                        )
                );
    }

    @Transactional
    public void rejectContent(Long contentId, Long adminId, String comment) {
        ContentItem contentItem = contentItemRepository.findById(contentId)
                .orElseThrow(() -> new NotFoundException("Контент не найден"));

        if (contentItem.getContentStatus() != ContentStatus.PENDING_REVIEW) {
            throw new BadRequestException("Отклонить можно только контент на проверке");
        }

        contentItem.setContentStatus(ContentStatus.REJECTED);

        contentRejectionCommentRepository.findByContentItemId(contentId)
                .ifPresentOrElse(
                        rejectionComment -> rejectionComment.updateComment(comment),
                        () -> contentRejectionCommentRepository.save(
                                ContentRejectionComment.create(contentItem, comment)
                        )
                );
    }

    @Transactional(readOnly = true)
    public ContentRejectionCommentView getRejectionComment(Long contentId, Long userId) {
        ContentItem contentItem = contentItemRepository
                .findByIdAndOwnerId(contentId, userId)
                .orElseThrow(() -> new NotFoundException("Контент не найден"));

        if (contentItem.getContentStatus() != ContentStatus.REJECTED) {
            throw new NotFoundException("Комментарий не найден");
        }

        ContentRejectionComment rejectionComment = contentRejectionCommentRepository
                .findByContentItemId(contentId)
                .orElseThrow(() -> new NotFoundException("Комментарий не найден"));

        return new ContentRejectionCommentView(rejectionComment.getComment());
    }

    @Transactional
    public void approveContent(Long contentId, Long adminId) {
        ContentItem contentItem = contentItemRepository.findById(contentId)
                .orElseThrow(() -> new NotFoundException("Контент не найден"));

        if (contentItem.getContentStatus() != ContentStatus.PENDING_REVIEW) {
            throw new BadRequestException("Одобрить можно только контент на проверке");
        }

        contentItem.setContentStatus(ContentStatus.PUBLISHED);

        contentRejectionCommentRepository.deleteByContentItemId(contentId);
    }

    @Transactional(readOnly = true)
    public ContentPageView getContentForReview(Long userId, int page, int size) {
        int safePage = Math.max(page, 0);
        int safeSize = Math.clamp(size, 1, 50);

        Pageable pageable = PageRequest.of(
                safePage,
                safeSize,
                Sort.by(Sort.Order.desc("createdAt"))
        );

        Page<ContentItem> contentItems = contentItemRepository
                .findByContentStatus(ContentStatus.PENDING_REVIEW, pageable);

        List<ContentCardView> cards = contentItems
                .map(contentItem -> new ContentCardView(
                        contentItem.getId(),
                        contentItem.getItemType().toString(),
                        contentItem.getOwner().getUsername(),
                        contentItem.getTitle(),
                        contentItem.getPreview(),
                        contentViewService.formatDate(contentItem.getCreatedAt()),
                        contentItem.getContentStatus().toString(),
                        contentItem.getVisibility().toString()
                ))
                .toList();

        return new ContentPageView(
                cards,
                contentItems.getNumber(),
                contentItems.getSize(),
                contentItems.getTotalElements(),
                contentItems.getTotalPages(),
                contentItems.hasPrevious(),
                contentItems.hasNext()
        );
    }
}
