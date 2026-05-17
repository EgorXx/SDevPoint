package ru.kpfu.itis.sorokin.sdevpoint.web.routes;

import java.util.UUID;

public final class ImageRoutes {

    public static final String IMAGE_PREFIX = "/api/image/";

    private ImageRoutes() {
    }

    public static String imageUrl(UUID publicId) {
        return IMAGE_PREFIX + publicId;
    }
}
