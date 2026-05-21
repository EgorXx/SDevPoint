<#-- templates/index.ftlh -->
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Главная — SDevPoint</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet" href="/css/styles.css">
    <script src="/js/index.js" defer></script>
</head>
<body class="app-body">

<#include "/fragments/header.ftlh">

<main class="home-page">
    <section class="home-hero">
        <div class="home-hero__content">
            <p class="home-hero__eyebrow">SDevPoint</p>

            <h1 class="home-hero__title">
                Личная база знаний<br>
                для разработчика
            </h1>

            <p class="home-hero__subtitle">
                Сохраняйте статьи и кейсы в Markdown, организуйте знания
                и находите нужное быстрее.
            </p>

            <nav class="home-cards" aria-label="Основные разделы">
                <a href="/articles/public" class="home-card">
                    <span class="home-card__icon" aria-hidden="true">
                        <svg viewBox="0 0 48 48" fill="none">
                            <path d="M14 6H28L38 16V42H14V6Z" stroke="currentColor" stroke-width="3" stroke-linejoin="round"/>
                            <path d="M28 6V16H38" stroke="currentColor" stroke-width="3" stroke-linejoin="round"/>
                            <path d="M20 26H32" stroke="currentColor" stroke-width="3" stroke-linecap="round"/>
                            <path d="M20 34H29" stroke="currentColor" stroke-width="3" stroke-linecap="round"/>
                        </svg>
                    </span>

                    <span class="home-card__body">
                        <span class="home-card__title">Статьи</span>
                        <span class="home-card__description">
                            Пишите технические статьи и храните их в Markdown.
                        </span>
                    </span>

                    <span class="home-card__arrow" aria-hidden="true">→</span>
                </a>

                <a href="/cases/public" class="home-card">
                    <span class="home-card__icon" aria-hidden="true">
                        <svg viewBox="0 0 48 48" fill="none">
                            <path d="M7 15H41V40H7V15Z" stroke="currentColor" stroke-width="3" stroke-linejoin="round"/>
                            <path d="M7 15L14 8H24L29 15" stroke="currentColor" stroke-width="3" stroke-linejoin="round"/>
                        </svg>
                    </span>

                    <span class="home-card__body">
                        <span class="home-card__title">Кейсы</span>
                        <span class="home-card__description">
                            Публикуйте разборы задач, проектов и решений.
                        </span>
                    </span>

                    <span class="home-card__arrow" aria-hidden="true">→</span>
                </a>
            </nav>
        </div>

        <div class="home-hero__visual" aria-hidden="true">
            <div class="home-visual home-visual--grid-small"></div>
            <div class="home-visual home-visual--grid-large"></div>
            <div class="home-visual home-visual--waves"></div>
            <div class="home-visual home-visual--plus"></div>
            <div class="home-visual home-visual--circle"></div>
        </div>
    </section>
</main>

<#include "/fragments/footer.ftlh">

</body>
</html>