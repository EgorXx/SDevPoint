<#-- templates/case/view.ftlh -->

<#assign currentCase = .vars["case"]>

<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>${currentCase.title()}</title>

    <style>
        :root {
            --bg: #f6f7f9;
            --card-bg: #ffffff;
            --text-main: #1f2937;
            --text-muted: #6b7280;
            --border: #e5e7eb;
            --link: #2563eb;
            --warning-bg: #fff7ed;
            --warning-border: #fed7aa;
            --warning-text: #9a3412;
            --solution-bg: #f8fafc;
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
            max-width: 940px;
            margin: 0 auto;
            padding: 40px 20px 64px;
        }

        .case-card {
            background: var(--card-bg);
            border: 1px solid var(--border);
            border-radius: 18px;
            padding: 42px 48px;
            box-shadow: 0 10px 30px rgba(15, 23, 42, 0.06);
        }

        .case-header {
            padding-bottom: 26px;
            margin-bottom: 34px;
            border-bottom: 1px solid var(--border);
        }

        .case-title {
            margin: 0 0 16px;
            font-size: 38px;
            line-height: 1.2;
            font-weight: 750;
            letter-spacing: -0.03em;
            color: #111827;
        }

        .case-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 10px 18px;
            color: var(--text-muted);
            font-size: 14px;
        }

        .case-meta span {
            white-space: nowrap;
        }

        .section {
            margin-top: 34px;
        }

        .section:first-of-type {
            margin-top: 0;
        }

        .section-title {
            margin: 0 0 18px;
            font-size: 26px;
            line-height: 1.25;
            color: #111827;
        }

        .content {
            font-size: 18px;
        }

        .content h1,
        .content h2,
        .content h3,
        .content h4 {
            margin: 32px 0 14px;
            line-height: 1.25;
            color: #111827;
        }

        .content h1 {
            font-size: 32px;
        }

        .content h2 {
            font-size: 27px;
            padding-bottom: 8px;
            border-bottom: 1px solid var(--border);
        }

        .content h3 {
            font-size: 22px;
        }

        .content p {
            margin: 16px 0;
        }

        .content a {
            color: var(--link);
            text-decoration: none;
        }

        .content a:hover {
            text-decoration: underline;
        }

        .content ul,
        .content ol {
            padding-left: 28px;
            margin: 16px 0;
        }

        .content li {
            margin: 6px 0;
        }

        .content blockquote {
            margin: 24px 0;
            padding: 14px 20px;
            color: #4b5563;
            background: #f9fafb;
            border-left: 4px solid #d1d5db;
            border-radius: 8px;
        }

        .content code {
            padding: 2px 6px;
            border-radius: 6px;
            background: #f3f4f6;
            font-size: 0.92em;
            font-family: "JetBrains Mono", "Fira Code", Consolas, monospace;
        }

        .content pre {
            overflow-x: auto;
            margin: 24px 0;
            padding: 18px 20px;
            border-radius: 12px;
            background: #111827;
            color: #f9fafb;
            font-size: 15px;
            line-height: 1.55;
        }

        .content pre code {
            padding: 0;
            background: transparent;
            color: inherit;
            font-size: inherit;
        }

        .content img {
            display: block;
            max-width: 100%;
            height: auto;
            margin: 28px auto;
            border-radius: 14px;
            border: 1px solid var(--border);
        }

        .content table {
            width: 100%;
            border-collapse: collapse;
            margin: 24px 0;
            font-size: 16px;
        }

        .content th,
        .content td {
            padding: 10px 12px;
            border: 1px solid var(--border);
            text-align: left;
        }

        .content th {
            background: #f9fafb;
            font-weight: 650;
        }

        .case-views {
            color: #374151;
            font-weight: 600;
        }

        .empty-solution {
            margin-top: 18px;
            padding: 18px 20px;
            border: 1px solid var(--warning-border);
            border-radius: 14px;
            background: var(--warning-bg);
            color: var(--warning-text);
            font-size: 16px;
        }

        .solution-preview {
            margin-top: 18px;
            padding: 22px;
            border: 1px solid var(--border);
            border-radius: 14px;
            background: var(--solution-bg);
        }

        .solution-actions {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-top: 18px;
        }

        .solution-button {
            border: none;
            border-radius: 10px;
            padding: 10px 16px;
            background: #2563eb;
            color: #ffffff;
            font-size: 15px;
            cursor: pointer;
        }

        .solution-button:hover {
            background: #1d4ed8;
        }

        .solution-hint {
            color: var(--text-muted);
            font-size: 14px;
        }

        .solution-content {
            margin-top: 22px;
            padding-top: 22px;
            border-top: 1px solid var(--border);
        }

        .empty-content {
            color: var(--text-muted);
            font-style: italic;
        }

        @media (max-width: 700px) {
            .page {
                padding: 20px 12px 40px;
            }

            .case-card {
                padding: 26px 22px;
                border-radius: 14px;
            }

            .case-title {
                font-size: 30px;
            }

            .content {
                font-size: 16px;
            }

            .section-title {
                font-size: 23px;
            }
        }
    </style>
</head>
<body>

<main class="page">
    <article class="case-card">
        <header class="case-header">
            <h1 class="case-title">${currentCase.title()}</h1>

            <div class="case-meta">
                <span>Автор: ${currentCase.owner()}</span>
                <span>Создано: ${currentCase.createdAt()}</span>
                <span>Обновлено: ${currentCase.updatedAt()}</span>
                <span class="case-views">Просмотры: ${(currentCase.countViews())!0}</span>
            </div>
        </header>

        <section class="section">
            <h2 class="section-title">Описание кейса</h2>

            <div class="content">
                <#if currentCase.htmlTextDescription()?has_content>
                    ${currentCase.htmlTextDescription()?no_esc}
                <#else>
                    <p class="empty-content">Описание кейса отсутствует.</p>
                </#if>
            </div>
        </section>

        <section class="section">
            <h2 class="section-title">Решение</h2>

            <#if !currentCase.hasSolution()>
                <div class="empty-solution">
                    Решения этого кейса пока что нет.
                </div>
            <#else>
                <div class="solution-preview">
                    <div class="solution-actions">
                        <button
                                id="toggleSolutionButton"
                                class="solution-button"
                                type="button"
                                aria-expanded="false"
                                aria-controls="solutionContent">
                            Показать решение
                        </button>

                        <span class="solution-hint">
                            Решение скрыто, чтобы можно было сначала попробовать решить кейс самостоятельно.
                        </span>
                    </div>

                    <div id="solutionContent" class="solution-content" hidden>
                        <div class="content">
                            <#if currentCase.htmlTextSolution()?has_content>
                                ${currentCase.htmlTextSolution()?no_esc}
                            <#else>
                                <p class="empty-content">Текст решения отсутствует.</p>
                            </#if>
                        </div>
                    </div>
                </div>
            </#if>
        </section>
    </article>
</main>

<script>
    const toggleSolutionButton = document.getElementById("toggleSolutionButton");
    const solutionContent = document.getElementById("solutionContent");

    if (toggleSolutionButton && solutionContent) {
        toggleSolutionButton.addEventListener("click", function () {
            const isHidden = solutionContent.hidden;

            solutionContent.hidden = !isHidden;
            toggleSolutionButton.setAttribute("aria-expanded", String(isHidden));
            toggleSolutionButton.textContent = isHidden
                ? "Скрыть решение"
                : "Показать решение";
        });
    }
</script>

</body>
</html>