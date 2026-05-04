<#-- templates/articles/view.ftlh -->

<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>${article.title()}</title>

    <style>
        :root {
            --bg: #f6f7f9;
            --card-bg: #ffffff;
            --text-main: #1f2937;
            --text-muted: #6b7280;
            --border: #e5e7eb;
            --link: #2563eb;
            --code-bg: #f3f4f6;
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
            line-height: 1.65;
        }

        .page {
            max-width: 920px;
            margin: 0 auto;
            padding: 40px 20px 64px;
        }

        .article {
            background: var(--card-bg);
            border: 1px solid var(--border);
            border-radius: 18px;
            padding: 42px 48px;
            box-shadow: 0 10px 30px rgba(15, 23, 42, 0.06);
        }

        .article-header {
            padding-bottom: 26px;
            margin-bottom: 34px;
            border-bottom: 1px solid var(--border);
        }

        .article-title {
            margin: 0 0 16px;
            font-size: 38px;
            line-height: 1.2;
            font-weight: 750;
            letter-spacing: -0.03em;
            color: #111827;
        }

        .article-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 10px 18px;
            color: var(--text-muted);
            font-size: 14px;
        }

        .article-meta span {
            white-space: nowrap;
        }

        .article-content {
            font-size: 18px;
        }

        .article-content h1,
        .article-content h2,
        .article-content h3,
        .article-content h4 {
            margin: 34px 0 14px;
            line-height: 1.25;
            color: #111827;
        }

        .article-content h1 {
            font-size: 32px;
        }

        .article-content h2 {
            font-size: 27px;
            padding-bottom: 8px;
            border-bottom: 1px solid var(--border);
        }

        .article-content h3 {
            font-size: 22px;
        }

        .article-content p {
            margin: 16px 0;
        }

        .article-content a {
            color: var(--link);
            text-decoration: none;
        }

        .article-content a:hover {
            text-decoration: underline;
        }

        .article-content ul,
        .article-content ol {
            padding-left: 28px;
            margin: 16px 0;
        }

        .article-content li {
            margin: 6px 0;
        }

        .article-content blockquote {
            margin: 24px 0;
            padding: 14px 20px;
            color: #4b5563;
            background: #f9fafb;
            border-left: 4px solid #d1d5db;
            border-radius: 8px;
        }

        .article-content code {
            padding: 2px 6px;
            border-radius: 6px;
            background: var(--code-bg);
            font-size: 0.92em;
            font-family: "JetBrains Mono", "Fira Code", Consolas, monospace;
        }

        .article-content pre {
            overflow-x: auto;
            margin: 24px 0;
            padding: 18px 20px;
            border-radius: 12px;
            background: #111827;
            color: #f9fafb;
            font-size: 15px;
            line-height: 1.55;
        }

        .article-content pre code {
            padding: 0;
            background: transparent;
            color: inherit;
            font-size: inherit;
        }

        .article-content img {
            display: block;
            max-width: 100%;
            height: auto;
            margin: 28px auto;
            border-radius: 14px;
            border: 1px solid var(--border);
        }

        .article-content table {
            width: 100%;
            border-collapse: collapse;
            margin: 24px 0;
            font-size: 16px;
        }

        .article-content th,
        .article-content td {
            padding: 10px 12px;
            border: 1px solid var(--border);
            text-align: left;
        }

        .article-content th {
            background: #f9fafb;
            font-weight: 650;
        }

        .empty-content {
            color: var(--text-muted);
            font-style: italic;
        }

        @media (max-width: 700px) {
            .page {
                padding: 20px 12px 40px;
            }

            .article {
                padding: 26px 22px;
                border-radius: 14px;
            }

            .article-title {
                font-size: 30px;
            }

            .article-content {
                font-size: 16px;
            }
        }
    </style>
</head>
<body>

<main class="page">
    <article class="article">
        <header class="article-header">
            <h1 class="article-title">${article.title()}</h1>

            <div class="article-meta">
                <span>Автор: ${article.owner()}</span>
                <span>Создано: ${article.createdAt()}</span>
                <span>Обновлено: ${article.updatedAt()}</span>
            </div>
        </header>

        <section class="article-content">
            <#if article.htmlText()?has_content>
                ${article.htmlText()?no_esc}
            <#else>
                <p class="empty-content">Текст статьи отсутствует.</p>
            </#if>
        </section>
    </article>
</main>

</body>
</html>