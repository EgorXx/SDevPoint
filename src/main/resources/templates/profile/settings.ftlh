<#import "/spring.ftl" as spring>

<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Настройки профиля</title>

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

        .page-wrapper {
            max-width: 720px;
            margin: 0 auto;
            padding: 40px 20px 64px;
        }

        .page-header {
            margin-bottom: 28px;
        }

        .page-title {
            margin: 0 0 8px;
            font-size: 36px;
            line-height: 1.2;
            letter-spacing: -0.03em;
            color: #111827;
        }

        .page-description {
            margin: 0;
            color: var(--text-muted);
            font-size: 16px;
        }

        .settings-card {
            padding: 28px 32px;
            background: var(--card-bg);
            border: 1px solid var(--border);
            border-radius: 16px;
            box-shadow: 0 8px 24px rgba(15, 23, 42, 0.05);
        }

        .section-title {
            margin: 0 0 18px;
            font-size: 24px;
            line-height: 1.3;
            color: #111827;
        }

        .form-group {
            margin-bottom: 18px;
        }

        .form-label {
            display: block;
            margin-bottom: 8px;
            font-size: 15px;
            font-weight: 650;
            color: #111827;
        }

        .form-input {
            width: 100%;
            padding: 11px 13px;
            border: 1px solid var(--border);
            border-radius: 10px;
            background: #ffffff;
            color: var(--text-main);
            font: inherit;
        }

        .form-input:focus {
            outline: none;
            border-color: #93c5fd;
            box-shadow: 0 0 0 3px rgba(147, 197, 253, 0.35);
        }

        .field-error {
            margin-top: 8px;
            color: var(--danger);
            font-size: 14px;
        }

        .field-error p {
            margin: 4px 0;
        }

        .success-message {
            margin-bottom: 18px;
            padding: 12px 14px;
            border: 1px solid var(--success-border);
            border-radius: 12px;
            background: var(--success-bg);
            color: var(--success);
            font-size: 15px;
        }

        .actions {
            display: flex;
            gap: 10px;
            align-items: center;
            margin-top: 22px;
        }

        .submit-button {
            padding: 10px 16px;
            border: none;
            border-radius: 10px;
            background: var(--link);
            color: #ffffff;
            font-size: 15px;
            cursor: pointer;
        }

        .submit-button:hover {
            background: var(--link-hover);
        }

        .back-link {
            color: var(--text-muted);
            text-decoration: none;
            font-size: 15px;
        }

        .back-link:hover {
            color: var(--link-hover);
            text-decoration: underline;
        }

        @media (max-width: 700px) {
            .page-wrapper {
                padding: 24px 14px 40px;
            }

            .page-title {
                font-size: 30px;
            }

            .settings-card {
                padding: 22px 20px;
            }

            .actions {
                flex-direction: column;
                align-items: stretch;
            }

            .submit-button {
                width: 100%;
            }
        }
    </style>
</head>
<body>

<main class="page-wrapper">
    <header class="page-header">
        <h1 class="page-title">Настройки профиля</h1>
        <p class="page-description">
            Здесь можно изменить данные профиля.
        </p>
    </header>

    <#if success?? && success?has_content>
        <div class="success-message">
            ${success}
        </div>
    </#if>

    <section class="settings-card">
        <h2 class="section-title">Имя пользователя</h2>

        <form method="post" action="/profile/settings/name">
            <#if _csrf??>
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
            </#if>

            <div class="form-group">
                <label class="form-label" for="username">Имя</label>

                <input
                        class="form-input"
                        id="username"
                        type="text"
                        name="username"
                        value="${(nameForm.username())!''}"
                        autocomplete="username"
                >

                <@spring.bind "nameForm.username"/>
                <#if spring.status.error>
                    <div class="field-error">
                        <#list spring.status.errorMessages as error>
                            <p>${error}</p>
                        </#list>
                    </div>
                </#if>
            </div>

            <div class="actions">
                <button class="submit-button" type="submit">
                    Сохранить изменения
                </button>

                <a class="back-link" href="/profile">
                    Вернуться в профиль
                </a>
            </div>
        </form>
    </section>
</main>

</body>
</html>