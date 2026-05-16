package ru.kpfu.itis.sorokin.sdevpoint.web.controller.page;

import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import ru.kpfu.itis.sorokin.sdevpoint.dto.ContentPageView;
import ru.kpfu.itis.sorokin.sdevpoint.service.ContentService;
import ru.kpfu.itis.sorokin.sdevpoint.service.CustomUserDetails;

@Controller
@RequiredArgsConstructor
public class MyContentController {

    private final ContentService contentService;

    @GetMapping("/my-content")
    public String getMyContent(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @AuthenticationPrincipal CustomUserDetails userDetails,
            Model model
    ) {
        ContentPageView contentPage = contentService.getMyContent(
                userDetails.getUserId(),
                page,
                size
        );

        model.addAttribute("page", contentPage);

        return "content/my-content";
    }
}
