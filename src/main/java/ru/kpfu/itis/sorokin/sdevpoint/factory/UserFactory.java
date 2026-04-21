package ru.kpfu.itis.sorokin.sdevpoint.factory;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import ru.kpfu.itis.sorokin.sdevpoint.entity.Role;
import ru.kpfu.itis.sorokin.sdevpoint.entity.User;

@Slf4j
@Component
public class UserFactory {
    public User createRegistredUser(String email, String password, Role role) {
        String username = extractUsername(email);

        User user = new User();
        user.setUsername(username);
        user.setEmail(email);
        user.setRole(role);
        user.setPassword(password);
        user.setEmailVerified(false);

        return user;
    }

    private String extractUsername(String email) {
        String username = email.split("@")[0].trim();

        if (username.isBlank())  {
            log.error("Wrong format username: {}, email: {}", username, email);
            throw new IllegalArgumentException("Wrong format username: " + username);
        }

        return username;
    }
}
