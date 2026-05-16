package ru.kpfu.itis.sorokin.sdevpoint.dto;

import ru.kpfu.itis.sorokin.sdevpoint.entity.ReactionType;

public record ReactionResponse(
        long likesCount,
        long dislikesCount,
        boolean isReaction,
        ReactionType currentReaction
) {}
