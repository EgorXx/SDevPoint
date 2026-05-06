package ru.kpfu.itis.sorokin.sdevpoint.entity;

import jakarta.persistence.*;
import lombok.*;

@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "cases")
public class Case {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "content_item_id")
    private ContentItem contentItem;

    @Column(nullable = false)
    private String description;

    @Column(nullable = false)
    private String solution;

}
