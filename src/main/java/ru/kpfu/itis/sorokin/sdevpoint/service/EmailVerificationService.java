package ru.kpfu.itis.sorokin.sdevpoint.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ru.kpfu.itis.sorokin.sdevpoint.dto.EmailConfirmView;
import ru.kpfu.itis.sorokin.sdevpoint.dto.EmailVerificationResendResponse;
import ru.kpfu.itis.sorokin.sdevpoint.dto.EmailVerificationResendStatus;
import ru.kpfu.itis.sorokin.sdevpoint.entity.EmailVerification;
import ru.kpfu.itis.sorokin.sdevpoint.entity.User;
import ru.kpfu.itis.sorokin.sdevpoint.event.SendEmailVerificationEvent;
import ru.kpfu.itis.sorokin.sdevpoint.exception.NotFoundException;
import ru.kpfu.itis.sorokin.sdevpoint.properties.EmailVerificationProperties;
import ru.kpfu.itis.sorokin.sdevpoint.redis.CooldownStore;
import ru.kpfu.itis.sorokin.sdevpoint.redis.WindowRateLimitStore;
import ru.kpfu.itis.sorokin.sdevpoint.repository.EmailVerificationRepository;
import ru.kpfu.itis.sorokin.sdevpoint.repository.UserRepository;

import java.time.Duration;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
public class EmailVerificationService {
    private final EmailVerificationRepository emailVerificationRepository;
    private final UserRepository userRepository;
    private final CooldownStore cooldownStore;
    private final WindowRateLimitStore rateLimitStore;
    private final DateTimeFormatService dateTimeFormatService;
    private final ApplicationEventPublisher eventPublisher;
    private final EmailVerificationProperties properties;

    @Transactional
    public EmailVerification saveVerificationForUser(User user) {
        EmailVerification emailVerification = new EmailVerification();

        UUID token = UUID.randomUUID();
        Instant expiresAt = Instant.now().plus(properties.tokenLifetime());

        emailVerification.setUser(user);
        emailVerification.setToken(token);
        emailVerification.setExpiresAt(expiresAt);
        emailVerificationRepository.save(emailVerification);
        log.info("EmailVerification saved: {}", emailVerification);

        return emailVerification;
    }

    @Transactional
    public EmailConfirmView verificationEmail(UUID token) {
        EmailVerification emailVerification = emailVerificationRepository.findByToken(token)
                .orElse(null);

        if (emailVerification == null) {
            return new EmailConfirmView(
                    "Некорректная ссылка",
                    "Ссылка подтверждения недействительна. Попробуйте зарегистрироваться заново или запросить новое письмо.",
                    "error",
                    false
            );
        }

        if (Boolean.TRUE.equals(emailVerification.getUser().getEmailVerified())) {
            return new EmailConfirmView(
                    "Аккаунт уже подтверждён",
                    "Ваш аккаунт уже был подтверждён ранее. Теперь можно перейти ко входу.",
                    "success",
                    true
            );
        }

        if (emailVerificationIsExpired(emailVerification)) {
            log.info("token's lifetime has expired");

            emailVerification.refresh(
                    Instant.now().plus(properties.tokenLifetime()),
                    UUID.randomUUID()
            );

            eventPublisher.publishEvent(new SendEmailVerificationEvent(
                    emailVerification.getId()
            ));

            return new EmailConfirmView(
                    "Ссылка устарела",
                    "Срок действия ссылки истёк. Мы отправили новое письмо для подтверждения.",
                    "warning",
                    false
            );
        }

        log.info("Email Confirmation for token: {}", token);

        Long userId = emailVerification.getUser().getId();

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new NotFoundException("User not found, id: " + userId));

        user.setEmailVerified(true);

        return new EmailConfirmView(
                "Почта подтверждена",
                "Ваш аккаунт успешно подтверждён. Теперь можно войти в систему.",
                "success",
                true
        );
    }

    private boolean emailVerificationIsExpired(EmailVerification emailVerification) {
        return emailVerification.getExpiresAt().isBefore(Instant.now());
    }

    @Transactional
    public EmailVerificationResendResponse resendEmailVerification(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new NotFoundException("User not found, id: " + userId));

        if (Boolean.TRUE.equals(user.getEmailVerified())) {
            return new EmailVerificationResendResponse(
                    EmailVerificationResendStatus.ALREADY_VERIFIED,
                    "Ваш аккаунт успешно подтвержден"
            );
        }

        // Проверка cooldown
        String subject = "user:" + userId;

        if (!cooldownStore.tryAcquire(subject, properties.resendCooldown())) {
            long ttl = cooldownStore.getRemainingSeconds(subject);
            String waitTime = dateTimeFormatService.formatRemainingTime(ttl);

            return new EmailVerificationResendResponse(
                    EmailVerificationResendStatus.TOO_MANY_REQUEST,
                    "Вы отправляете слишком много запросов на отправку подтверждения. Лимит обновится через " + waitTime
            );
        }

        // Проверка лимита за окно
        String window = LocalDateTime.now()
                .truncatedTo(ChronoUnit.HOURS)
                .toString();

        long count = rateLimitStore.incrementRate(subject, window, properties.rateLimitWindow());

        if (count > properties.rateLimitCount()) {
            long ttl = rateLimitStore.getRemainingSeconds(subject, window);
            String waitTime = dateTimeFormatService.formatRemainingTime(ttl);

            return new EmailVerificationResendResponse(
                    EmailVerificationResendStatus.RATE_LIMIT_REQUEST,
                    "Вы отправили слишком много запросов на отправку подтверждения. Лимит обновится через " + waitTime
            );
        }


        EmailVerification emailVerification = user.getEmailVerification();

        emailVerification.refresh(
                Instant.now().plus(properties.tokenLifetime()),
                UUID.randomUUID()
        );

        eventPublisher.publishEvent(new SendEmailVerificationEvent(
                emailVerification.getId()
        ));

        return new EmailVerificationResendResponse(
                EmailVerificationResendStatus.RESEND,
                "Письмо отправлено вам на почту"
        );
    }
}
