<#-- templates/error/5xx.ftlh -->

<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Ошибка сервера</title>

    <style>
        :root {
            --bg: #f6f7f9;
            --card-bg: #ffffff;
            --text-main: #1f2937;
            --text-muted: #6b7280;
            --border: #e5e7eb;
            --link: #2563eb;
            --link-hover: #1d4ed8;
            --danger-bg: #fef2f2;
            --danger-border: #fecaca;
            --danger-text: #b91c1c;
        }

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 24px;
            background: var(--bg);
            color: var(--text-main);
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif;
        }

        .error-card {
            width: 100%;
            max-width: 600px;
            padding: 34px 38px;
            background: var(--card-bg);
            border: 1px solid var(--border);
            border-radius: 18px;
            box-shadow: 0 10px 30px rgba(15, 23, 42, 0.06);
        }

        .status-badge {
            display: inline-flex;
            align-items: center;
            margin-bottom: 16px;
            padding: 5px 11px;
            border-radius: 999px;
            background: var(--danger-bg);
            border: 1px solid var(--danger-border);
            color: var(--danger-text);
            font-size: 13px;
            font-weight: 700;
        }

        h1 {
            margin: 0 0 12px;
            color: #111827;
            font-size: 32px;
            line-height: 1.2;
            letter-spacing: -0.03em;
        }

        p {
            margin: 0 0 24px;
            color: var(--text-muted);
            font-size: 16px;
            line-height: 1.6;
        }

        .hint {
            margin-top: -10px;
            margin-bottom: 24px;
            color: #6b7280;
            font-size: 14px;
            line-height: 1.5;
        }

        .actions {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }

        .action-link {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-height: 40px;
            padding: 9px 14px;
            border-radius: 10px;
            border: 1px solid #bfdbfe;
            background: #eff6ff;
            color: var(--link);
            text-decoration: none;
            font-size: 15px;
        }

        .action-link:hover {
            color: var(--link-hover);
            border-color: #93c5fd;
            background: #dbeafe;
        }

        .secondary-link {
            border-color: var(--border);
            background: #ffffff;
            color: var(--text-main);
        }

        .secondary-link:hover {
            border-color: #cbd5e1;
            background: #f9fafb;
            color: var(--text-main);
        }

        @media (max-width: 640px) {
            .error-card {
                padding: 28px 22px;
            }

            h1 {
                font-size: 27px;
            }
        }
    </style>
</head>
<body>

<main class="error-card">
    <div class="status-badge">Ошибка ${(status)!500}</div>

    <h1>${title!"Ошибка сервера"}</h1>

    <p>
        ${message!"Что-то пошло не так на стороне сервера. Попробуйте повторить действие позже."}
    </p>

    <div class="actions">
        <a class="action-link" href="/">На главную</a>
        <a class="action-link secondary-link" href="javascript:location.reload()">Обновить страницу</a>
    </div>
</main>

</body>
</html>