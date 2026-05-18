package ru.kpfu.itis.sorokin.sdevpoint.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.HttpStatusEntryPoint;
import org.springframework.security.web.savedrequest.HttpSessionRequestCache;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity
public class SecurityConfig {
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity httpSecurity) {
        HttpSessionRequestCache requestCache = new HttpSessionRequestCache();
        requestCache.setRequestMatcher(request -> "GET".equals(request.getMethod()));

        return httpSecurity
                .requestCache(cache -> cache
                        .requestCache(requestCache)
                )
                .exceptionHandling(ex -> ex
                        .defaultAuthenticationEntryPointFor(
                                new HttpStatusEntryPoint(HttpStatus.UNAUTHORIZED),
                                request -> request.getRequestURI().startsWith("/api/")
                        )
                )
                .authorizeHttpRequests(a -> a
                        .requestMatchers(
                                "/error",
                                "/css/**",
                                "/js/**",
                                "/avatars/**"
                        ).permitAll()

                        .requestMatchers(
                                "/auth/login",
                                "/auth/register",
                                "/auth/confirm",
                                "/auth/pending",
                                "/auth/resend"
                        ).permitAll()

                        .requestMatchers(HttpMethod.GET, "/").permitAll()
                        .requestMatchers(HttpMethod.GET, "/articles/public").permitAll()
                        .requestMatchers(HttpMethod.GET, "/cases/public").permitAll()
                        .requestMatchers(HttpMethod.GET, "/articles/*").permitAll()
                        .requestMatchers(HttpMethod.GET, "/cases/*").permitAll()
                        .requestMatchers(HttpMethod.GET, "/cases/*/comments").permitAll()
                        .requestMatchers(HttpMethod.POST, "/cases/*/comments").authenticated()
                        .requestMatchers(HttpMethod.GET, "/users/*").permitAll()
                        .requestMatchers(HttpMethod.GET, "/api/image/*").permitAll()

                        .requestMatchers("/admin/**").hasRole("ADMIN")
                        .requestMatchers("/api/admin/**").hasRole("ADMIN")

                        .requestMatchers("/profile/**").authenticated()
                        .requestMatchers("/my-content").authenticated()
                        .requestMatchers(HttpMethod.GET, "/favorites").authenticated()

                        .requestMatchers(HttpMethod.POST, "/articles/drafts").authenticated()
                        .requestMatchers(HttpMethod.GET, "/articles/drafts/*/edit").authenticated()
                        .requestMatchers(HttpMethod.POST, "/articles/drafts/*").authenticated()
                        .requestMatchers(HttpMethod.POST, "/articles/drafts/*/publish").authenticated()
                        .requestMatchers(HttpMethod.GET, "/articles/*/edit").authenticated()
                        .requestMatchers(HttpMethod.POST, "/articles/*").authenticated()
                        .requestMatchers(HttpMethod.DELETE, "/articles/*").authenticated()

                        .requestMatchers(HttpMethod.POST, "/cases/drafts").authenticated()
                        .requestMatchers(HttpMethod.GET, "/cases/drafts/*/edit").authenticated()
                        .requestMatchers(HttpMethod.POST, "/cases/drafts/*").authenticated()
                        .requestMatchers(HttpMethod.POST, "/cases/drafts/*/publish").authenticated()
                        .requestMatchers(HttpMethod.GET, "/cases/*/edit").authenticated()
                        .requestMatchers(HttpMethod.POST, "/cases/*").authenticated()
                        .requestMatchers(HttpMethod.DELETE, "/cases/*").authenticated()

                        .requestMatchers("/api/**").authenticated()

                        .anyRequest().denyAll()
                )
                .formLogin(form -> form
                        .loginPage("/auth/login")
                        .loginProcessingUrl("/auth/login")
                        .usernameParameter("email")
                        .passwordParameter("password")
                        .failureUrl("/auth/login?error")
                        .defaultSuccessUrl("/", true)
                        .permitAll()
                )
                .logout(logout -> logout
                        .logoutUrl("/auth/logout")
                        .logoutSuccessUrl("/auth/login?logout")
                        .permitAll()
                )
                .csrf(Customizer.withDefaults())
                .build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
