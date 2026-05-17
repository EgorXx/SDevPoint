package ru.kpfu.itis.sorokin.sdevpoint.web.controller.page;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import ru.kpfu.itis.sorokin.sdevpoint.dto.*;
import ru.kpfu.itis.sorokin.sdevpoint.exception.EmailAlreadyExistsException;
import ru.kpfu.itis.sorokin.sdevpoint.service.EmailVerificationService;
import ru.kpfu.itis.sorokin.sdevpoint.service.UserService;

import java.util.UUID;

@Slf4j
@Controller
@RequiredArgsConstructor
public class AuthController {
    private final EmailVerificationService emailVerificationService;
    private final UserService userService;

    @GetMapping("/auth/login")
    public String login() {
        return "auth/login";
    }

    @GetMapping("/auth/confirm")
    public String confirmEmail(
            @RequestParam UUID token,
            Model model
    ) {
        log.info("Received an email confirmation request: {}", token);

        EmailConfirmView emailConfirmView = emailVerificationService
                .verificationEmail(token);

        model.addAttribute("result", emailConfirmView);

        return "auth/confirm-result";
    }

    @ResponseBody
    @PostMapping("/auth/resend")
    public ResponseEntity<String> resendEmailVerification(HttpSession httpSession) {
        Long userId = (Long) httpSession.getAttribute("registerProcessUserId");

        if (userId == null) {
            return ResponseEntity
                    .status(HttpStatus.CONFLICT)
                    .body("Сессия регистрации истекла. Зарегистрируйтесь заново.");
        }

        log.info("Received an resend email verification request, userId: {}", userId);

        EmailVerificationResendResponse resendResponse = emailVerificationService
                .resendEmailVerification(userId);

        return switch (resendResponse.resendStatus()) {
            case TOO_MANY_REQUEST, RATE_LIMIT_REQUEST -> ResponseEntity.status(HttpStatus.TOO_MANY_REQUESTS).body(resendResponse.message());
            case RESEND, ALREADY_VERIFIED -> ResponseEntity.ok(resendResponse.message());
            case null -> ResponseEntity.ok("Что-то пошло не так");
        };
    }

    @PostMapping("auth/register")
    public String register(
            @Valid @ModelAttribute("form") UserForm userForm,
            BindingResult bindingResult,
            HttpSession httpSession
    ) {
        if (bindingResult.hasErrors()) {
            return "auth/register";
        }

        try {
            Long userId = userService.registerUser(userForm);
            httpSession.setAttribute("registerProcessUserId", userId);
            return "redirect:/auth/pending";
        } catch (EmailAlreadyExistsException _) {
            bindingResult.rejectValue(
                    "email",
                    "email.alreadyExists",
                    "Пользователь с такой почтой уже зарегистрирован"
            );
            return "auth/register";
        }
    }

    @GetMapping("/auth/register")
    public String registerPage(Model model) {
        model.addAttribute("form", new UserForm("", ""));
        return "auth/register";
    }

    @GetMapping("/auth/pending")
    public String pendingEmailPage(HttpSession httpSession) {
        Long userId = (Long) httpSession.getAttribute("registerProcessUserId");

        if (userId == null) {
            return "redirect:/register";
        }

        return "auth/pending";
    }
}
