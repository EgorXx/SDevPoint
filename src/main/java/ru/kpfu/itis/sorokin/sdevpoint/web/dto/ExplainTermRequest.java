package ru.kpfu.itis.sorokin.sdevpoint.web.dto;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.NotNull;

public record ExplainTermRequest(
        @NotNull
        @Max(100)
        String term
) {
}
