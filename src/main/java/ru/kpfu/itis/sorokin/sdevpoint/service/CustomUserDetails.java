package ru.kpfu.itis.sorokin.sdevpoint.service;

import lombok.AllArgsConstructor;
import org.jspecify.annotations.Nullable;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import ru.kpfu.itis.sorokin.sdevpoint.entity.User;

import java.util.Collection;
import java.util.List;

@AllArgsConstructor
public class CustomUserDetails implements UserDetails {
    private User user;

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return List.of(user.getRole().name()).stream()
                .map(SimpleGrantedAuthority::new)
                .toList();
    }

    @Override
    public @Nullable String getPassword() {
        return user.getPassword();
    }

    public Long getUserId() {return user.getId();}

    @Override
    public String getUsername() {
        return user.getEmail();
    }

    @Override
    public boolean isAccountNonExpired() {
        return UserDetails.super.isAccountNonExpired();
    }

    @Override
    public boolean isAccountNonLocked() {
        return UserDetails.super.isAccountNonLocked();
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return UserDetails.super.isCredentialsNonExpired();
    }

    @Override
    public boolean isEnabled() {
        return user.getEmailVerified();
    }
}
