package ru.kpfu.itis.sorokin.sdevpoint.web.controller.page;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import ru.kpfu.itis.sorokin.sdevpoint.dto.ProfileSettingsView;
import ru.kpfu.itis.sorokin.sdevpoint.dto.ProfileView;
import ru.kpfu.itis.sorokin.sdevpoint.service.CustomUserDetails;
import ru.kpfu.itis.sorokin.sdevpoint.service.UserService;
import ru.kpfu.itis.sorokin.sdevpoint.web.form.ProfileNameSettingsForm;

@Controller
@RequiredArgsConstructor
public class ProfileController {
    private final UserService userService;

    @GetMapping("/users/{userId}")
    public String getUserProfile(
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

    @GetMapping("/profile")
    public String getProfile(
            @AuthenticationPrincipal CustomUserDetails userDetails,
            Model model
    ) {
        ProfileView profile = userService.getProfileView(
                userDetails.getUserId(),
                userDetails.getUserId()
        );

        model.addAttribute("profile", profile);

        return "profile/view";
    }

    @GetMapping("/profile/settings")
    public String getSettings(
            @AuthenticationPrincipal CustomUserDetails userDetails,
            Model model
    ) {
        ProfileSettingsView settings = userService.getProfileSettingsView(userDetails.getUserId());

        model.addAttribute("nameForm", new ProfileNameSettingsForm(settings.username()));

        return "profile/settings";
    }

    @PostMapping("/profile/settings/name")
    public String updateName(
            @AuthenticationPrincipal CustomUserDetails userDetails,
            @Valid @ModelAttribute("nameForm") ProfileNameSettingsForm nameForm,
            BindingResult bindingResult,
            Model model,
            RedirectAttributes redirectAttributes
    ) {
        if (bindingResult.hasErrors()) {
            return "profile/settings";
        }

        userService.updateName(userDetails.getUserId(), nameForm);

        redirectAttributes.addFlashAttribute("success", "Имя пользователя обновлено");

        return "redirect:/profile/settings";
    }
}
