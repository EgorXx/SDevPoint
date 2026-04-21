package ru.kpfu.itis.sorokin.sdevpoint.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ru.kpfu.itis.sorokin.sdevpoint.dto.EmailVerificationResendStatus;
import ru.kpfu.itis.sorokin.sdevpoint.dto.EmailVerificationStatus;
import ru.kpfu.itis.sorokin.sdevpoint.entity.EmailVerification;
import ru.kpfu.itis.sorokin.sdevpoint.entity.User;
import ru.kpfu.itis.sorokin.sdevpoint.exception.UserNotFound;
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
    private final EmailService emailService;
    private final EmailVerificationRepository emailVerificationRepository;
    private final UserRepository userRepository;
    private final CooldownStore cooldownStore;
    private final WindowRateLimitStore rateLimitStore;

    private static final Duration TOKEN_LIFETIME = Duration.ofMinutes(15);
    private static final Duration COOLDOWN_TIME = Duration.ofMinutes(1);
    private static final Duration RATE_LIMIT_TIME = Duration.ofHours(1);
    private static final int RATE_LIMIT_COUNT = 3;

    @Transactional
    public EmailVerification saveVerificationForUser(User user) {
        EmailVerification emailVerification = new EmailVerification();

        UUID token = UUID.randomUUID();
        Instant expiresAt = Instant.now().plus(TOKEN_LIFETIME);

        emailVerification.setUser(user);
        emailVerification.setToken(token);
        emailVerification.setExpiresAt(expiresAt);
        emailVerificationRepository.save(emailVerification);
        log.info("EmailVerification saved: {}", emailVerification);

        return emailVerification;
    }

    public void sendEmailVerification(EmailVerification emailVerification) {
        emailService.sendVerificationMail(emailVerification);
    }

    @Transactional
    public EmailVerificationStatus verificationEmail(UUID token) {
        EmailVerification emailVerification = emailVerificationRepository.findByToken(token)
                .orElse(null);

        if (emailVerification == null) {
            return EmailVerificationStatus.INVALID_TOKEN;
        }

        if (Boolean.TRUE.equals(emailVerification.getUser().getEmailVerified())) {
            return EmailVerificationStatus.ALREADY_VERIFIED;
        }

        if (emailVerificationIsExpired(emailVerification)) {
            log.info("token's lifetime has expired");

            emailVerification.refresh(
                    Instant.now().plus(Duration.ofSeconds(15)),
                    UUID.randomUUID()
            );

            emailService.sendVerificationMail(emailVerification);

            return EmailVerificationStatus.EXPIRED_NEW_TOKEN_SENT;
        }

        log.info("Email Confirmation for token: {}", token);

        Long userId = emailVerification.getUser().getId();

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new UserNotFound("User not found, id: " + userId));

        user.setEmailVerified(true);

        return EmailVerificationStatus.VERIFIED;
    }

    private boolean emailVerificationIsExpired(EmailVerification emailVerification) {
        return emailVerification.getExpiresAt().isBefore(Instant.now());
    }

    @Transactional
    public EmailVerificationResendStatus resendEmailVerification(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new UserNotFound("User not found, id: " + userId));

        if (Boolean.TRUE.equals(user.getEmailVerified())) {
            return EmailVerificationResendStatus.ALREADY_VERIFIED;
        }

        String subject = "user:" + userId;

        String window = LocalDateTime.now().truncatedTo(ChronoUnit.HOURS).toString();

        long count = rateLimitStore.incrementRate(subject, window, RATE_LIMIT_TIME);

        if (count > RATE_LIMIT_COUNT) {
            return EmailVerificationResendStatus.RATE_LIMIT_REQUEST;
        }

        if (!cooldownStore.tryAcquire(subject, COOLDOWN_TIME)) {
            return EmailVerificationResendStatus.TOO_MANY_REQUEST;
        }

        EmailVerification emailVerification = user.getEmailVerification();

        emailVerification.refresh(
                Instant.now().plus(Duration.ofSeconds(15)),
                UUID.randomUUID()
        );

        emailService.sendVerificationMail(emailVerification);

        return EmailVerificationResendStatus.RESEND;
    }
}
