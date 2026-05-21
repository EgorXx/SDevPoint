package ru.kpfu.itis.sorokin.sdevpoint.web.controller.ajax;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;
import ru.kpfu.itis.sorokin.sdevpoint.service.CustomUserDetails;
import ru.kpfu.itis.sorokin.sdevpoint.service.FavoriteService;

@RestController
@RequiredArgsConstructor
public class FavouriteAjaxController {
    private final FavoriteService favoriteService;

    @PostMapping("api/favorites/content/{contentId}")
    public ResponseEntity<Void> toggleFavorite(
            @PathVariable("contentId") Long contentId,
            @AuthenticationPrincipal CustomUserDetails customUserDetails
    ) {
        favoriteService.toggle(
                customUserDetails.getUserId(),
                contentId
        );

        return ResponseEntity.ok().build();
    }
}
