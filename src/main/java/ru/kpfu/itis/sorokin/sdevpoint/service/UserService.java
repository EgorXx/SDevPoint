package ru.kpfu.itis.sorokin.sdevpoint.service;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.hibernate.exception.ConstraintViolationException;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;
import ru.kpfu.itis.sorokin.sdevpoint.dto.EmailVerificationResendStatus;
import ru.kpfu.itis.sorokin.sdevpoint.dto.EmailVerificationStatus;
import ru.kpfu.itis.sorokin.sdevpoint.dto.UserForm;
import ru.kpfu.itis.sorokin.sdevpoint.entity.EmailVerification;
import ru.kpfu.itis.sorokin.sdevpoint.entity.Role;
import ru.kpfu.itis.sorokin.sdevpoint.entity.User;
import ru.kpfu.itis.sorokin.sdevpoint.exception.UserAlreadyExists;
import ru.kpfu.itis.sorokin.sdevpoint.exception.UserNotFound;
import ru.kpfu.itis.sorokin.sdevpoint.factory.EmailVerificationFactory;
import ru.kpfu.itis.sorokin.sdevpoint.factory.UserFactory;
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
@Validated
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class UserService {
    private final PasswordEncoder passwordEncoder;
    private final UserRepository userRepository;
    private final EmailVerificationRepository emailVerificationRepository;
    private final EmailService emailService;
    private final UserFactory userFactory;
    private final EmailVerificationFactory emailVerificationFactory;
    private final CooldownStore cooldownStore;
    private final WindowRateLimitStore rateLimitStore;

    private final Duration COOLDOWN_TIME = Duration.ofMinutes(1);
    private final Duration RATE_LIMIT_TIME = Duration.ofHours(1);
    private final int RATE_LIMIT_COUNT = 2;

    @Transactional
    public Long addUser(@Valid UserForm userForm) {
        verifiedEmail(userForm.email());

        String encodedPassword = passwordEncoder.encode(userForm.password());

        User user = userFactory.createRegistredUser(
                userForm.email(),
                encodedPassword,
                Role.ROLE_USER
        );

        User savedUser;

        try {
            savedUser = userRepository.save(user);
        } catch (DataIntegrityViolationException e) {
            Throwable cause = e.getCause();

            if (cause instanceof ConstraintViolationException) {
                //TODO: Добавить сюда конкретику, какого именно
                log.warn("Violation of the constant");
                throw new UserAlreadyExists("User with email already exists: " + userForm.email());
            } else {
                log.error("UserRepository exception: {}, {}", e, cause.getMessage());
                throw e;
            }
        }

        log.info("User saved: {}", savedUser);

        EmailVerification emailVerification = emailVerificationFactory.createNewVerificationForUser(user);
        emailVerificationRepository.save(emailVerification);
        log.info("EmailVerification saved: {}", emailVerification);

        emailService.sendVerificationMail(emailVerification);

        return savedUser.getId();
    }

    private void verifiedEmail(String email) {
        if (userRepository.existsByEmail(email)) {
            log.warn("User with email: {} already exists", email);
            throw new UserAlreadyExists("User with email already exists: " + email);
        }
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
