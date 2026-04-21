package ru.kpfu.itis.sorokin.sdevpoint.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ru.kpfu.itis.sorokin.sdevpoint.entity.EmailVerification;
import ru.kpfu.itis.sorokin.sdevpoint.entity.User;

import java.util.Optional;
import java.util.UUID;

public interface EmailVerificationRepository extends JpaRepository<EmailVerification, Long> {
    boolean existsByToken(UUID token);

    Optional<EmailVerification> findByToken(UUID token);

    void deleteById(Long id);

    Optional<EmailVerification> findByUser(User user);
}
