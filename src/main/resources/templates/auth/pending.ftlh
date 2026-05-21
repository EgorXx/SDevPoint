<#-- templates/auth/pending.ftlh -->
<#if _csrf??>
    <#assign csrfHeaderName = _csrf.headerName>
    <#assign csrfToken = _csrf.token>
<#else>
    <#assign csrfHeaderName = "">
    <#assign csrfToken = "">
</#if>

<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Подтверждение почты — SDevPoint</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet" href="/css/styles.css">
</head>

<body class="app-body auth-pending-page">
<#include "/fragments/header.ftlh">

<main class="auth-login auth-pending">
    <div class="auth-login__visual" aria-hidden="true">
        <div class="auth-login__dots auth-login__dots--left"></div>
        <div class="auth-login__dots auth-login__dots--right"></div>
        <div class="auth-login__wave auth-login__wave--left"></div>
        <div class="auth-login__wave auth-login__wave--right"></div>
        <div class="auth-login__circle"></div>
    </div>

    <section class="auth-login__content auth-pending__content">
        <header class="auth-login__header auth-pending__header">
            <h1 class="auth-login__title">Подтверждение почты</h1>

            <p class="auth-login__description auth-pending__description">
                Мы отправили письмо с подтверждением на вашу почту.<br>
                Перейдите по ссылке в письме, чтобы активировать аккаунт.
            </p>
        </header>

        <section class="auth-login-card auth-pending-card">
            <div class="auth-pending-card__icon" aria-hidden="true">
                <svg viewBox="0 0 24 24" fill="none">
                    <path d="M4 6.75C4 5.78 4.78 5 5.75 5H18.25C19.22 5 20 5.78 20 6.75V17.25C20 18.22 19.22 19 18.25 19H5.75C4.78 19 4 18.22 4 17.25V6.75Z"
                          stroke="currentColor"
                          stroke-width="1.9"
                          stroke-linejoin="round"/>
                    <path d="M5 7L12 12.4L19 7"
                          stroke="currentColor"
                          stroke-width="1.9"
                          stroke-linecap="round"
                          stroke-linejoin="round"/>
                </svg>
            </div>

            <p class="auth-pending-card__text">
                Если письмо не пришло, проверьте папку Спам<br>
                или отправьте его повторно.
            </p>

            <div id="notice" class="auth-pending-notice"></div>

            <div class="auth-pending-actions">
                <button id="resendButton" class="auth-login-submit auth-pending-submit" type="button">
                    Отправить письмо еще раз
                </button>

                <a class="auth-pending-login-link" href="/auth/login">
                    Перейти ко входу
                </a>
            </div>
        </section>
    </section>
</main>

<script>
    const resendButton = document.getElementById("resendButton");
    const notice = document.getElementById("notice");

    const csrfHeaderName = <#if csrfHeaderName?has_content>"${csrfHeaderName?js_string}"<#else>null</#if>;
    const csrfToken = <#if csrfToken?has_content>"${csrfToken?js_string}"<#else>null</#if>;

    function showNotice(message, type) {
        notice.textContent = message;
        notice.className = "auth-pending-notice auth-pending-notice--" + type;
    }

    function buildHeaders() {
        const headers = {};

        if (csrfHeaderName && csrfToken) {
            headers[csrfHeaderName] = csrfToken;
        }

        return headers;
    }

    async function resendEmail() {
        resendButton.disabled = true;
        resendButton.textContent = "Отправляем...";

        try {
            const response = await fetch("/auth/resend", {
                method: "POST",
                headers: buildHeaders()
            });

            if (response.status === 409) {
                const message = await response.text();
                showNotice(message, "warning");

                setTimeout(function () {
                    window.location.href = "/auth/register";
                }, 2000);

                return;
            }

            if (response.redirected) {
                window.location.href = response.url;
                return;
            }

            const message = await response.text();

            if (response.status === 429) {
                showNotice(message || "Слишком много запросов. Попробуйте позже.", "warning");
                return;
            }

            if (!response.ok) {
                showNotice(message || "Не удалось отправить письмо повторно.", "error");
                return;
            }

            showNotice(message || "Письмо отправлено вам на почту.", "success");
        } catch (e) {
            console.error(e);
            showNotice("Не удалось отправить письмо повторно.", "error");
        } finally {
            resendButton.disabled = false;
            resendButton.textContent = "Отправить письмо еще раз";
        }
    }

    resendButton.addEventListener("click", resendEmail);
</script>

<#include "/fragments/footer.ftlh">
</body>
</html>