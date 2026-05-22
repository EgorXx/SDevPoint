package ru.kpfu.itis.sorokin.sdevpoint.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import ru.kpfu.itis.sorokin.sdevpoint.entity.Role;
import ru.kpfu.itis.sorokin.sdevpoint.entity.User;

import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {
    User save(User user);

    Optional<User> findByEmail(String email);

    boolean existsByEmail(String email);

    boolean existsByIdAndRole(Long id, Role role);

    boolean existsByRole(Role role);
}
