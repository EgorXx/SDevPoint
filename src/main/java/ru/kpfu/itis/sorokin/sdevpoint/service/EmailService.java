package ru.kpfu.itis.sorokin.sdevpoint.service;

import freemarker.core.ParseException;
import freemarker.template.*;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.mail.MailException;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.springframework.web.util.UriComponentsBuilder;
import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;
import ru.kpfu.itis.sorokin.sdevpoint.dto.EmailVerificationMailData;
import ru.kpfu.itis.sorokin.sdevpoint.entity.EmailVerification;
import ru.kpfu.itis.sorokin.sdevpoint.exception.EmailSendingException;
import ru.kpfu.itis.sorokin.sdevpoint.properties.MailProperties;

import java.io.IOException;
import java.io.StringWriter;
import java.io.UnsupportedEncodingException;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class EmailService {
    private final JavaMailSender javaMailSender;
    private final MailProperties mailProperties;
    private final Configuration freemarkerConfiguration;

    private static final String EMAIL_CONFIRM_PATH = "/auth/confirm";
    private static final String TOKEN_PARAM = "token";

    public void sendVerificationMail(EmailVerificationMailData emailVerificationMailData) {
        MimeMessage mailMessage = javaMailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(mailMessage);

        try {
            helper.setFrom(mailProperties.from(), mailProperties.sender());
            helper.setTo(emailVerificationMailData.email());
            helper.setSubject(mailProperties.subject());

            Template template = freemarkerConfiguration.getTemplate("mail/email-confirm.ftlh");

            Map<String, Object> model = Map.of(
                    "appName", mailProperties.sender(),
                    "username", emailVerificationMailData.username(),
                    "confirmationLink", buildLinkVerification(emailVerificationMailData.token()),
                    "expiresAt", emailVerificationMailData.expiresAt()
            );

            StringWriter writer = new StringWriter();
            template.process(model, writer);

            String html = writer.toString();

            helper.setText(html, true);
        } catch (MessagingException | UnsupportedEncodingException e) {
            log.error("Error forming the email confirmation message: {}", e.getMessage());
            throw new EmailSendingException("Error forming the email confirmation message");
        } catch (TemplateException | IOException e) {
            throw new EmailSendingException("Error forming the email confirmation message");
        }

        try {
            javaMailSender.send(mailMessage);
        } catch (MailException e) {
            log.error("Error sending mailMessage: {}", e.getMessage());
            throw e;
        }


    }

    private String buildLinkVerification(String token) {
        return UriComponentsBuilder
                .fromUriString(mailProperties.baseUrl())
                .path(EMAIL_CONFIRM_PATH)
                .queryParam(TOKEN_PARAM, token)
                .build()
                .toUriString();
    }
}
