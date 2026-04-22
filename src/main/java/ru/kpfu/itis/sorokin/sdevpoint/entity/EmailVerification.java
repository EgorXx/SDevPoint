package ru.kpfu.itis.sorokin.sdevpoint.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.time.Instant;
import java.util.UUID;

@Getter
@Setter
@ToString
@NoArgsConstructor
@Entity
@Table(name = "email_verification")
public class EmailVerification {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne
    @JoinColumn(name = "user_id")
    private User user;

    @Column(unique = true, nullable = false)
    private UUID token;

    @Column(name = "expires_at", nullable = false)
    private Instant expiresAt;

    public void refresh(Instant newExpiresAt, UUID newToken) {
        this.token = newToken;
        this.expiresAt = newExpiresAt;
    }

}
