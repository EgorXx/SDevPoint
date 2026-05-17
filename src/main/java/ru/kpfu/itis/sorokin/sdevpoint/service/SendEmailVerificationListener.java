package ru.kpfu.itis.sorokin.sdevpoint.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;
import org.springframework.transaction.event.TransactionPhase;
import org.springframework.transaction.event.TransactionalEventListener;
import ru.kpfu.itis.sorokin.sdevpoint.dto.EmailVerificationMailData;
import ru.kpfu.itis.sorokin.sdevpoint.entity.EmailVerification;
import ru.kpfu.itis.sorokin.sdevpoint.event.SendEmailVerificationEvent;
import ru.kpfu.itis.sorokin.sdevpoint.exception.NotFoundException;
import ru.kpfu.itis.sorokin.sdevpoint.repository.EmailVerificationRepository;

@Slf4j
@Component
@RequiredArgsConstructor
public class SendEmailVerificationListener {
    private final EmailService emailService;
    private final EmailVerificationRepository emailVerificationRepository;

    @Async("emailTaskExecutor")
    @TransactionalEventListener(phase = TransactionPhase.AFTER_COMMIT)
    public void sendEmailVerification(SendEmailVerificationEvent event) {
        log.info("Received email verification event");

        try {
            EmailVerification emailVerification = emailVerificationRepository
                    .findWithUserById(event.emailVerificationId())
                    .orElseThrow(() -> new NotFoundException("EmailVerification not found, id=" + event.emailVerificationId()));

            EmailVerificationMailData mailData = new EmailVerificationMailData(
                    emailVerification.getUser().getEmail(),
                    emailVerification.getToken().toString(),
                    emailVerification.getUser().getUsername(),
                    emailVerification.getExpiresAt()
            );

            emailService.sendVerificationMail(mailData);
        } catch (Exception e) {
            log.error("Failed to send verification email, event={}", event, e);
        }
    }
}
