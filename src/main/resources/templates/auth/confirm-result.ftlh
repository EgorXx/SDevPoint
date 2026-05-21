<#-- templates/auth/confirm-result.ftlh -->
<#assign confirmStatus = result.status()?lower_case>

<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>${result.title()} — SDevPoint</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet" href="/css/styles.css">
</head>

<body class="app-body auth-confirm-result-page auth-confirm-result-page--${confirmStatus}">
<#include "/fragments/header.ftlh">

<main class="auth-login auth-confirm-result">
    <div class="auth-login__visual" aria-hidden="true">
        <div class="auth-login__dots auth-login__dots--left"></div>
        <div class="auth-login__dots auth-login__dots--right"></div>
        <div class="auth-login__wave auth-login__wave--left"></div>
        <div class="auth-login__wave auth-login__wave--right"></div>
        <div class="auth-login__circle"></div>
    </div>

    <section class="auth-confirm-result-card">
        <div class="auth-confirm-result-card__icon auth-confirm-result-card__icon--${confirmStatus}" aria-hidden="true">
            <#if confirmStatus == "success">
                <svg viewBox="0 0 24 24" fill="none">
                    <circle cx="12" cy="12" r="8.5"
                            stroke="currentColor"
                            stroke-width="1.9"/>
                    <path d="M8.2 12.1L10.7 14.6L15.9 9.4"
                          stroke="currentColor"
                          stroke-width="2"
                          stroke-linecap="round"
                          stroke-linejoin="round"/>
                </svg>
            <#elseif confirmStatus == "warning">
                <svg viewBox="0 0 24 24" fill="none">
                    <path d="M12 4.2L20.2 18.4C20.55 19 20.12 19.75 19.42 19.75H4.58C3.88 19.75 3.45 19 3.8 18.4L12 4.2Z"
                          stroke="currentColor"
                          stroke-width="1.9"
                          stroke-linejoin="round"/>
                    <path d="M12 9V13"
                          stroke="currentColor"
                          stroke-width="2"
                          stroke-linecap="round"/>
                    <path d="M12 16.6V16.7"
                          stroke="currentColor"
                          stroke-width="2.5"
                          stroke-linecap="round"/>
                </svg>
            <#else>
                <svg viewBox="0 0 24 24" fill="none">
                    <circle cx="12" cy="12" r="8.5"
                            stroke="currentColor"
                            stroke-width="1.9"/>
                    <path d="M9 9L15 15"
                          stroke="currentColor"
                          stroke-width="2"
                          stroke-linecap="round"/>
                    <path d="M15 9L9 15"
                          stroke="currentColor"
                          stroke-width="2"
                          stroke-linecap="round"/>
                </svg>
            </#if>
        </div>

        <header class="auth-confirm-result-card__header">
            <h1 class="auth-confirm-result-card__title">${result.title()}</h1>

            <p class="auth-confirm-result-card__description">
                Здесь отображается результат подтверждения вашей почты.
            </p>
        </header>

        <div class="auth-confirm-result-message auth-confirm-result-message--${confirmStatus}">
            <span class="auth-confirm-result-message__icon" aria-hidden="true">
                <#if confirmStatus == "success">
                    <svg viewBox="0 0 24 24" fill="none">
                        <circle cx="12" cy="12" r="8"
                                stroke="currentColor"
                                stroke-width="1.8"/>
                        <path d="M8.5 12.1L10.8 14.4L15.5 9.7"
                              stroke="currentColor"
                              stroke-width="2"
                              stroke-linecap="round"
                              stroke-linejoin="round"/>
                    </svg>
                <#elseif confirmStatus == "warning">
                    <svg viewBox="0 0 24 24" fill="none">
                        <path d="M12 4.5L20 18.5H4L12 4.5Z"
                              stroke="currentColor"
                              stroke-width="1.8"
                              stroke-linejoin="round"/>
                        <path d="M12 9.5V13"
                              stroke="currentColor"
                              stroke-width="2"
                              stroke-linecap="round"/>
                        <path d="M12 16.2V16.3"
                              stroke="currentColor"
                              stroke-width="2.4"
                              stroke-linecap="round"/>
                    </svg>
                <#else>
                    <svg viewBox="0 0 24 24" fill="none">
                        <circle cx="12" cy="12" r="8"
                                stroke="currentColor"
                                stroke-width="1.8"/>
                        <path d="M9.2 9.2L14.8 14.8"
                              stroke="currentColor"
                              stroke-width="2"
                              stroke-linecap="round"/>
                        <path d="M14.8 9.2L9.2 14.8"
                              stroke="currentColor"
                              stroke-width="2"
                              stroke-linecap="round"/>
                    </svg>
                </#if>
            </span>

            <span class="auth-confirm-result-message__text">
                ${result.message()}
            </span>
        </div>

        <div class="auth-confirm-result-actions">
            <#if result.showLoginButton()>
                <a class="auth-login-submit auth-confirm-result-primary-link" href="/auth/login">
                    Перейти ко входу
                </a>
            <#else>
                <a class="auth-login-submit auth-confirm-result-primary-link" href="/auth/register">
                    Зарегистрироваться
                </a>

                <a class="auth-confirm-result-secondary-link" href="/auth/login">
                    Перейти ко входу
                </a>
            </#if>
        </div>

        <#if result.showLoginButton()>
            <p class="auth-confirm-result-hint">
                Через несколько секунд вы будете перенаправлены на страницу входа.
            </p>
        <#else>
            <p class="auth-confirm-result-hint">
                Если у вас возникли вопросы, свяжитесь с нашей поддержкой.
            </p>
        </#if>
    </section>
</main>

<#if result.showLoginButton()>
    <script>
        setTimeout(function () {
            window.location.href = "/auth/login";
        }, 5000);
    </script>
</#if>

<#include "/fragments/footer.ftlh">
</body>
</html>