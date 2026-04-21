package ru.kpfu.itis.sorokin.sdevpoint.factory;

import org.springframework.stereotype.Component;
import ru.kpfu.itis.sorokin.sdevpoint.entity.EmailVerification;
import ru.kpfu.itis.sorokin.sdevpoint.entity.User;

import java.time.Duration;
import java.time.Instant;
import java.util.UUID;

@Component
public class EmailVerificationFactory {
    private static final Duration TOKEN_LIFETIME = Duration.ofSeconds(15);

    public EmailVerification createNewVerificationForUser(User user) {
        EmailVerification emailVerification = new EmailVerification();

        UUID token = UUID.randomUUID();
        Instant expiresAt = Instant.now().plus(TOKEN_LIFETIME);

        emailVerification.setUser(user);
        emailVerification.setToken(token);
        emailVerification.setExpiresAt(expiresAt);

        return emailVerification;
    }
}
