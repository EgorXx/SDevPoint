package ru.kpfu.itis.sorokin.sdevpoint.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.Instant;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "case_comment")
public class CaseComment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "case_id")
    private Case caseEntity;

    @Column(nullable = false)
    private String text;

    @Column(name = "created_at",nullable = false)
    private Instant createdAt;

    public static CaseComment createNew(User user, Case caseEntity, String text) {
        return new CaseComment(
                null,
                user,
                caseEntity,
                text,
                Instant.now()
        );
    }
}
