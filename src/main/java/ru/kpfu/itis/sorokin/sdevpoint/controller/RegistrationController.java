package ru.kpfu.itis.sorokin.sdevpoint.controller;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import ru.kpfu.itis.sorokin.sdevpoint.dto.UserForm;
import ru.kpfu.itis.sorokin.sdevpoint.service.UserService;

@RestController
@RequiredArgsConstructor
public class RegistrationController {
    private final UserService userService;

    @PostMapping("/registration")
    public ResponseEntity<String> registration(@Valid @RequestBody UserForm userForm, HttpSession httpSession) {
        Long userId = userService.addUser(userForm);
        httpSession.setAttribute("registerProcessUserId", userId);

        //TODO тут будет редирект на auth/pending
        return ResponseEntity.ok("Пользователь успешно зарегистрирован");
    }
}
