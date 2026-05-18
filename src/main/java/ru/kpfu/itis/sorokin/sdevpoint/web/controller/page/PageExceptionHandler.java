package ru.kpfu.itis.sorokin.sdevpoint.web.controller.page;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import ru.kpfu.itis.sorokin.sdevpoint.entity.ItemType;
import ru.kpfu.itis.sorokin.sdevpoint.exception.*;
import ru.kpfu.itis.sorokin.sdevpoint.web.dto.ErrorResponse;

@Slf4j
@ControllerAdvice(basePackages = "ru.kpfu.itis.sorokin.sdevpoint.web.controller.page")
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

    @ExceptionHandler(NotFoundException.class)
    public String notFound(
            NotFoundException e,
            HttpServletResponse response,
            Model model
    ) {
        response.setStatus(HttpStatus.NOT_FOUND.value());

        model.addAttribute("status", 404);
        model.addAttribute("title", "Страница не найдена");
        model.addAttribute("message", e.getMessage());

        return "error/404";
    }

    @ExceptionHandler(ForbiddenException.class)
    public String forbidden(
            ForbiddenException e,
            HttpServletResponse response,
            Model model
    ) {
        response.setStatus(HttpStatus.FORBIDDEN.value());

        model.addAttribute("status", 403);
        model.addAttribute("title", "Доступ запрещён");
        model.addAttribute("message", e.getMessage());

        return "error/403";
    }

    @ExceptionHandler(BadRequestException.class)
    public String badRequest(
            BadRequestException e,
            HttpServletResponse response,
            Model model
    ) {
        response.setStatus(HttpStatus.BAD_REQUEST.value());

        model.addAttribute("status", 400);
        model.addAttribute("title", "Некорректный запрос");
        model.addAttribute("message", e.getMessage());

        return "error/400";
    }

    @ExceptionHandler(Exception.class)
    public String internalServerError(
            Exception e,
            HttpServletResponse response,
            Model model
    ) {
        log.error("Unhandled page controller exception", e);

        response.setStatus(HttpStatus.INTERNAL_SERVER_ERROR.value());

        model.addAttribute("status", 500);
        model.addAttribute("title", "Внутренняя ошибка сервера");
        model.addAttribute("message", "Что-то пошло не так. Попробуйте позже.");

        return "error/500";
    }
}
