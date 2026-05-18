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
    <title>Подтверждение почты</title>

    <style>
        :root {
            --bg: #f6f7f9;
            --card-bg: #ffffff;
            --text-main: #1f2937;
            --text-muted: #6b7280;
            --border: #e5e7eb;
            --link: #2563eb;
            --link-hover: #1d4ed8;
            --success: #15803d;
            --success-bg: #f0fdf4;
            --success-border: #bbf7d0;
            --warning: #b45309;
            --warning-bg: #fffbeb;
            --warning-border: #fde68a;
            --danger: #dc2626;
            --danger-bg: #fef2f2;
            --danger-border: #fecaca;
        }

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            min-height: 100vh;
            background: var(--bg);
            color: var(--text-main);
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif;
        }

        .page {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 32px 16px;
        }

        .card {
            width: 100%;
            max-width: 520px;
            padding: 34px;
            background: var(--card-bg);
            border: 1px solid var(--border);
            border-radius: 18px;
            box-shadow: 0 10px 30px rgba(15, 23, 42, 0.06);
        }

        .title {
            margin: 0 0 12px;
            font-size: 30px;
            line-height: 1.2;
            letter-spacing: -0.03em;
            color: #111827;
        }

        .description {
            margin: 0 0 24px;
            color: var(--text-muted);
            font-size: 16px;
            line-height: 1.55;
        }

        .notice {
            display: none;
            margin-bottom: 18px;
            padding: 12px 14px;
            border-radius: 12px;
            font-size: 14px;
            line-height: 1.45;
        }

        .notice-success {
            display: block;
            color: var(--success);
            background: var(--success-bg);
            border: 1px solid var(--success-border);
        }

        .notice-warning {
            display: block;
            color: var(--warning);
            background: var(--warning-bg);
            border: 1px solid var(--warning-border);
        }

        .notice-error {
            display: block;
            color: var(--danger);
            background: var(--danger-bg);
            border: 1px solid var(--danger-border);
        }

        .actions {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 20px;
        }

        .button {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-height: 42px;
            padding: 10px 15px;
            border-radius: 10px;
            border: 1px solid var(--border);
            background: #ffffff;
            color: var(--text-main);
            text-decoration: none;
            font: inherit;
            font-size: 15px;
            cursor: pointer;
        }

        .button-primary {
            border: none;
            background: var(--link);
            color: #ffffff;
        }

        .button-primary:hover {
            background: var(--link-hover);
        }

        .button-secondary:hover {
            background: #f9fafb;
            border-color: #cbd5e1;
        }

        .button:disabled {
            cursor: default;
            opacity: 0.6;
        }

        .hint {
            margin-top: 18px;
            color: var(--text-muted);
            font-size: 14px;
            line-height: 1.5;
        }

        @media (max-width: 520px) {
            .card {
                padding: 26px 20px;
            }

            .title {
                font-size: 26px;
            }

            .actions {
                display: grid;
            }

            .button {
                width: 100%;
            }
        }
    </style>
</head>
<body>

<main class="page">
    <section class="card">
        <h1 class="title">Подтвердите почту</h1>

        <p class="description">
            Мы отправили письмо со ссылкой для подтверждения аккаунта.
            Перейдите по ссылке из письма, после этого можно будет войти в систему.
        </p>

        <div id="notice" class="notice"></div>

        <div class="actions">
            <button id="resendButton" class="button button-primary" type="button">
                Отправить письмо ещё раз
            </button>

            <a class="button button-secondary" href="/auth/login">
                Перейти ко входу
            </a>
        </div>

        <p class="hint">
            Если письмо не пришло, проверьте папку “Спам”. Повторную отправку лучше не нажимать слишком часто:
            на сервере есть ограничение по количеству запросов.
        </p>
    </section>
</main>

<script>
    const resendButton = document.getElementById("resendButton");
    const notice = document.getElementById("notice");

    const csrfHeaderName = <#if csrfHeaderName?has_content>"${csrfHeaderName?js_string}"<#else>null</#if>;
    const csrfToken = <#if csrfToken?has_content>"${csrfToken?js_string}"<#else>null</#if>;

    function showNotice(message, type) {
        notice.textContent = message;
        notice.className = "notice notice-" + type;
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
            resendButton.textContent = "Отправить письмо ещё раз";
        }
    }

    resendButton.addEventListener("click", resendEmail);
</script>

</body>
</html>