package ru.kpfu.itis.sorokin.sdevpoint.service;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ru.kpfu.itis.sorokin.sdevpoint.dto.PublishedContentCardView;
import ru.kpfu.itis.sorokin.sdevpoint.dto.FavoritePageView;
import ru.kpfu.itis.sorokin.sdevpoint.entity.*;
import ru.kpfu.itis.sorokin.sdevpoint.exception.NotFoundException;
import ru.kpfu.itis.sorokin.sdevpoint.repository.ContentItemRepository;
import ru.kpfu.itis.sorokin.sdevpoint.repository.FavoriteRepository;
import ru.kpfu.itis.sorokin.sdevpoint.repository.UserRepository;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class FavoriteService {
    private final FavoriteRepository favoriteRepository;
    private final ContentViewService contentViewService;
    private final ContentItemRepository contentItemRepository;
    private final UserRepository userRepository;

    @Transactional(readOnly = true)
    public FavoritePageView getUserFavorites(Long currentUserId, int page, int size) {
        int safePage = Math.max(page, 0);
        int safeSize = Math.clamp(size, 1, 50);

        Pageable pageable = PageRequest.of(
                safePage,
                safeSize
        );

        Page<Favorite> favorites = favoriteRepository.findByUserId(currentUserId, pageable);

        List<PublishedContentCardView> publishedContentCardViews = favorites.map(
                favorite -> new PublishedContentCardView(
                        favorite.getContentItem().getId(),
                        favorite.getContentItem().getItemType().toString(),
                        getOwner(currentUserId, favorite.getContentItem().getOwner()),
                        favorite.getContentItem().getTitle(),
                        favorite.getContentItem().getPreview(),
                        contentViewService.formatDate(favorite.getContentItem().getCreatedAt())
                ))
                .toList();

        return new FavoritePageView(
                publishedContentCardViews,
                favorites.getNumber(),
                favorites.getSize(),
                favorites.getTotalElements(),
                favorites.getTotalPages(),
                favorites.hasPrevious(),
                favorites.hasNext()
        );
    }

    private String getOwner(Long userId, User owner) {
        return owner.getId().equals(userId) ? "ВЫ" : owner.getUsername();
    }

    @Transactional
    public void toggle(Long userId, Long contentId) {
        Optional<Favorite> optionalFavorite = favoriteRepository.findByUserIdAndContentItemId(userId, contentId);

        if (optionalFavorite.isPresent()) {
            favoriteRepository.delete(optionalFavorite.get());
        } else {
            ContentItem contentItem = contentItemRepository.findWithOwnerById(contentId)
                    .orElseThrow(() -> new NotFoundException("Контент не найден"));

            checkCanAddToFavorite(contentItem, userId);

            User user = userRepository.findById(userId)
                            .orElseThrow(() -> new NotFoundException("Пользователь не найден"));

            Favorite favorite = new Favorite(null, contentItem, user);

            favoriteRepository.save(favorite);
        }
    }

    private void checkCanAddToFavorite(ContentItem contentItem, Long userId) {
        if (contentItem.getContentStatus() != ContentStatus.PUBLISHED) {
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
