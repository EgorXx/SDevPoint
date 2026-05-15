package ru.kpfu.itis.sorokin.sdevpoint.web.controller.page;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
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

    @ExceptionHandler(ArticleAlreadyPublished.class)
    public String handleArticleAlreadyPublished(
            ArticleAlreadyPublished ex,
            RedirectAttributes redirectAttributes
    ) {
        redirectAttributes.addFlashAttribute("error", ex.getMessage());

        return "redirect:/articles/" + ex.getContentItemId() + "/edit";
    }

    @ExceptionHandler(CaseAlreadyPublished.class)
    public String handleCaseAlreadyPublished(
            CaseAlreadyPublished ex,
            RedirectAttributes redirectAttributes
    ) {
        redirectAttributes.addFlashAttribute("error", ex.getMessage());

        return "redirect:/cases/" + ex.getContentItemId() + "/edit";
    }

    @ExceptionHandler(NotFoundException.class)
    public ResponseEntity<String> notFound(NotFoundException e) {
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
    }

    @ExceptionHandler(ForbiddenException.class)
    public ResponseEntity<String> forbidden(ForbiddenException e) {
        return ResponseEntity.status(HttpStatus.FORBIDDEN).body(e.getMessage());
    }

    @ExceptionHandler(BadRequestException.class)
    public ResponseEntity<ErrorResponse> handleBadRequest(BadRequestException e) {
        return ResponseEntity
                .badRequest()
                .body(new ErrorResponse(e.getMessage()));
    }

    @ExceptionHandler(DraftContentAccessException.class)
    public String handleDraftContentAccess(DraftContentAccessException e) {
        if (e.getItemType() == ItemType.ARTICLE) {
            return "redirect:/articles/drafts/" + e.getDraftId() + "/edit";
        }

        if (e.getItemType() == ItemType.CASE) {
            return "redirect:/cases/drafts/" + e.getDraftId() + "/edit";
        }

        return "redirect:/";
    }
}
