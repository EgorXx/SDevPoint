package ru.kpfu.itis.sorokin.sdevpoint.seed;

import lombok.RequiredArgsConstructor;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import ru.kpfu.itis.sorokin.sdevpoint.entity.Role;
import ru.kpfu.itis.sorokin.sdevpoint.entity.User;
import ru.kpfu.itis.sorokin.sdevpoint.repository.UserRepository;
import ru.kpfu.itis.sorokin.sdevpoint.service.AvatarService;

@Component
@RequiredArgsConstructor
public class DevUserSeeder {

    private static final String TEST_EMAIL = "test@example.com";
    private static final String TEST_PASSWORD = "test123";

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final AvatarService avatarService;

    @Transactional
    @EventListener(ApplicationReadyEvent.class)
    public void seed() {
        User user = userRepository.findByEmail(TEST_EMAIL)
                .orElseGet(() -> {
                    User newUser = new User();
                    newUser.setEmail(TEST_EMAIL);
                    newUser.setAvatarKey(avatarService.getRandomAvatarKey());
                    return newUser;
                });

        user.setPassword(passwordEncoder.encode(TEST_PASSWORD));
        user.setUsername("123");
        user.setRole(Role.ROLE_USER);
        user.setEmailVerified(true);

        userRepository.save(user);
    }
}
