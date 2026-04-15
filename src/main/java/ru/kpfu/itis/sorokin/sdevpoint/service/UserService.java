package ru.kpfu.itis.sorokin.sdevpoint.service;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.hibernate.exception.ConstraintViolationException;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.validation.annotation.Validated;
import ru.kpfu.itis.sorokin.sdevpoint.dto.UserForm;
import ru.kpfu.itis.sorokin.sdevpoint.entity.Role;
import ru.kpfu.itis.sorokin.sdevpoint.entity.User;
import ru.kpfu.itis.sorokin.sdevpoint.exception.UserAlreadyExists;
import ru.kpfu.itis.sorokin.sdevpoint.repository.UserRepository;

@Slf4j
@Service
@Validated
@RequiredArgsConstructor
public class UserService {
    private final PasswordEncoder passwordEncoder;
    private final UserRepository userRepository;

    public void addUser(@Valid UserForm userForm) {
        String email = userForm.email();
        String password = userForm.password();

        if (userRepository.existsByEmail(email)) {
            log.warn("Пользователь с таким email: {} уже существует", email);
            throw new UserAlreadyExists("Пользователь с таким email уже существует: " + email);
        }

        String encodedPassword = passwordEncoder.encode(password);
        String username = extractUsername(email);
        Role role = Role.ROLE_USER;

        User user = new User(null, username, email, encodedPassword, role);

        User savedUser;

        try {
            savedUser = userRepository.save(user);
        } catch (DataIntegrityViolationException e) {
            Throwable cause = e.getCause();

            if (cause instanceof ConstraintViolationException) {
                //TODO: Добавить сюда конкретику, какого именно
                log.warn("Нарушение constraint на проверку уникальности email");
                throw new UserAlreadyExists("Пользователь с таким email уже существует: " + email);
            } else {
                log.error("Another exception: {}, {}", e, cause.getMessage());
                throw e;
            }
        }

        log.info("User сохранен: {}", savedUser);
    }

    private String extractUsername(String email) {
        String username = email.split("@")[0].trim();

        if (username.isBlank())  {
            log.error("Недопустимый формат username при парсинге email: {}, email: {}", username, email);
            throw new RuntimeException("Неверный формат username: " + username);
        }

        return username;
    }
}
