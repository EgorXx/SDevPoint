package ru.kpfu.itis.sorokin.sdevpoint.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.savedrequest.HttpSessionRequestCache;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity
public class SecurityConfig {
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity httpSecurity) {
        HttpSessionRequestCache requestCache = new HttpSessionRequestCache();
        requestCache.setRequestMatcher(request -> "GET".equals(request.getMethod()));

        return httpSecurity.csrf(csrf -> csrf.disable())
                .requestCache(cache -> cache
                        .requestCache(requestCache)
                )
                .authorizeHttpRequests(a -> a
                        .requestMatchers("/welcome").authenticated()
                        .requestMatchers("/registration").permitAll()
                        .requestMatchers(HttpMethod.GET, "/favorites").authenticated()
                        .requestMatchers(HttpMethod.POST, "/favorites/content/*").authenticated()
                        .anyRequest().permitAll())
                .formLogin(form -> form.permitAll())
                .build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
