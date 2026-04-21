package ru.kpfu.itis.sorokin.sdevpoint.controller;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class WelcomeController {

    @GetMapping("/welcome")
    @PreAuthorize("hasRole('ROLE_USER')")
    public String welcome() {
        return "Hello, I am Egorik";
    }
}
