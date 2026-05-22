package ru.kpfu.itis.sorokin.sdevpoint.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.Hibernate;

@Entity
@Table(
        name = "reaction",
        uniqueConstraints = {
                @UniqueConstraint(
                        name = "reaction_unique_user_content",
                        columnNames = {"user_id", "content_item_id"}
                )
        }
)
@Getter
@Setter
@NoArgsConstructor
public class Reaction {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "content_item_id", nullable = false)
    private ContentItem contentItem;

    @Enumerated(EnumType.STRING)
    @Column(name = "reaction_type", nullable = false, length = 32)
    private ReactionType reactionType;

    public Reaction(User user, ContentItem contentItem, ReactionType reactionType) {
        this.user = user;
        this.contentItem = contentItem;
        this.reactionType = reactionType;
    }

    @Override
    public final boolean equals(Object o) {
        if (this == o) {
            return true;
        }

        if (o == null) {
            return false;
        }

        if (Hibernate.getClass(this) != Hibernate.getClass(o)) {
            return false;
        }

        Reaction reaction = (Reaction) o;

        return id != null && id.equals(reaction.id);
    }

    @Override
    public final int hashCode() {
        return Hibernate.getClass(this).hashCode();
    }
}
