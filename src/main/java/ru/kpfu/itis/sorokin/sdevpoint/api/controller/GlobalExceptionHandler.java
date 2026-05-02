package ru.kpfu.itis.sorokin.sdevpoint.api.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import ru.kpfu.itis.sorokin.sdevpoint.api.generated.dto.ErrorResponse;
import ru.kpfu.itis.sorokin.sdevpoint.exception.ForbiddenException;
import ru.kpfu.itis.sorokin.sdevpoint.exception.NotFoundException;

import java.nio.file.AccessDeniedException;

@RestControllerAdvice(basePackages = "ru.kpfu.itis.sdevpoint.api")
public class GlobalExceptionHandler {
    @ExceptionHandler(AccessDeniedException.class)
    public ResponseEntity<String> accessDenied(AccessDeniedException e) {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(e.getMessage());
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ErrorResponse> handleValidation(MethodArgumentNotValidException e) {
        String message = e.getBindingResult()
                .getFieldErrors()
                .stream()
                .map(error -> error.getField() + ": " + error.getDefaultMessage())
                .findFirst()
                .orElse("Некорректные данные запроса");

        ErrorResponse response = new ErrorResponse()
                .message(message);

        return ResponseEntity
                .status(HttpStatus.BAD_REQUEST)
                .body(response);
    }

    @ExceptionHandler(NotFoundException.class)
    public ResponseEntity<String> notFound(NotFoundException e) {
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
    }

    @ExceptionHandler(ForbiddenException.class)
    public ResponseEntity<String> forbidden(ForbiddenException e) {
        return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Доступ к ресурсу запрещен");
    }
}
