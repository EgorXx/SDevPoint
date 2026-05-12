package ru.kpfu.itis.sorokin.sdevpoint.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import ru.kpfu.itis.sorokin.sdevpoint.properties.AvatarProperties;

import java.security.SecureRandom;

@Component
@RequiredArgsConstructor
public class AvatarService {
    private final AvatarProperties avatarProperties;
    private final SecureRandom random = new SecureRandom();

    public String getRandomAvatarKey() {
        int avatarNumber = random.nextInt(avatarProperties.count()) + 1;

        return avatarProperties.filePrefix()
                + avatarNumber
                +avatarProperties.extension();
    }

    public String getAvatarUrl(String avatarKey) {
        return avatarProperties.urlPrefix() + avatarKey;
    }
}
