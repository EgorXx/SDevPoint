package ru.kpfu.itis.sorokin.sdevpoint.web.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public record ExplainTermRequest(
        @NotNull
        @Size(max = 100)
        String term
) {
}
