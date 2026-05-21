<#-- templates/auth/login.ftlh -->
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Вход — SDevPoint</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet" href="/css/styles.css">
</head>

<body class="app-body auth-login-page">
<#include "/fragments/header.ftlh">

<main class="auth-login">
    <div class="auth-login__visual" aria-hidden="true">
        <div class="auth-login__dots auth-login__dots--left"></div>
        <div class="auth-login__dots auth-login__dots--right"></div>
        <div class="auth-login__wave auth-login__wave--left"></div>
        <div class="auth-login__wave auth-login__wave--right"></div>
        <div class="auth-login__circle"></div>
    </div>

    <section class="auth-login__content">
        <header class="auth-login__header">
            <h1 class="auth-login__title">Вход в аккаунт</h1>
            <p class="auth-login__description">
                Войдите, чтобы продолжить работу с базой знаний.
            </p>
        </header>

        <section class="auth-login-card">
            <#if RequestParameters.error??>
                <div class="auth-login-alert auth-login-alert--error">
                    Неверная почта или пароль.
                </div>
            </#if>

            <#if RequestParameters.logout??>
                <div class="auth-login-alert auth-login-alert--success">
                    Вы успешно вышли из аккаунта.
                </div>
            </#if>

            <form method="post" action="/auth/login" class="auth-login-form">
                <#if _csrf??>
                    <input type="hidden"
                           name="${_csrf.parameterName}"
                           value="${_csrf.token}">
                </#if>

                <div class="auth-login-field">
                    <label class="auth-login-label" for="email">Почта</label>

                    <div class="auth-login-input-wrap">
                        <span class="auth-login-input-icon" aria-hidden="true">
                            <svg viewBox="0 0 24 24" fill="none">
                                <path d="M4 6.75C4 5.78 4.78 5 5.75 5H18.25C19.22 5 20 5.78 20 6.75V17.25C20 18.22 19.22 19 18.25 19H5.75C4.78 19 4 18.22 4 17.25V6.75Z"
                                      stroke="currentColor"
                                      stroke-width="1.8"
                                      stroke-linejoin="round"/>
                                <path d="M5 7L12 12.4L19 7"
                                      stroke="currentColor"
                                      stroke-width="1.8"
                                      stroke-linecap="round"
                                      stroke-linejoin="round"/>
                            </svg>
                        </span>

                        <input
                                id="email"
                                class="auth-login-input"
                                type="email"
                                name="email"
                                autocomplete="email"
                                placeholder="Введите вашу почту"
                                required
                        >
                    </div>
                </div>

                <div class="auth-login-field">
                    <label class="auth-login-label" for="password">Пароль</label>

                    <div class="auth-login-input-wrap">
                        <span class="auth-login-input-icon" aria-hidden="true">
                            <svg viewBox="0 0 24 24" fill="none">
                                <path d="M7.5 10V8C7.5 5.52 9.52 3.5 12 3.5C14.48 3.5 16.5 5.52 16.5 8V10"
                                      stroke="currentColor"
                                      stroke-width="1.8"
                                      stroke-linecap="round"/>
                                <path d="M6.75 10H17.25C18.22 10 19 10.78 19 11.75V18.25C19 19.22 18.22 20 17.25 20H6.75C5.78 20 5 19.22 5 18.25V11.75C5 10.78 5.78 10 6.75 10Z"
                                      stroke="currentColor"
                                      stroke-width="1.8"
                                      stroke-linejoin="round"/>
                                <path d="M12 14V16"
                                      stroke="currentColor"
                                      stroke-width="1.8"
                                      stroke-linecap="round"/>
                            </svg>
                        </span>

                        <input
                                id="password"
                                class="auth-login-input auth-login-input--password"
                                type="password"
                                name="password"
                                autocomplete="current-password"
                                placeholder="Введите пароль"
                                required
                        >

                        <button
                                class="auth-login-password-toggle"
                                id="passwordToggle"
                                type="button"
                                aria-label="Показать пароль">
                            <span class="auth-login-password-toggle__icon auth-login-password-toggle__icon--show" aria-hidden="true">
                                <svg viewBox="0 0 24 24" fill="none">
                                    <path d="M3.5 12C5.45 8.65 8.32 7 12 7C15.68 7 18.55 8.65 20.5 12C18.55 15.35 15.68 17 12 17C8.32 17 5.45 15.35 3.5 12Z"
                                          stroke="currentColor"
                                          stroke-width="1.8"
                                          stroke-linejoin="round"/>
                                    <circle cx="12" cy="12" r="2.6"
                                            stroke="currentColor"
                                            stroke-width="1.8"/>
                                </svg>
                            </span>
                            <span class="auth-login-password-toggle__icon auth-login-password-toggle__icon--hide" aria-hidden="true">
                                <svg viewBox="0 0 24 24" fill="none">
                                    <path d="M4 4L20 20"
                                          stroke="currentColor"
                                          stroke-width="1.8"
                                          stroke-linecap="round"/>
                                    <path d="M8.6 8.1C9.58 7.37 10.71 7 12 7C15.68 7 18.55 8.65 20.5 12C19.82 13.17 19.02 14.13 18.1 14.88"
                                          stroke="currentColor"
                                          stroke-width="1.8"
                                          stroke-linecap="round"
                                          stroke-linejoin="round"/>
                                    <path d="M15.1 16.45C14.15 16.82 13.12 17 12 17C8.32 17 5.45 15.35 3.5 12C4.26 10.7 5.18 9.66 6.25 8.88"
                                          stroke="currentColor"
                                          stroke-width="1.8"
                                          stroke-linecap="round"
                                          stroke-linejoin="round"/>
                                </svg>
                            </span>
                        </button>
                    </div>
                </div>

                <button class="auth-login-submit" type="submit">
                    Войти
                </button>
            </form>
        </section>

        <div class="auth-login-register">
            <span>Нет аккаунта?</span>
            <a href="/auth/register">Зарегистрироваться</a>
        </div>
    </section>
</main>

<script src="/js/login.js"></script>

<#include "/fragments/footer.ftlh">
</body>
</html>