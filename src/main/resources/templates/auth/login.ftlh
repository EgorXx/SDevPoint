<#-- templates/auth/login.ftlh -->

<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Вход</title>

    <style>
        :root {
            --bg: #f6f7f9;
            --card-bg: #ffffff;
            --text-main: #1f2937;
            --text-muted: #6b7280;
            --border: #e5e7eb;
            --link: #2563eb;
            --link-hover: #1d4ed8;
            --danger: #dc2626;
            --danger-bg: #fef2f2;
            --danger-border: #fecaca;
            --success: #15803d;
            --success-bg: #f0fdf4;
            --success-border: #bbf7d0;
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

        .login-card {
            width: 100%;
            max-width: 440px;
            padding: 32px;
            background: var(--card-bg);
            border: 1px solid var(--border);
            border-radius: 18px;
            box-shadow: 0 10px 30px rgba(15, 23, 42, 0.06);
        }

        .login-title {
            margin: 0 0 8px;
            font-size: 30px;
            line-height: 1.2;
            letter-spacing: -0.03em;
            color: #111827;
        }

        .login-description {
            margin: 0 0 26px;
            color: var(--text-muted);
            font-size: 15px;
            line-height: 1.5;
        }

        .alert {
            margin-bottom: 18px;
            padding: 12px 14px;
            border-radius: 12px;
            font-size: 14px;
            line-height: 1.45;
        }

        .alert-error {
            color: var(--danger);
            background: var(--danger-bg);
            border: 1px solid var(--danger-border);
        }

        .alert-success {
            color: var(--success);
            background: var(--success-bg);
            border: 1px solid var(--success-border);
        }

        .form-group {
            margin-bottom: 18px;
        }

        .form-label {
            display: block;
            margin-bottom: 7px;
            font-size: 14px;
            font-weight: 650;
            color: #111827;
        }

        .form-input {
            width: 100%;
            min-height: 42px;
            padding: 10px 12px;
            border: 1px solid var(--border);
            border-radius: 10px;
            background: #ffffff;
            color: var(--text-main);
            font: inherit;
            font-size: 15px;
        }

        .form-input:focus {
            outline: none;
            border-color: #93c5fd;
            box-shadow: 0 0 0 3px rgba(147, 197, 253, 0.35);
        }

        .submit-button {
            width: 100%;
            min-height: 42px;
            border: none;
            border-radius: 10px;
            background: var(--link);
            color: #ffffff;
            font: inherit;
            font-size: 15px;
            font-weight: 650;
            cursor: pointer;
        }

        .submit-button:hover {
            background: var(--link-hover);
        }

        .register-link {
            margin-top: 18px;
            color: var(--text-muted);
            font-size: 14px;
            text-align: center;
        }

        .register-link a {
            color: var(--link);
            text-decoration: none;
        }

        .register-link a:hover {
            text-decoration: underline;
        }

        @media (max-width: 520px) {
            .login-card {
                padding: 24px 20px;
            }

            .login-title {
                font-size: 26px;
            }
        }
    </style>
</head>
<body>

<main class="page">
    <section class="login-card">
        <h1 class="login-title">Вход</h1>

        <#if RequestParameters.error??>
            <div class="alert alert-error">
                Неверная почта или пароль.
            </div>
        </#if>

        <#if RequestParameters.logout??>
            <div class="alert alert-success">
                Вы успешно вышли из аккаунта.
            </div>
        </#if>

        <form method="post" action="/auth/login">
            <#if _csrf??>
                <input type="hidden"
                       name="${_csrf.parameterName}"
                       value="${_csrf.token}">
            </#if>

            <div class="form-group">
                <label class="form-label" for="email">Email</label>

                <input
                        id="email"
                        class="form-input"
                        type="email"
                        name="email"
                        autocomplete="email"
                        required
                >
            </div>

            <div class="form-group">
                <label class="form-label" for="password">Пароль</label>

                <input
                        id="password"
                        class="form-input"
                        type="password"
                        name="password"
                        autocomplete="current-password"
                        required
                >
            </div>

            <button class="submit-button" type="submit">
                Войти
            </button>
        </form>

        <div class="register-link">
            Нет аккаунта? <a href="/auth/register">Зарегистрироваться</a>
        </div>
    </section>
</main>

</body>
</html>