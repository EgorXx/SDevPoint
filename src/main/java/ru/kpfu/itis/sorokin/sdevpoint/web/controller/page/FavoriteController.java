package ru.kpfu.itis.sorokin.sdevpoint.web.controller.page;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import ru.kpfu.itis.sorokin.sdevpoint.dto.FavoritePageView;
import ru.kpfu.itis.sorokin.sdevpoint.service.CustomUserDetails;
import ru.kpfu.itis.sorokin.sdevpoint.service.FavoriteService;

@Controller
@RequiredArgsConstructor
public class FavoriteController {

    private final FavoriteService favoriteService;

    @GetMapping("/favorites")
    public String getUserFavorites(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @AuthenticationPrincipal CustomUserDetails customUserDetails,
            Model model
    ) {
        FavoritePageView favoritePage = favoriteService.getUserFavorites(
                customUserDetails.getUserId(),
                page,
                size
        );

        model.addAttribute("page", favoritePage);

        return "favorite/view";
    }

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
