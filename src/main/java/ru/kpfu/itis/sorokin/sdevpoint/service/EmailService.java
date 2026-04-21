package ru.kpfu.itis.sorokin.sdevpoint.service;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.mail.MailException;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;
import ru.kpfu.itis.sorokin.sdevpoint.entity.EmailVerification;
import ru.kpfu.itis.sorokin.sdevpoint.properties.MailProperties;

import java.io.UnsupportedEncodingException;

@Slf4j
@Service
@RequiredArgsConstructor
public class EmailService {
    private final JavaMailSender javaMailSender;
    private final MailProperties mailProperties;
    private final TemplateEngine templateEngine;

    public void sendVerificationMail(EmailVerification emailVerification) {
        MimeMessage mailMessage = javaMailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(mailMessage);

        try {
            helper.setFrom(mailProperties.from(), mailProperties.sender());
            helper.setTo(emailVerification.getUser().getEmail());
            helper.setSubject(mailProperties.subject());

            Context context = new Context();
            context.setVariable("appName", mailProperties.sender());
            context.setVariable("username", emailVerification.getUser().getUsername());
            context.setVariable("confirmationLink", buildLinkVerification(emailVerification.getToken().toString()));
            context.setVariable("expiresAt", emailVerification.getExpiresAt());

            String html = templateEngine.process("email-confirm", context);

            helper.setText(html, true);
        } catch (MessagingException | UnsupportedEncodingException e) {
            log.error("Error forming the email confirmation message: {}", e.getMessage());
            //TODO доделать обработку (Сообщить пользователю, что что-то пошло не так и не сохранять его наверно :( )
        }

        try {
            javaMailSender.send(mailMessage);
        } catch (MailException e) {
            log.error("Error sending mailMessage: {}", e.getMessage());
            throw e;
            //TODO доделать обработку
        }


    }

    private String buildLinkVerification(String token) {
        StringBuilder link = new StringBuilder();
        link.append(mailProperties.baseUrl());
        link.append("/auth/confirm?token=");
        link.append(token);

        return link.toString();
    }
}
