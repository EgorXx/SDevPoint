<#-- templates/index.ftlh -->
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Главная — SDevPoint</title>

    <style>
        :root {
            --bg: #f6f7f9;
            --card-bg: #ffffff;
            --text-main: #1f2937;
            --text-muted: #6b7280;
            --border: #e5e7eb;
            --link: #2563eb;
            --link-hover: #1d4ed8;
        }

        *, *::before, *::after {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            background: var(--bg);
            color: var(--text-main);
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif;
            line-height: 1.65;
        }

        .page {
            flex: 1;
            max-width: 900px;
            margin: 0 auto;
            padding: 48px 20px 64px;
            width: 100%;
        }

        .hero {
            text-align: center;
            margin-bottom: 48px;
        }

        .hero-title {
            margin: 0 0 12px;
            font-size: 44px;
            line-height: 1.15;
            font-weight: 750;
            letter-spacing: -0.04em;
            color: #111827;
        }

        .hero-subtitle {
            margin: 0;
            color: var(--text-muted);
            font-size: 18px;
            line-height: 1.5;
            max-width: 560px;
            margin-left: auto;
            margin-right: auto;
        }

        .cards {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .card {
            display: block;
            padding: 32px 28px;
            background: var(--card-bg);
            border: 1px solid var(--border);
            border-radius: 16px;
            text-decoration: none;
            color: inherit;
            box-shadow: 0 8px 24px rgba(15, 23, 42, 0.05);
            transition: transform 0.15s ease, box-shadow 0.15s ease, border-color 0.15s ease;
        }

        .card:hover {
            transform: translateY(-3px);
            border-color: #cbd5e1;
            box-shadow: 0 14px 32px rgba(15, 23, 42, 0.09);
        }

        .card-icon {
            font-size: 32px;
            margin-bottom: 14px;
        }

        .card-title {
            margin: 0 0 8px;
            font-size: 22px;
            line-height: 1.25;
            font-weight: 650;
            color: #111827;
        }

        .card-description {
            margin: 0;
            color: var(--text-muted);
            font-size: 15px;
            line-height: 1.5;
        }

        @media (max-width: 640px) {
            .hero-title {
                font-size: 32px;
            }

            .hero-subtitle {
                font-size: 16px;
            }

            .cards {
                grid-template-columns: 1fr;
            }

            .page {
                padding: 32px 14px 48px;
            }
        }
    </style>
</head>
<body>

<#include "/fragments/header.ftlh">

<main class="page">
    <section class="hero">
        <h1 class="hero-title">Личная база знаний</h1>
        <p class="hero-subtitle">
            Создавайте статьи в Markdown, делитесь кейсами и решениями.
            AI-помощник поможет с саммари и объяснением терминов.
        </p>
    </section>

    <nav class="cards">
        <a href="/articles/public" class="card">
            <div class="card-icon">📄</div>
            <h2 class="card-title">Статьи</h2>
            <p class="card-description">
                Технические статьи, руководства и заметки сообщества.
            </p>
        </a>

        <a href="/cases/public" class="card">
            <div class="card-icon">🔍</div>
            <h2 class="card-title">Кейсы</h2>
            <p class="card-description">
                Практические кейсы с описанием проблемы и решением.
            </p>
        </a>
    </nav>
</main>

<#include "/fragments/footer.ftlh">

</body>
</html>
