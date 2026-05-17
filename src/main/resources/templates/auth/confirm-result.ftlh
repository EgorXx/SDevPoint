<#-- templates/auth/confirm-result.ftlh -->

<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>${result.title()}</title>

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
            --error: #dc2626;
            --error-bg: #fef2f2;
            --error-border: #fecaca;
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

        .message {
            margin: 0;
            color: var(--text-muted);
            font-size: 16px;
            line-height: 1.55;
        }

        .status-box {
            margin-top: 22px;
            padding: 14px 16px;
            border-radius: 12px;
            font-size: 15px;
            line-height: 1.5;
        }

        .status-success {
            color: var(--success);
            background: var(--success-bg);
            border: 1px solid var(--success-border);
        }

        .status-warning {
            color: var(--warning);
            background: var(--warning-bg);
            border: 1px solid var(--warning-border);
        }

        .status-error {
            color: var(--error);
            background: var(--error-bg);
            border: 1px solid var(--error-border);
        }

        .actions {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 24px;
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

        .redirect-hint {
            margin-top: 16px;
            color: var(--text-muted);
            font-size: 14px;
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
        <h1 class="title">${result.title()}</h1>

        <div class="status-box status-${result.status()}">
            ${result.message()}
        </div>

        <div class="actions">
            <#if result.showLoginButton()>
                <a class="button button-primary" href="/auth/login">
                    Перейти ко входу
                </a>
            <#else>
                <a class="button button-primary" href="/auth/register">
                    Зарегистрироваться
                </a>

                <a class="button button-secondary" href="/auth/login">
                    Перейти ко входу
                </a>
            </#if>
        </div>

        <#if result.showLoginButton()>
            <p class="redirect-hint">
                Через несколько секунд вы будете перенаправлены на страницу входа.
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

</body>
</html>