<#-- templates/error/400.ftlh -->
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>${title!"Некорректный запрос"} — SDevPoint</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet" href="/css/styles.css">
</head>

<body class="app-body error-page error-400-page">
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
            ${(status)!400}
        </div>

        <h1 class="error-page-title">
            ${title!"Некорректный запрос"}
        </h1>

        <p class="error-page-description">
            ${message!"Запрос не может быть обработан. Проверьте введённые данные и попробуйте ещё раз."}
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