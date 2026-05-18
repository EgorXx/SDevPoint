package ru.kpfu.itis.sorokin.sdevpoint.config;

import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import ru.kpfu.itis.sorokin.sdevpoint.interceptor.AuthPageRedirectInterceptor;

@Configuration
@RequiredArgsConstructor
public class WebMvcConfig implements WebMvcConfigurer {
    private final AuthPageRedirectInterceptor authPageRedirectInterceptor;

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(authPageRedirectInterceptor)
                .addPathPatterns("/auth/**");
    }
}
