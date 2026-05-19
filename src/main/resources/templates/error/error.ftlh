<#-- templates/error/error.ftlh -->

<#assign statusText = (status!'500')?string>

<#if statusText == "400">
    <#assign pageTitle = "Некорректный запрос">
    <#assign pageMessage = "Запрос не может быть обработан. Проверьте введённые данные и попробуйте ещё раз.">
    <#assign badgeClass = "warning">
<#elseif statusText == "403">
    <#assign pageTitle = "Доступ запрещён">
    <#assign pageMessage = "У вас нет прав для просмотра этой страницы или выполнения этого действия.">
    <#assign badgeClass = "danger">
<#elseif statusText == "404">
    <#assign pageTitle = "Страница не найдена">
    <#assign pageMessage = "Такой страницы не существует, она была удалена или у вас нет доступа к этому ресурсу.">
    <#assign badgeClass = "muted">
<#elseif statusText?starts_with("5")>
    <#assign pageTitle = "Ошибка сервера">
    <#assign pageMessage = "Что-то пошло не так на стороне сервера. Попробуйте повторить действие позже.">
    <#assign badgeClass = "danger">
<#else>
    <#assign pageTitle = "Ошибка">
    <#assign pageMessage = "Запрос завершился ошибкой. Попробуйте повторить действие позже.">
    <#assign badgeClass = "muted">
</#if>

<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>${pageTitle}</title>

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

            --warning-bg: #fffbeb;
            --warning-border: #fde68a;
            --warning-text: #b45309;

            --muted-bg: #f3f4f6;
            --muted-border: #e5e7eb;
            --muted-text: #4b5563;
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
            font-size: 13px;
            font-weight: 700;
        }

        .status-badge.danger {
            background: var(--danger-bg);
            border: 1px solid var(--danger-border);
            color: var(--danger-text);
        }

        .status-badge.warning {
            background: var(--warning-bg);
            border: 1px solid var(--warning-border);
            color: var(--warning-text);
        }

        .status-badge.muted {
            background: var(--muted-bg);
            border: 1px solid var(--muted-border);
            color: var(--muted-text);
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

        .meta {
            margin-top: -8px;
            margin-bottom: 24px;
            color: #9ca3af;
            font-size: 13px;
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
<#include "/fragments/header.ftlh">

<main class="error-card">
    <div class="status-badge ${badgeClass}">
        Ошибка ${statusText}
    </div>

    <h1>${pageTitle}</h1>

    <p>${pageMessage}</p>

    <#if path??>
        <div class="meta">
            Путь: ${path}
        </div>
    </#if>

    <div class="actions">
        <a class="action-link" href="/">На главную</a>
        <a class="action-link secondary-link" href="javascript:history.back()">Назад</a>
    </div>
</main>

</body>
</html>