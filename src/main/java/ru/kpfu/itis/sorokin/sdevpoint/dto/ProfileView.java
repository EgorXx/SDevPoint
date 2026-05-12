package ru.kpfu.itis.sorokin.sdevpoint.dto;

public record ProfileView(
        Long userId,
        String avatarUrl,
        String username,
        boolean isOwner
) {
}
