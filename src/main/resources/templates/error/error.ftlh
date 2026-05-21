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
    <title>${pageTitle} — SDevPoint</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet" href="/css/styles.css">
</head>

<body class="app-body error-page error-generic-page error-generic-page--${badgeClass}">
<#include "/fragments/header.ftlh">

<main class="error-page-main">
    <div class="error-page-visual" aria-hidden="true">
        <div class="error-page-visual__dots error-page-visual__dots--left"></div>
        <div class="error-page-visual__dots error-page-visual__dots--right"></div>
        <div class="error-page-visual__wave error-page-visual__wave--top"></div>
        <div class="error-page-visual__wave error-page-visual__wave--bottom"></div>
        <div class="error-page-visual__circle error-page-visual__circle--top"></div>
        <div class="error-page-visual__circle error-page-visual__circle--bottom"></div>
    </div>

    <section class="error-page-content">
        <div class="error-page-code">
            ${statusText}
        </div>

        <h1 class="error-page-title">
            ${pageTitle}
        </h1>

        <p class="error-page-description">
            ${pageMessage}
        </p>

        <#if path??>
            <div class="error-page-meta">
                Путь: ${path}
            </div>
        </#if>

        <div class="error-page-actions">
            <a class="error-page-button error-page-button--primary" href="/">
                <span class="error-page-button__icon" aria-hidden="true">
                    <svg viewBox="0 0 24 24" fill="none">
                        <path d="M4 10.8L12 4L20 10.8"
                              stroke="currentColor"
                              stroke-width="1.9"
                              stroke-linecap="round"
                              stroke-linejoin="round"/>
                        <path d="M6.5 10.5V19H17.5V10.5"
                              stroke="currentColor"
                              stroke-width="1.9"
                              stroke-linecap="round"
                              stroke-linejoin="round"/>
                        <path d="M10 19V14H14V19"
                              stroke="currentColor"
                              stroke-width="1.9"
                              stroke-linecap="round"
                              stroke-linejoin="round"/>
                    </svg>
                </span>
                <span>На главную</span>
            </a>

            <a class="error-page-button error-page-button--secondary" href="javascript:history.back()">
                <span class="error-page-button__icon" aria-hidden="true">
                    <svg viewBox="0 0 24 24" fill="none">
                        <path d="M15 6L9 12L15 18"
                              stroke="currentColor"
                              stroke-width="1.9"
                              stroke-linecap="round"
                              stroke-linejoin="round"/>
                        <path d="M10 12H21"
                              stroke="currentColor"
                              stroke-width="1.9"
                              stroke-linecap="round"/>
                    </svg>
                </span>
                <span>Назад</span>
            </a>
        </div>
    </section>
</main>

</body>
</html>