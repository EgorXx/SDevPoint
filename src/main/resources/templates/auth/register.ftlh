<#-- templates/auth/register.ftlh -->
<#import "/spring.ftl" as spring>

<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Регистрация</title>

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

        .register-card {
            width: 100%;
            max-width: 440px;
            padding: 32px;
            background: var(--card-bg);
            border: 1px solid var(--border);
            border-radius: 18px;
            box-shadow: 0 10px 30px rgba(15, 23, 42, 0.06);
        }

        .register-title {
            margin: 0 0 8px;
            font-size: 30px;
            line-height: 1.2;
            letter-spacing: -0.03em;
            color: #111827;
        }

        .register-description {
            margin: 0 0 26px;
            color: var(--text-muted);
            font-size: 15px;
            line-height: 1.5;
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

        .field-error {
            margin-top: 7px;
            color: var(--danger);
            font-size: 14px;
        }

        .field-error p {
            margin: 4px 0 0;
        }

        .global-error {
            margin-bottom: 18px;
            padding: 12px 14px;
            border: 1px solid var(--danger-border);
            border-radius: 12px;
            background: var(--danger-bg);
            color: var(--danger);
            font-size: 14px;
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

        .login-link {
            margin-top: 18px;
            color: var(--text-muted);
            font-size: 14px;
            text-align: center;
        }

        .login-link a {
            color: var(--link);
            text-decoration: none;
        }

        .login-link a:hover {
            text-decoration: underline;
        }

        @media (max-width: 520px) {
            .register-card {
                padding: 24px 20px;
            }

            .register-title {
                font-size: 26px;
            }
        }
    </style>
</head>
<body>

<main class="page">
    <section class="register-card">
        <h1 class="register-title">Регистрация</h1>

        <p class="register-description">
            Создайте аккаунт. После регистрации нужно будет подтвердить почту.
        </p>

        <#if error?? && error?has_content>
            <div class="global-error">
                ${error}
            </div>
        </#if>

        <form method="post" action="/auth/register">
            <#if _csrf??>
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
            </#if>

            <div class="form-group">
                <label class="form-label" for="email">Email</label>

                <input
                        id="email"
                        class="form-input"
                        type="email"
                        name="email"
                        value="${(form.email())!''}"
                        autocomplete="email"
                        required
                >

                <@spring.bind "form.email"/>
                <#if spring.status.error>
                    <div class="field-error">
                        <#list spring.status.errorMessages as validationError>
                            <p>${validationError}</p>
                        </#list>
                    </div>
                </#if>
            </div>

            <div class="form-group">
                <label class="form-label" for="password">Пароль</label>

                <input
                        id="password"
                        class="form-input"
                        type="password"
                        name="password"
                        autocomplete="new-password"
                        required
                        minlength="4"
                        maxlength="32"
                >

                <@spring.bind "form.password"/>
                <#if spring.status.error>
                    <div class="field-error">
                        <#list spring.status.errorMessages as validationError>
                            <p>${validationError}</p>
                        </#list>
                    </div>
                </#if>
            </div>

            <button class="submit-button" type="submit">
                Зарегистрироваться
            </button>
        </form>

        <div class="login-link">
            Уже есть аккаунт? <a href="/login">Войти</a>
        </div>
    </section>
</main>

</body>
</html>