package ru.kpfu.itis.sorokin.sdevpoint.dto;

import java.util.List;

public record ContentImagesView(
        List<ContentImageView> images,
        ImageLimitView limit
) {}
