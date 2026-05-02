package ru.kpfu.itis.sorokin.sdevpoint.service;

import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

@Component
public class CurrentUserProvider {
    public Long getCurrentUserId() {
        Authentication authentication = SecurityContextHolder
                .getContext()
                .getAuthentication();

        if (authentication == null || !authentication.isAuthenticated()) {
            throw new AccessDeniedException("Пользователь не авторизован");
        }

        Object principal = authentication.getPrincipal();

        if (principal instanceof CustomUserDetails userDetails) {
            return userDetails.getUserId();
        }

        throw new AccessDeniedException("Не удалось определить текущего пользователя");
    }
}
