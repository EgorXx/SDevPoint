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
import ru.kpfu.itis.sorokin.sdevpoint.dto.ProfileSettingsView;
import ru.kpfu.itis.sorokin.sdevpoint.dto.ProfileView;
import ru.kpfu.itis.sorokin.sdevpoint.dto.UserForm;
import ru.kpfu.itis.sorokin.sdevpoint.entity.EmailVerification;
import ru.kpfu.itis.sorokin.sdevpoint.entity.Role;
import ru.kpfu.itis.sorokin.sdevpoint.entity.User;
import ru.kpfu.itis.sorokin.sdevpoint.exception.CurrentUserNotFoundException;
import ru.kpfu.itis.sorokin.sdevpoint.exception.EntityAlreadyExistsException;
import ru.kpfu.itis.sorokin.sdevpoint.factory.UserFactory;
import ru.kpfu.itis.sorokin.sdevpoint.repository.UserRepository;
import ru.kpfu.itis.sorokin.sdevpoint.web.form.ProfileNameSettingsForm;

import java.util.Arrays;

@Slf4j
@Service
@Validated
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class UserService {
    private final PasswordEncoder passwordEncoder;
    private final UserRepository userRepository;
    private final UserFactory userFactory;
    private final EmailVerificationService emailVerificationService;
    private final AvatarService avatarService;

    @Transactional
    public Long registerUser(@Valid UserForm userForm) {
        verifiedEmail(userForm.email());

        String encodedPassword = passwordEncoder.encode(userForm.password());

        User user = userFactory.createRegistredUser(
                userForm.email(),
                encodedPassword,
                Role.ROLE_USER,
                avatarService.getRandomAvatarKey()
        );

        User savedUser;

        try {
            savedUser = userRepository.save(user);
        } catch (DataIntegrityViolationException e) {
            Throwable cause = e.getCause();

            if (cause instanceof ConstraintViolationException) {
                //TODO: Добавить сюда конкретику, какого именно
                log.warn("Violation of the constant");
                throw new EntityAlreadyExistsException("User with email already exists: " + userForm.email());
            } else {
                log.error("UserRepository exception: {}, {}", e, cause.getMessage());
                throw e;
            }
        }

        log.info("User saved: {}", savedUser);

        EmailVerification emailVerification = emailVerificationService.saveVerificationForUser(user);
        log.info("EmailVerification saved: {}", emailVerification);

        emailVerificationService.sendEmailVerification(emailVerification);

        return savedUser.getId();
    }

    @Transactional(readOnly = true)
    public ProfileView getProfileView(Long userId, Long currentUserId) {
        return userRepository.findById(userId)
                .map(u -> new ProfileView(
                        userId,
                        avatarService.getAvatarUrl(u.getAvatarKey()),
                        u.getUsername(),
                        userId.equals(currentUserId)))
                .orElseThrow(CurrentUserNotFoundException::new);
    }

    @Transactional(readOnly = true)
    public ProfileSettingsView getProfileSettingsView(Long userId) {
        return userRepository.findById(userId)
                .map(u -> new ProfileSettingsView(u.getUsername()))
                .orElseThrow(CurrentUserNotFoundException::new);
    }

    private void verifiedEmail(String email) {
        if (userRepository.existsByEmail(email)) {
            log.warn("User with email: {} already exists", email);
            throw new EntityAlreadyExistsException("User with email already exists: " + email);
        }
    }

    @Transactional
    public void updateName(Long userId, ProfileNameSettingsForm nameForm) {
        User user = userRepository.findById(userId)
                .orElseThrow(CurrentUserNotFoundException::new);

        user.setUsername(nameForm.username());
    }
}
