package ru.kpfu.itis.sorokin.sdevpoint.runner;

import lombok.RequiredArgsConstructor;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import ru.kpfu.itis.sorokin.sdevpoint.entity.Role;
import ru.kpfu.itis.sorokin.sdevpoint.entity.User;
import ru.kpfu.itis.sorokin.sdevpoint.properties.AdminBootstrapProperties;
import ru.kpfu.itis.sorokin.sdevpoint.repository.UserRepository;
import ru.kpfu.itis.sorokin.sdevpoint.service.AvatarService;

@Component
@RequiredArgsConstructor
public class AdminBootstrapRunner implements ApplicationRunner {
    private final AdminBootstrapProperties properties;
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final AvatarService avatarService;

    @Override
    public void run(ApplicationArguments args) throws Exception {
        if (!properties.enabled()) {
            return;
        }

        if (userRepository.existsByRole(Role.ROLE_ADMIN)) {
            return;
        }

        User admin = new User();
        admin.setUsername(properties.username());
        admin.setEmail(properties.email());
        admin.setPassword(passwordEncoder.encode(properties.password()));
        admin.setRole(Role.ROLE_ADMIN);
        admin.setEmailVerified(true);
        admin.setAvatarKey(avatarService.getAdminAvatarKey());

        userRepository.save(admin);
    }
}
