package ru.kpfu.itis.sorokin.sdevpoint.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ru.kpfu.itis.sorokin.sdevpoint.dto.ReactionResponse;
import ru.kpfu.itis.sorokin.sdevpoint.entity.*;
import ru.kpfu.itis.sorokin.sdevpoint.exception.BadRequestException;
import ru.kpfu.itis.sorokin.sdevpoint.exception.CurrentUserNotFoundException;
import ru.kpfu.itis.sorokin.sdevpoint.exception.ForbiddenException;
import ru.kpfu.itis.sorokin.sdevpoint.exception.NotFoundException;
import ru.kpfu.itis.sorokin.sdevpoint.repository.ContentItemRepository;
import ru.kpfu.itis.sorokin.sdevpoint.repository.ReactionRepository;
import ru.kpfu.itis.sorokin.sdevpoint.repository.UserRepository;

@Service
@RequiredArgsConstructor
public class ReactionService {
    private final ReactionRepository reactionRepository;
    private final ContentItemRepository contentItemRepository;
    private final UserRepository userRepository;

    @Transactional
    public ReactionResponse react(Long contentItemId, Long userId, ReactionType reactionType) {
        ContentItem contentItem = contentItemRepository.findWithOwnerById(contentItemId)
                .orElseThrow(() -> new NotFoundException("Контент не найден"));

        checkCanAddReaction(contentItem, userId);

        reactionRepository.findByContentItemIdAndUserId(contentItemId, userId)
                .ifPresentOrElse(
                existingReaction -> updateExistingReaction(
                        existingReaction,
                        reactionType
                ),
                () -> createReaction(
                        userId,
                        contentItem,
                        reactionType
                )
        );

        return getReactionInfo(contentItemId, userId);
    }

    private void updateExistingReaction(Reaction existingReaction, ReactionType newReactionType) {
        if (existingReaction.getReactionType() == newReactionType) {
            reactionRepository.delete(existingReaction);
            return;
        }

        existingReaction.setReactionType(newReactionType);
    }

    private void createReaction(Long userId, ContentItem contentItem, ReactionType reactionType) {
        User user = userRepository.findById(userId)
                .orElseThrow(CurrentUserNotFoundException::new);

        Reaction reaction = new Reaction(user, contentItem, reactionType);

        reactionRepository.save(reaction);
    }

    private boolean isOwner(ContentItem contentItem, Long userId) {
        return contentItem.getOwner().getId().equals(userId);
    }

    @Transactional(readOnly = true)
    public ReactionResponse getReactionInfo(Long contentItemId, Long userId) {
        ReactionType reactionType = reactionRepository.findByContentItemIdAndUserId(
                contentItemId,
                userId
        ).map(Reaction::getReactionType).orElse(null);

        long likesCount = reactionRepository.countByContentItemIdAndReactionType(
                contentItemId,
                ReactionType.LIKE
        );

        long dislikesCount = reactionRepository.countByContentItemIdAndReactionType(
                contentItemId,
                ReactionType.DISLIKE
        );

        return new ReactionResponse(
                likesCount,
                dislikesCount,
                reactionType != null,
                reactionType
        );
    }

    private void checkCanAddReaction(ContentItem contentItem, Long userId) {
        if (contentItem.getContentStatus() != ContentStatus.PUBLISHED) {
            throw new BadRequestException("Реакции доступны только для опубликованного контента");
        }

        if (contentItem.getVisibility() == Visibility.PRIVATE && !isOwner(contentItem, userId)) {
            throw new ForbiddenException("Недостаточно прав, чтобы оценить контент");
        }
    }
}
