package ru.kpfu.itis.sorokin.sdevpoint.web.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import ru.kpfu.itis.sorokin.sdevpoint.exception.ArticleAlreadyPublished;
import ru.kpfu.itis.sorokin.sdevpoint.exception.BadRequestException;
import ru.kpfu.itis.sorokin.sdevpoint.exception.CurrentUserNotFoundException;
import ru.kpfu.itis.sorokin.sdevpoint.exception.NotFoundException;
import ru.kpfu.itis.sorokin.sdevpoint.web.dto.ErrorResponse;

@ControllerAdvice
public class PageExceptionHandler {

    @ExceptionHandler(CurrentUserNotFoundException.class)
    public String handleCurrentUserNotFound(
            CurrentUserNotFoundException ex,
            HttpServletRequest request,
            HttpServletResponse response
    ) {
        new SecurityContextLogoutHandler().logout(request, response, null);

        return "redirect:/auth/login?sessionExpired";
    }

    @ExceptionHandler(ArticleAlreadyPublished.class)
    public String handleArticleAlreadyPublished(
            ArticleAlreadyPublished ex,
            Model model
    ) {
        model.addAttribute("error", ex.getMessage());

        return "article/edit";
    }

    @ExceptionHandler(NotFoundException.class)
    public ResponseEntity<String> notFound(NotFoundException e) {
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
    }

    @ExceptionHandler(BadRequestException.class)
    public ResponseEntity<ErrorResponse> handleBadRequest(BadRequestException e) {
        return ResponseEntity
                .badRequest()
                .body(new ErrorResponse(e.getMessage()));
    }
}
