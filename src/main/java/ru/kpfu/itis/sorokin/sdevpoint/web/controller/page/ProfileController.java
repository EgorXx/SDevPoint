package ru.kpfu.itis.sorokin.sdevpoint.web.controller.page;

import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import ru.kpfu.itis.sorokin.sdevpoint.dto.ProfileView;
import ru.kpfu.itis.sorokin.sdevpoint.service.CustomUserDetails;
import ru.kpfu.itis.sorokin.sdevpoint.service.UserService;

@Controller
@RequiredArgsConstructor
public class ProfileController {
    private final UserService userService;

    @GetMapping("/profile/{userId}")
    public String getProfile(
            @PathVariable("userId") Long userId,
            @AuthenticationPrincipal CustomUserDetails userDetails,
            Model model
    ) {
        Long currentUserId = userDetails == null
                ? null
                : userDetails.getUserId();

        ProfileView profile = userService.getProfileView(
                userId,
                currentUserId
        );

        model.addAttribute("profile", profile);

        return "profile/view";
    }
}
