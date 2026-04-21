package ru.kpfu.itis.sorokin.sdevpoint.controller;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import ru.kpfu.itis.sorokin.sdevpoint.dto.EmailVerificationResendStatus;
import ru.kpfu.itis.sorokin.sdevpoint.dto.EmailVerificationStatus;
import ru.kpfu.itis.sorokin.sdevpoint.service.EmailVerificationService;
import ru.kpfu.itis.sorokin.sdevpoint.service.UserService;

import java.net.URI;
import java.util.UUID;

@Slf4j
@RestController
@RequiredArgsConstructor
public class AuthController {
    private final EmailVerificationService emailVerificationService;

    @GetMapping("/auth/confirm")
    public ResponseEntity<String> confirmEmail(@RequestParam UUID token) {
        log.info("Received an email confirmation request: {}", token);

        EmailVerificationStatus emailVerificationStatus = emailVerificationService.verificationEmail(token);

        return switch (emailVerificationStatus) {
            case ALREADY_VERIFIED -> ResponseEntity.ok("Ваш аккаунт уже подтвержден");
            case VERIFIED -> ResponseEntity.ok("Ваш аккаунт успешно подтвержден");
            case INVALID_TOKEN -> ResponseEntity.status(HttpStatus.NOT_FOUND).body("Что-то пошло не так, некорректная ссылка подтверждения");
            case EXPIRED_NEW_TOKEN_SENT -> ResponseEntity.status(HttpStatus.OK).body("Письмо устарело, отправлено новое письмо для подтверждения");
            case null -> ResponseEntity.ok("Что-то пошло не так");
        };
    }

    @PostMapping("/auth/resend")
    public ResponseEntity<String> resendEmailVerification(HttpSession httpSession) {
        Long userId = (Long) httpSession.getAttribute("registerProcessUserId");

        if (userId == null) {
            return ResponseEntity.status(HttpStatus.SEE_OTHER)
                    .location(URI.create("/login"))
                    .build();
        }

        log.info("Received an resend email verification request, userId: {}", userId);

        EmailVerificationResendStatus resendStatus = emailVerificationService.resendEmailVerification(userId);

        return switch (resendStatus) {
            case TOO_MANY_REQUEST -> ResponseEntity.status(HttpStatus.TOO_MANY_REQUESTS).body("Вы отправляете слишком много запросов на отправку подтверждения, ожидайте");
            case RATE_LIMIT_REQUEST -> ResponseEntity.status(HttpStatus.TOO_MANY_REQUESTS).body("Вы превысили лимит отправки сообщений на почту, лимит обновится примерно через час");
            case RESEND -> ResponseEntity.ok("Письмо отправлено вам на почту");
            case ALREADY_VERIFIED -> ResponseEntity.ok("Ваш аккаунт успешно подтвержден");
            case null -> ResponseEntity.ok("Что-то пошло не так");
        };
    }
}
