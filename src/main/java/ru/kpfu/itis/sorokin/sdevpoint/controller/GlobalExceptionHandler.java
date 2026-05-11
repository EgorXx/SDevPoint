package ru.kpfu.itis.sorokin.sdevpoint.controller;

import jakarta.validation.ConstraintViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import ru.kpfu.itis.sorokin.sdevpoint.dto.ValidationErrorResponse;
import ru.kpfu.itis.sorokin.sdevpoint.dto.Violation;
import ru.kpfu.itis.sorokin.sdevpoint.exception.*;

import java.util.List;

//@ControllerAdvice
//public class GlobalExceptionHandler {

//    @ExceptionHandler(Exception.class)
//    public ResponseEntity<String> exception(Exception e) {
//        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e + e.getMessage() + e.getStackTrace());
//    }
//
//    @ExceptionHandler(BadRequestException.class)
//    public ResponseEntity<String> badRequest(BadRequestException e) {
//        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
//    }
//
//    @ExceptionHandler(ImageStorageException.class)
//    public ResponseEntity<String> imageStorage(ImageStorageException e) {
//        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Произошла непредвиденная ошибка");
//    }
//
//    @ExceptionHandler(EntityAlreadyExistsException.class)
//    public ResponseEntity<String> entityAlreadyExists(EntityAlreadyExistsException e) {
//        return ResponseEntity.status(HttpStatus.CONFLICT).body(e.getMessage());
//    }
//
////    @ExceptionHandler(NotFoundException.class)
////    public ResponseEntity<String> notFound(NotFoundException e) {
////        return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Ресурс не найден");
////    }
//
//    @ExceptionHandler(ForbiddenException.class)
//    public ResponseEntity<String> forbidden(ForbiddenException e) {
//        return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Доступ к ресурсу запрещен");
//    }
//
//    @ExceptionHandler(IllegalArgumentException.class)
//    public ResponseEntity<String> forbidden(IllegalArgumentException e) {
//        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Некорректные входные данные");
//    }
//
//    @ExceptionHandler(MethodArgumentNotValidException.class)
//    @ResponseStatus(HttpStatus.BAD_REQUEST)
//    @ResponseBody
//    public ValidationErrorResponse onMethodArgumentNotValidException(MethodArgumentNotValidException e) {
//        List<Violation> violations = e.getBindingResult().getFieldErrors().stream()
//                .map(
//                        error -> new Violation(
//                                error.getField(),
//                                error.getDefaultMessage()
//                        )
//                )
//                .toList();
//
//        return new ValidationErrorResponse(violations);
//    }
//
//    @ExceptionHandler(ConstraintViolationException.class)
//    @ResponseStatus(HttpStatus.BAD_REQUEST)
//    @ResponseBody
//    public ValidationErrorResponse onConstraintViolationException(ConstraintViolationException e) {
//        final List<Violation> violations = e.getConstraintViolations().stream()
//                .map(
//                        violation -> new Violation(
//                                violation.getPropertyPath().toString(),
//                                violation.getMessage()
//                        )
//                ).toList();
//        return new ValidationErrorResponse(violations);
//    }
//}
