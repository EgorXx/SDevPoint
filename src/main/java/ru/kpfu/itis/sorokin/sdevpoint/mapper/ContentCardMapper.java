package ru.kpfu.itis.sorokin.sdevpoint.mapper;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import ru.kpfu.itis.sorokin.sdevpoint.dto.ContentCardView;
import ru.kpfu.itis.sorokin.sdevpoint.entity.ContentItem;
import ru.kpfu.itis.sorokin.sdevpoint.entity.User;
import ru.kpfu.itis.sorokin.sdevpoint.service.ContentViewService;

@Component
@RequiredArgsConstructor
public class ContentCardMapper {
    private final ContentViewService contentViewService;

    public ContentCardView toView(ContentItem contentItem, Long currentUserId) {
        return new ContentCardView(
                contentItem.getId(),
                contentItem.getItemType().toString(),
                resolveUsername(currentUserId, contentItem.getOwner()),
                contentViewService.resolveContentTitle(contentItem.getTitle()),
                contentItem.getPreview(),
                contentViewService.formatDate(contentItem.getCreatedAt()),
                contentItem.getContentStatus().toString(),
                contentItem.getVisibility().toString()
        );
    }

    private String resolveUsername(Long userId, User owner) {
        return owner.getId().equals(userId) ? "ВЫ" : owner.getUsername();
    }

}
