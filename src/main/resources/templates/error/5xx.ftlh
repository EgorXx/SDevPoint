<#-- templates/error/5xx.ftlh -->
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>${title!"Ошибка сервера"} — SDevPoint</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet" href="/css/styles.css">
</head>

<body class="app-body error-page error-5xx-page">
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
            ${(status)!500}
        </div>

        <h1 class="error-page-title">
            ${title!"Ошибка сервера"}
        </h1>

        <p class="error-page-description">
            ${message!"Что-то пошло не так на стороне сервера. Попробуйте повторить действие позже."}
        </p>

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

            <a class="error-page-button error-page-button--secondary" href="javascript:location.reload()">
                <span class="error-page-button__icon" aria-hidden="true">
                    <svg viewBox="0 0 24 24" fill="none">
                        <path d="M20 12C20 16.42 16.42 20 12 20C7.58 20 4 16.42 4 12C4 7.58 7.58 4 12 4C14.58 4 16.87 5.22 18.33 7.12"
                              stroke="currentColor"
                              stroke-width="1.9"
                              stroke-linecap="round"
                              stroke-linejoin="round"/>
                        <path d="M18.8 4.5V7.5H15.8"
                              stroke="currentColor"
                              stroke-width="1.9"
                              stroke-linecap="round"
                              stroke-linejoin="round"/>
                    </svg>
                </span>
                <span>Обновить страницу</span>
            </a>
        </div>
    </section>
</main>

</body>
</html>