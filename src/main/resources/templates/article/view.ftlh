<#--<!DOCTYPE html>-->
<#--<html lang="ru">-->
<#--<head>-->
<#--    <meta charset="UTF-8">-->
<#--    <title>${article.title()}</title>-->

<#--    <style>-->
<#--        :root {-->
<#--            --bg: #f6f7f9;-->
<#--            --card-bg: #ffffff;-->
<#--            --text-main: #1f2937;-->
<#--            --text-muted: #6b7280;-->
<#--            --border: #e5e7eb;-->
<#--            --link: #2563eb;-->
<#--            --link-hover: #1d4ed8;-->
<#--            --code-bg: #f3f4f6;-->
<#--            --danger: #dc2626;-->
<#--            --danger-bg: #fef2f2;-->
<#--            --danger-border: #fecaca;-->
<#--            --success: #15803d;-->
<#--            --success-bg: #f0fdf4;-->
<#--            --success-border: #bbf7d0;-->
<#--            --warning: #b45309;-->
<#--            --warning-bg: #fffbeb;-->
<#--            --warning-border: #fde68a;-->
<#--        }-->

<#--        * {-->
<#--            box-sizing: border-box;-->
<#--        }-->

<#--        body {-->
<#--            margin: 0;-->
<#--            min-height: 100vh;-->
<#--            background: var(--bg);-->
<#--            color: var(--text-main);-->
<#--            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif;-->
<#--            line-height: 1.65;-->
<#--        }-->

<#--        .page {-->
<#--            max-width: 920px;-->
<#--            margin: 0 auto;-->
<#--            padding: 40px 20px 64px;-->
<#--        }-->

<#--        .article {-->
<#--            background: var(--card-bg);-->
<#--            border: 1px solid var(--border);-->
<#--            border-radius: 18px;-->
<#--            padding: 42px 48px;-->
<#--            box-shadow: 0 10px 30px rgba(15, 23, 42, 0.06);-->
<#--        }-->

<#--        .article-header {-->
<#--            padding-bottom: 26px;-->
<#--            margin-bottom: 34px;-->
<#--            border-bottom: 1px solid var(--border);-->
<#--        }-->

<#--        .article-title {-->
<#--            margin: 0 0 16px;-->
<#--            font-size: 38px;-->
<#--            line-height: 1.2;-->
<#--            font-weight: 750;-->
<#--            letter-spacing: -0.03em;-->
<#--            color: #111827;-->
<#--        }-->

<#--        .article-meta {-->
<#--            display: flex;-->
<#--            flex-wrap: wrap;-->
<#--            gap: 10px 18px;-->
<#--            color: var(--text-muted);-->
<#--            font-size: 14px;-->
<#--        }-->

<#--        .article-meta span {-->
<#--            white-space: nowrap;-->
<#--        }-->

<#--        .article-content {-->
<#--            font-size: 18px;-->
<#--        }-->

<#--        .article-content h1,-->
<#--        .article-content h2,-->
<#--        .article-content h3,-->
<#--        .article-content h4 {-->
<#--            margin: 34px 0 14px;-->
<#--            line-height: 1.25;-->
<#--            color: #111827;-->
<#--        }-->

<#--        .article-content h1 {-->
<#--            font-size: 32px;-->
<#--        }-->

<#--        .article-content h2 {-->
<#--            font-size: 27px;-->
<#--            padding-bottom: 8px;-->
<#--            border-bottom: 1px solid var(--border);-->
<#--        }-->

<#--        .article-content h3 {-->
<#--            font-size: 22px;-->
<#--        }-->

<#--        .article-content p {-->
<#--            margin: 16px 0;-->
<#--        }-->

<#--        .article-content a {-->
<#--            color: var(--link);-->
<#--            text-decoration: none;-->
<#--        }-->

<#--        .article-content a:hover {-->
<#--            text-decoration: underline;-->
<#--        }-->

<#--        .article-content ul,-->
<#--        .article-content ol {-->
<#--            padding-left: 28px;-->
<#--            margin: 16px 0;-->
<#--        }-->

<#--        .article-content li {-->
<#--            margin: 6px 0;-->
<#--        }-->

<#--        .article-content blockquote {-->
<#--            margin: 24px 0;-->
<#--            padding: 14px 20px;-->
<#--            color: #4b5563;-->
<#--            background: #f9fafb;-->
<#--            border-left: 4px solid #d1d5db;-->
<#--            border-radius: 8px;-->
<#--        }-->

<#--        .article-content code {-->
<#--            padding: 2px 6px;-->
<#--            border-radius: 6px;-->
<#--            background: var(--code-bg);-->
<#--            font-size: 0.92em;-->
<#--            font-family: "JetBrains Mono", "Fira Code", Consolas, monospace;-->
<#--        }-->

<#--        .article-content pre {-->
<#--            overflow-x: auto;-->
<#--            margin: 24px 0;-->
<#--            padding: 18px 20px;-->
<#--            border-radius: 12px;-->
<#--            background: #111827;-->
<#--            color: #f9fafb;-->
<#--            font-size: 15px;-->
<#--            line-height: 1.55;-->
<#--        }-->

<#--        .article-content pre code {-->
<#--            padding: 0;-->
<#--            background: transparent;-->
<#--            color: inherit;-->
<#--            font-size: inherit;-->
<#--        }-->

<#--        .article-content img {-->
<#--            display: block;-->
<#--            max-width: 100%;-->
<#--            height: auto;-->
<#--            margin: 28px auto;-->
<#--            border-radius: 14px;-->
<#--            border: 1px solid var(--border);-->
<#--        }-->

<#--        .article-content table {-->
<#--            width: 100%;-->
<#--            border-collapse: collapse;-->
<#--            margin: 24px 0;-->
<#--            font-size: 16px;-->
<#--        }-->

<#--        .article-content th,-->
<#--        .article-content td {-->
<#--            padding: 10px 12px;-->
<#--            border: 1px solid var(--border);-->
<#--            text-align: left;-->
<#--        }-->

<#--        .article-content th {-->
<#--            background: #f9fafb;-->
<#--            font-weight: 650;-->
<#--        }-->

<#--        .article-views {-->
<#--            color: #374151;-->
<#--            font-weight: 600;-->
<#--        }-->

<#--        .article-reactions {-->
<#--            display: flex;-->
<#--            gap: 10px;-->
<#--            margin-top: 18px;-->
<#--        }-->

<#--        .reaction-button {-->
<#--            display: inline-flex;-->
<#--            align-items: center;-->
<#--            gap: 6px;-->
<#--            min-height: 38px;-->
<#--            padding: 8px 13px;-->
<#--            border: 1px solid var(--border);-->
<#--            border-radius: 10px;-->
<#--            background: #ffffff;-->
<#--            color: var(--text-main);-->
<#--            font: inherit;-->
<#--            font-size: 14px;-->
<#--            cursor: pointer;-->
<#--        }-->

<#--        .reaction-button:hover {-->
<#--            border-color: #cbd5e1;-->
<#--            background: #f9fafb;-->
<#--        }-->

<#--        .reaction-button.active-like {-->
<#--            border-color: #bbf7d0;-->
<#--            background: #f0fdf4;-->
<#--            color: #15803d;-->
<#--        }-->

<#--        .reaction-button.active-dislike {-->
<#--            border-color: #fecaca;-->
<#--            background: #fef2f2;-->
<#--            color: #dc2626;-->
<#--        }-->

<#--        .reaction-button:disabled {-->
<#--            cursor: default;-->
<#--            opacity: 0.65;-->
<#--        }-->

<#--        .article-ai {-->
<#--            margin-top: 24px;-->
<#--            padding: 18px 20px;-->
<#--            border: 1px solid var(--border);-->
<#--            border-radius: 14px;-->
<#--            background: #f9fafb;-->
<#--        }-->

<#--        .article-ai-header {-->
<#--            display: flex;-->
<#--            justify-content: space-between;-->
<#--            align-items: flex-start;-->
<#--            gap: 14px;-->
<#--            margin-bottom: 14px;-->
<#--        }-->

<#--        .article-ai-title {-->
<#--            margin: 0;-->
<#--            font-size: 20px;-->
<#--            line-height: 1.3;-->
<#--            color: #111827;-->
<#--        }-->

<#--        .article-ai-description {-->
<#--            margin: 6px 0 0;-->
<#--            color: var(--text-muted);-->
<#--            font-size: 14px;-->
<#--            line-height: 1.45;-->
<#--        }-->

<#--        .article-ai-actions {-->
<#--            display: flex;-->
<#--            flex-wrap: wrap;-->
<#--            gap: 10px;-->
<#--        }-->

<#--        .ai-button {-->
<#--            display: inline-flex;-->
<#--            align-items: center;-->
<#--            justify-content: center;-->
<#--            min-height: 38px;-->
<#--            padding: 8px 13px;-->
<#--            border-radius: 10px;-->
<#--            border: 1px solid #bfdbfe;-->
<#--            background: #eff6ff;-->
<#--            color: var(--link);-->
<#--            font: inherit;-->
<#--            font-size: 14px;-->
<#--            cursor: pointer;-->
<#--        }-->

<#--        .ai-button:hover {-->
<#--            color: var(--link-hover);-->
<#--            border-color: #93c5fd;-->
<#--            background: #dbeafe;-->
<#--        }-->

<#--        .ai-button:disabled {-->
<#--            cursor: default;-->
<#--            opacity: 0.65;-->
<#--        }-->

<#--        .ai-selected-term {-->
<#--            display: none;-->
<#--            margin-top: 12px;-->
<#--            color: var(--text-muted);-->
<#--            font-size: 14px;-->
<#--        }-->

<#--        .ai-selected-term strong {-->
<#--            color: #111827;-->
<#--        }-->

<#--        .ai-message {-->
<#--            display: none;-->
<#--            margin-top: 14px;-->
<#--            padding: 12px 14px;-->
<#--            border-radius: 12px;-->
<#--            font-size: 14px;-->
<#--            line-height: 1.45;-->
<#--        }-->

<#--        .ai-message-error {-->
<#--            display: block;-->
<#--            color: var(--danger);-->
<#--            background: var(--danger-bg);-->
<#--            border: 1px solid var(--danger-border);-->
<#--        }-->

<#--        .ai-message-warning {-->
<#--            display: block;-->
<#--            color: var(--warning);-->
<#--            background: var(--warning-bg);-->
<#--            border: 1px solid var(--warning-border);-->
<#--        }-->

<#--        .ai-message-success {-->
<#--            display: block;-->
<#--            color: var(--success);-->
<#--            background: var(--success-bg);-->
<#--            border: 1px solid var(--success-border);-->
<#--        }-->

<#--        .ai-result {-->
<#--            display: none;-->
<#--            margin-top: 16px;-->
<#--            padding: 16px 18px;-->
<#--            border: 1px solid var(--border);-->
<#--            border-radius: 14px;-->
<#--            background: #ffffff;-->
<#--        }-->

<#--        .ai-result-title {-->
<#--            margin: 0 0 10px;-->
<#--            font-size: 17px;-->
<#--            line-height: 1.3;-->
<#--            color: #111827;-->
<#--        }-->

<#--        .ai-result-content {-->
<#--            margin: 0;-->
<#--            color: #374151;-->
<#--            white-space: pre-wrap;-->
<#--            overflow-wrap: anywhere;-->
<#--            font-size: 15px;-->
<#--            line-height: 1.6;-->
<#--        }-->

<#--        .empty-content {-->
<#--            color: var(--text-muted);-->
<#--            font-style: italic;-->
<#--        }-->

<#--        @media (max-width: 700px) {-->
<#--            .page {-->
<#--                padding: 20px 12px 40px;-->
<#--            }-->

<#--            .article {-->
<#--                padding: 26px 22px;-->
<#--                border-radius: 14px;-->
<#--            }-->

<#--            .article-title {-->
<#--                font-size: 30px;-->
<#--            }-->

<#--            .article-content {-->
<#--                font-size: 16px;-->
<#--            }-->

<#--            .article-ai-header {-->
<#--                display: block;-->
<#--            }-->

<#--            .article-ai-actions {-->
<#--                margin-top: 14px;-->
<#--            }-->
<#--        }-->
<#--    </style>-->
<#--</head>-->

<#--<body>-->
<#--<main class="page">-->
<#--    <article class="article">-->
<#--        <header class="article-header">-->
<#--            <h1 class="article-title">${article.title()}</h1>-->

<#--            <div class="article-meta">-->
<#--                <span>Автор: ${article.owner()}</span>-->
<#--                <span>Создано: ${article.createdAt()}</span>-->
<#--                <span>Обновлено: ${article.updatedAt()}</span>-->
<#--                <span class="article-views">Просмотры: ${(article.countViews())!0}</span>-->
<#--            </div>-->

<#--            <#if article.reactionsAllowed()>-->
<#--                <#assign reaction = article.reactionResponse()>-->
<#--                <#assign currentReaction = ((reaction.currentReaction())!'')?string>-->

<#--                <div class="article-reactions">-->
<#--                    <button-->
<#--                            id="likeButton"-->
<#--                            class="reaction-button <#if currentReaction == 'LIKE'>active-like</#if>"-->
<#--                            type="button">-->
<#--                        👍 <span id="likesCount">${reaction.likesCount()}</span>-->
<#--                    </button>-->

<#--                    <button-->
<#--                            id="dislikeButton"-->
<#--                            class="reaction-button <#if currentReaction == 'DISLIKE'>active-dislike</#if>"-->
<#--                            type="button">-->
<#--                        👎 <span id="dislikesCount">${reaction.dislikesCount()}</span>-->
<#--                    </button>-->
<#--                </div>-->
<#--            </#if>-->

<#--            <section class="article-ai">-->
<#--                <div class="article-ai-header">-->
<#--                    <div>-->
<#--                        <h2 class="article-ai-title">AI-помощник</h2>-->
<#--                        <p class="article-ai-description">-->
<#--                            Можно получить краткое содержание статьи или объяснить выделенный термин.-->
<#--                        </p>-->
<#--                    </div>-->

<#--                    <div class="article-ai-actions">-->
<#--                        <button id="aiSummaryButton" class="ai-button" type="button">-->
<#--                            Получить summary-->
<#--                        </button>-->

<#--                        <button id="aiExplainButton" class="ai-button" type="button">-->
<#--                            Объяснить выделенный термин-->
<#--                        </button>-->
<#--                    </div>-->
<#--                </div>-->

<#--                <div id="aiSelectedTerm" class="ai-selected-term">-->
<#--                    Выбранный термин: <strong id="aiSelectedTermText"></strong>-->
<#--                </div>-->

<#--                <div id="aiMessage" class="ai-message"></div>-->

<#--                <div id="aiResult" class="ai-result">-->
<#--                    <h3 id="aiResultTitle" class="ai-result-title"></h3>-->
<#--                    <p id="aiResultContent" class="ai-result-content"></p>-->
<#--                </div>-->
<#--            </section>-->
<#--        </header>-->

<#--        <section id="articleContent" class="article-content">-->
<#--            <#if article.htmlText()?has_content>-->
<#--                ${article.htmlText()?no_esc}-->
<#--            <#else>-->
<#--                <p class="empty-content">Текст статьи отсутствует.</p>-->
<#--            </#if>-->
<#--        </section>-->
<#--    </article>-->
<#--</main>-->

<#--<script>-->
<#--    document.addEventListener("DOMContentLoaded", function () {-->
<#--        const contentItemId = "${article.id()}";-->

<#--        const csrfHeaderName = <#if _csrf??>"${_csrf.headerName}"<#else>null</#if>;-->
<#--        const csrfToken = <#if _csrf??>"${_csrf.token}"<#else>null</#if>;-->

<#--        const articleContent = document.getElementById("articleContent");-->

<#--        const likeButton = document.getElementById("likeButton");-->
<#--        const dislikeButton = document.getElementById("dislikeButton");-->
<#--        const likesCount = document.getElementById("likesCount");-->
<#--        const dislikesCount = document.getElementById("dislikesCount");-->

<#--        const aiSummaryButton = document.getElementById("aiSummaryButton");-->
<#--        const aiExplainButton = document.getElementById("aiExplainButton");-->
<#--        const aiSelectedTerm = document.getElementById("aiSelectedTerm");-->
<#--        const aiSelectedTermText = document.getElementById("aiSelectedTermText");-->
<#--        const aiMessage = document.getElementById("aiMessage");-->
<#--        const aiResult = document.getElementById("aiResult");-->
<#--        const aiResultTitle = document.getElementById("aiResultTitle");-->
<#--        const aiResultContent = document.getElementById("aiResultContent");-->

<#--        let aiRequestInProgress = false;-->

<#--        function buildHeaders(jsonBody) {-->
<#--            const headers = {-->
<#--                "Accept": "application/json",-->
<#--                "X-Requested-With": "XMLHttpRequest"-->
<#--            };-->

<#--            if (csrfHeaderName && csrfToken) {-->
<#--                headers[csrfHeaderName] = csrfToken;-->
<#--            }-->

<#--            if (jsonBody) {-->
<#--                headers["Content-Type"] = "application/json";-->
<#--            }-->

<#--            return headers;-->
<#--        }-->

<#--        function showAiMessage(message, type) {-->
<#--            aiMessage.textContent = message || "Произошла ошибка";-->
<#--            aiMessage.className = "ai-message ai-message-" + type;-->
<#--        }-->

<#--        function clearAiMessage() {-->
<#--            aiMessage.textContent = "";-->
<#--            aiMessage.className = "ai-message";-->
<#--        }-->

<#--        function showAiResult(title, content) {-->
<#--            aiResultTitle.textContent = title;-->
<#--            aiResultContent.textContent = content;-->
<#--            aiResult.style.display = "block";-->
<#--        }-->

<#--        function hideAiResult() {-->
<#--            aiResultTitle.textContent = "";-->
<#--            aiResultContent.textContent = "";-->
<#--            aiResult.style.display = "none";-->
<#--        }-->

<#--        function setAiLoading(loading) {-->
<#--            aiRequestInProgress = loading;-->

<#--            if (aiSummaryButton) {-->
<#--                aiSummaryButton.disabled = loading;-->
<#--            }-->

<#--            if (aiExplainButton) {-->
<#--                aiExplainButton.disabled = loading;-->
<#--            }-->

<#--            if (loading) {-->
<#--                showAiMessage("AI формирует ответ, подождите...", "warning");-->
<#--            }-->
<#--        }-->

<#--        async function extractErrorMessage(response) {-->
<#--            const defaultMessage = "Не удалось выполнить AI-запрос";-->

<#--            const contentType = response.headers.get("content-type");-->

<#--            if (contentType && contentType.includes("application/json")) {-->
<#--                try {-->
<#--                    const body = await response.json();-->

<#--                    if (body.message) {-->
<#--                        return body.message;-->
<#--                    }-->

<#--                    if (body.error) {-->
<#--                        return body.error;-->
<#--                    }-->

<#--                    return defaultMessage;-->
<#--                } catch (e) {-->
<#--                    return defaultMessage;-->
<#--                }-->
<#--            }-->

<#--            try {-->
<#--                const text = await response.text();-->

<#--                if (text && text.trim().length > 0 && !text.includes("<!DOCTYPE html")) {-->
<#--                    return text;-->
<#--                }-->

<#--                return defaultMessage;-->
<#--            } catch (e) {-->
<#--                return defaultMessage;-->
<#--            }-->
<#--        }-->

<#--        function isUnauthorizedResponse(response) {-->
<#--            return response.status === 401-->
<#--                || response.status === 403-->
<#--                || (response.redirected && response.url.includes("/login"));-->
<#--        }-->

<#--        async function readJsonResponse(response) {-->
<#--            const contentType = response.headers.get("content-type");-->

<#--            if (!contentType || !contentType.includes("application/json")) {-->
<#--                throw new Error("Response is not json");-->
<#--            }-->

<#--            return await response.json();-->
<#--        }-->

<#--        function getSelectedTextInsideArticle() {-->
<#--            const selection = window.getSelection();-->

<#--            if (!selection || selection.rangeCount === 0) {-->
<#--                return "";-->
<#--            }-->

<#--            const selectedText = selection.toString().trim();-->

<#--            if (!selectedText) {-->
<#--                return "";-->
<#--            }-->

<#--            const range = selection.getRangeAt(0);-->
<#--            let container = range.commonAncestorContainer;-->

<#--            if (container.nodeType === Node.TEXT_NODE) {-->
<#--                container = container.parentNode;-->
<#--            }-->

<#--            if (!articleContent || !articleContent.contains(container)) {-->
<#--                return "";-->
<#--            }-->

<#--            return selectedText;-->
<#--        }-->

<#--        function updateSelectedTermView() {-->
<#--            const selectedText = getSelectedTextInsideArticle();-->

<#--            if (!selectedText) {-->
<#--                aiSelectedTerm.style.display = "none";-->
<#--                aiSelectedTermText.textContent = "";-->
<#--                return;-->
<#--            }-->

<#--            aiSelectedTermText.textContent = selectedText;-->
<#--            aiSelectedTerm.style.display = "block";-->
<#--        }-->

<#--        document.addEventListener("selectionchange", updateSelectedTermView);-->

<#--        async function sendAiSummaryRequest() {-->
<#--            if (aiRequestInProgress) {-->
<#--                return;-->
<#--            }-->

<#--            hideAiResult();-->
<#--            clearAiMessage();-->
<#--            setAiLoading(true);-->

<#--            try {-->
<#--                const response = await fetch("/api/content/" + contentItemId + "/ai/summary", {-->
<#--                    method: "POST",-->
<#--                    headers: buildHeaders(false),-->
<#--                    credentials: "same-origin"-->
<#--                });-->

<#--                if (isUnauthorizedResponse(response)) {-->
<#--                    hideAiResult();-->
<#--                    showAiMessage("Для использования AI-функций необходимо войти в аккаунт.", "warning");-->
<#--                    return;-->
<#--                }-->

<#--                if (!response.ok) {-->
<#--                    const message = await extractErrorMessage(response);-->
<#--                    hideAiResult();-->
<#--                    showAiMessage(message, "error");-->
<#--                    return;-->
<#--                }-->

<#--                const body = await readJsonResponse(response);-->

<#--                clearAiMessage();-->
<#--                showAiResult("Краткое содержание", body.summary || "AI вернул пустой ответ");-->
<#--            } catch (e) {-->
<#--                console.error(e);-->
<#--                hideAiResult();-->
<#--                showAiMessage("Не удалось получить краткое содержание контента", "error");-->
<#--            } finally {-->
<#--                setAiLoading(false);-->
<#--            }-->
<#--        }-->

<#--        async function sendAiExplainRequest() {-->
<#--            if (aiRequestInProgress) {-->
<#--                return;-->
<#--            }-->

<#--            const selectedText = getSelectedTextInsideArticle();-->

<#--            if (!selectedText) {-->
<#--                hideAiResult();-->
<#--                showAiMessage("Выделите термин в тексте статьи, который нужно объяснить.", "warning");-->
<#--                return;-->
<#--            }-->

<#--            hideAiResult();-->
<#--            clearAiMessage();-->
<#--            setAiLoading(true);-->

<#--            try {-->
<#--                const response = await fetch("/api/content/" + contentItemId + "/ai/explain", {-->
<#--                    method: "POST",-->
<#--                    headers: buildHeaders(true),-->
<#--                    credentials: "same-origin",-->
<#--                    body: JSON.stringify({-->
<#--                        term: selectedText-->
<#--                    })-->
<#--                });-->

<#--                if (response.status === 401 || response.status === 403) {-->
<#--                    hideAiResult()-->
<#--                    showAiMessage("Для использования AI-функций необходимо войти в аккаунт.", "warning");-->
<#--                    return;-->
<#--                }-->

<#--                if (!response.ok) {-->
<#--                    const message = await extractErrorMessage(response);-->
<#--                    hideAiResult();-->
<#--                    showAiMessage(message, "error");-->
<#--                    return;-->
<#--                }-->

<#--                const body = await readJsonResponse(response);-->

<#--                clearAiMessage();-->
<#--                showAiResult(-->
<#--                    "Объяснение термина: " + (body.term || selectedText),-->
<#--                    body.explanation || "AI вернул пустой ответ"-->
<#--                );-->
<#--            } catch (e) {-->
<#--                console.error(e);-->
<#--                hideAiResult();-->
<#--                showAiMessage("Не удалось получить объяснение термина", "error");-->
<#--            } finally {-->
<#--                setAiLoading(false);-->
<#--            }-->
<#--        }-->

<#--        if (aiSummaryButton) {-->
<#--            aiSummaryButton.addEventListener("click", sendAiSummaryRequest);-->
<#--        }-->

<#--        if (aiExplainButton) {-->
<#--            aiExplainButton.addEventListener("click", sendAiExplainRequest);-->
<#--        }-->

<#--        if (likeButton && dislikeButton && likesCount && dislikesCount) {-->
<#--            function setReactionButtonsDisabled(disabled) {-->
<#--                likeButton.disabled = disabled;-->
<#--                dislikeButton.disabled = disabled;-->
<#--            }-->

<#--            function updateReactionView(reaction) {-->
<#--                likesCount.textContent = reaction.likesCount;-->
<#--                dislikesCount.textContent = reaction.dislikesCount;-->

<#--                likeButton.classList.remove("active-like");-->
<#--                dislikeButton.classList.remove("active-dislike");-->

<#--                if (reaction.currentReaction === "LIKE") {-->
<#--                    likeButton.classList.add("active-like");-->
<#--                }-->

<#--                if (reaction.currentReaction === "DISLIKE") {-->
<#--                    dislikeButton.classList.add("active-dislike");-->
<#--                }-->
<#--            }-->

<#--            async function sendReaction(type) {-->
<#--                const url = "/api/content-items/" + contentItemId + "/reactions/" + type;-->

<#--                setReactionButtonsDisabled(true);-->

<#--                try {-->
<#--                    const response = await fetch(url, {-->
<#--                        method: "POST",-->
<#--                        headers: buildHeaders(false),-->
<#--                        credentials: "same-origin"-->
<#--                    });-->

<#--                    if (response.status === 401 || response.status === 403) {-->
<#--                        alert("Для реакции необходимо войти в аккаунт");-->
<#--                        setReactionButtonsDisabled(false);-->
<#--                        return;-->
<#--                    }-->

<#--                    if (!response.ok) {-->
<#--                        alert("Не удалось обновить реакцию");-->
<#--                        setReactionButtonsDisabled(false);-->
<#--                        return;-->
<#--                    }-->

<#--                    const reaction = await response.json();-->

<#--                    updateReactionView(reaction);-->
<#--                    setReactionButtonsDisabled(false);-->
<#--                } catch (e) {-->
<#--                    console.error(e);-->
<#--                    alert("Не удалось обновить реакцию");-->
<#--                    setReactionButtonsDisabled(false);-->
<#--                }-->
<#--            }-->

<#--            likeButton.addEventListener("click", function () {-->
<#--                sendReaction("like");-->
<#--            });-->

<#--            dislikeButton.addEventListener("click", function () {-->
<#--                sendReaction("dislike");-->
<#--            });-->
<#--        }-->
<#--    });-->
<#--    </script>-->

<#--    </body>-->
<#--    </html>-->
<#if _csrf??>
    <#assign csrfHeaderName = _csrf.headerName>
    <#assign csrfToken = _csrf.token>
<#else>
    <#assign csrfHeaderName = "">
    <#assign csrfToken = "">
</#if>
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
            --link-hover: #1d4ed8;
            --code-bg: #f3f4f6;
            --danger: #dc2626;
            --danger-bg: #fef2f2;
            --danger-border: #fecaca;
            --success: #15803d;
            --success-bg: #f0fdf4;
            --success-border: #bbf7d0;
            --warning: #b45309;
            --warning-bg: #fffbeb;
            --warning-border: #fde68a;
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

        .page-message {
            display: none;
            margin-bottom: 18px;
            padding: 12px 14px;
            border-radius: 12px;
            font-size: 14px;
            line-height: 1.45;
        }

        .page-message-error {
            display: block;
            color: var(--danger);
            background: var(--danger-bg);
            border: 1px solid var(--danger-border);
        }

        .page-message-warning {
            display: block;
            color: var(--warning);
            background: var(--warning-bg);
            border: 1px solid var(--warning-border);
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

        .article-views {
            color: #374151;
            font-weight: 600;
        }

        .article-reactions {
            display: flex;
            gap: 10px;
            margin-top: 18px;
        }

        .reaction-button {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            min-height: 38px;
            padding: 8px 13px;
            border: 1px solid var(--border);
            border-radius: 10px;
            background: #ffffff;
            color: var(--text-main);
            font: inherit;
            font-size: 14px;
            cursor: pointer;
        }

        .reaction-button:hover {
            border-color: #cbd5e1;
            background: #f9fafb;
        }

        .reaction-button.active-like {
            border-color: #bbf7d0;
            background: #f0fdf4;
            color: #15803d;
        }

        .reaction-button.active-dislike {
            border-color: #fecaca;
            background: #fef2f2;
            color: #dc2626;
        }

        .reaction-button:disabled {
            cursor: default;
            opacity: 0.65;
        }

        .article-ai {
            margin-top: 24px;
            padding: 18px 20px;
            border: 1px solid var(--border);
            border-radius: 14px;
            background: #f9fafb;
        }

        .article-ai-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 14px;
            margin-bottom: 14px;
        }

        .article-ai-title {
            margin: 0;
            font-size: 20px;
            line-height: 1.3;
            color: #111827;
        }

        .article-ai-description {
            margin: 6px 0 0;
            color: var(--text-muted);
            font-size: 14px;
            line-height: 1.45;
        }

        .article-ai-actions {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }

        .ai-button {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-height: 38px;
            padding: 8px 13px;
            border-radius: 10px;
            border: 1px solid #bfdbfe;
            background: #eff6ff;
            color: var(--link);
            font: inherit;
            font-size: 14px;
            cursor: pointer;
        }

        .ai-button:hover {
            color: var(--link-hover);
            border-color: #93c5fd;
            background: #dbeafe;
        }

        .ai-button:disabled {
            cursor: default;
            opacity: 0.65;
        }

        .ai-selected-term {
            display: none;
            margin-top: 12px;
            color: var(--text-muted);
            font-size: 14px;
        }

        .ai-selected-term strong {
            color: #111827;
        }

        .ai-message {
            display: none;
            margin-top: 14px;
            padding: 12px 14px;
            border-radius: 12px;
            font-size: 14px;
            line-height: 1.45;
        }

        .ai-message-error {
            display: block;
            color: var(--danger);
            background: var(--danger-bg);
            border: 1px solid var(--danger-border);
        }

        .ai-message-warning {
            display: block;
            color: var(--warning);
            background: var(--warning-bg);
            border: 1px solid var(--warning-border);
        }

        .ai-message-success {
            display: block;
            color: var(--success);
            background: var(--success-bg);
            border: 1px solid var(--success-border);
        }

        .ai-result {
            display: none;
            margin-top: 16px;
            padding: 16px 18px;
            border: 1px solid var(--border);
            border-radius: 14px;
            background: #ffffff;
        }

        .ai-result-title {
            margin: 0 0 10px;
            font-size: 17px;
            line-height: 1.3;
            color: #111827;
        }

        .ai-result-content {
            margin: 0;
            color: #374151;
            white-space: pre-wrap;
            overflow-wrap: anywhere;
            font-size: 15px;
            line-height: 1.6;
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

            .article-ai-header {
                display: block;
            }

            .article-ai-actions {
                margin-top: 14px;
            }
        }
    </style>
</head>

<body>
<main class="page">
    <div id="pageMessage" class="page-message"></div>

    <article class="article">
        <header class="article-header">
            <h1 class="article-title">${article.title()}</h1>

            <div class="article-meta">
                <span>Автор: ${article.owner()}</span>
                <span>Создано: ${article.createdAt()}</span>
                <span>Обновлено: ${article.updatedAt()}</span>
                <span class="article-views">Просмотры: ${(article.countViews())!0}</span>
            </div>

            <#if article.reactionsAllowed()>
                <#assign reaction = article.reactionResponse()>
                <#assign currentReaction = ((reaction.currentReaction())!'')?string>

                <div class="article-reactions">
                    <button
                            id="likeButton"
                            class="reaction-button <#if currentReaction == 'LIKE'>active-like</#if>"
                            type="button">
                        👍 <span id="likesCount">${reaction.likesCount()}</span>
                    </button>

                    <button
                            id="dislikeButton"
                            class="reaction-button <#if currentReaction == 'DISLIKE'>active-dislike</#if>"
                            type="button">
                        👎 <span id="dislikesCount">${reaction.dislikesCount()}</span>
                    </button>
                </div>
            </#if>

            <section class="article-ai">
                <div class="article-ai-header">
                    <div>
                        <h2 class="article-ai-title">AI-помощник</h2>
                        <p class="article-ai-description">
                            Можно получить краткое содержание статьи или объяснить выделенный термин.
                        </p>
                    </div>

                    <div class="article-ai-actions">
                        <button id="aiSummaryButton" class="ai-button" type="button">
                            Получить summary
                        </button>

                        <button id="aiExplainButton" class="ai-button" type="button">
                            Объяснить выделенный термин
                        </button>
                    </div>
                </div>

                <div id="aiSelectedTerm" class="ai-selected-term">
                    Выбранный термин: <strong id="aiSelectedTermText"></strong>
                </div>

                <div id="aiMessage" class="ai-message"></div>

                <div id="aiResult" class="ai-result">
                    <h3 id="aiResultTitle" class="ai-result-title"></h3>
                    <p id="aiResultContent" class="ai-result-content"></p>
                </div>
            </section>
        </header>

        <section id="articleContent" class="article-content">
            <#if article.htmlText()?has_content>
                ${article.htmlText()?no_esc}
            <#else>
                <p class="empty-content">Текст статьи отсутствует.</p>
            </#if>
        </section>
    </article>
</main>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const contentItemId = "${article.id()}";

        const csrfHeaderName = <#if csrfHeaderName?has_content>"${csrfHeaderName?js_string}"<#else>null</#if>;
        const csrfToken = <#if csrfToken?has_content>"${csrfToken?js_string}"<#else>null</#if>;

        const articleContent = document.getElementById("articleContent");

        const likeButton = document.getElementById("likeButton");
        const dislikeButton = document.getElementById("dislikeButton");
        const likesCount = document.getElementById("likesCount");
        const dislikesCount = document.getElementById("dislikesCount");

        const aiSummaryButton = document.getElementById("aiSummaryButton");
        const aiExplainButton = document.getElementById("aiExplainButton");
        const aiSelectedTerm = document.getElementById("aiSelectedTerm");
        const aiSelectedTermText = document.getElementById("aiSelectedTermText");
        const aiMessage = document.getElementById("aiMessage");
        const aiResult = document.getElementById("aiResult");
        const aiResultTitle = document.getElementById("aiResultTitle");
        const aiResultContent = document.getElementById("aiResultContent");

        let aiRequestInProgress = false;

        function buildHeaders(jsonBody) {
            const headers = {
                "Accept": "application/json",
                "X-Requested-With": "XMLHttpRequest"
            };

            if (csrfHeaderName && csrfToken) {
                headers[csrfHeaderName] = csrfToken;
            }

            if (jsonBody) {
                headers["Content-Type"] = "application/json";
            }

            return headers;
        }

        function showPageMessage(message, type) {
            const pageMessage = document.getElementById("pageMessage");

            if (!pageMessage) {
                return;
            }

            pageMessage.textContent = message || "Произошла ошибка";
            pageMessage.className = "page-message page-message-" + type;

            setTimeout(function () {
                pageMessage.textContent = "";
                pageMessage.className = "page-message";
            }, 7000);
        }

        function showAiMessage(message, type) {
            aiMessage.textContent = message || "Произошла ошибка";
            aiMessage.className = "ai-message ai-message-" + type;
        }

        function clearAiMessage() {
            aiMessage.textContent = "";
            aiMessage.className = "ai-message";
        }

        function showAiResult(title, content) {
            aiResultTitle.textContent = title;
            aiResultContent.textContent = content;
            aiResult.style.display = "block";
        }

        function hideAiResult() {
            aiResultTitle.textContent = "";
            aiResultContent.textContent = "";
            aiResult.style.display = "none";
        }

        function setAiLoading(loading) {
            aiRequestInProgress = loading;

            if (aiSummaryButton) {
                aiSummaryButton.disabled = loading;
            }

            if (aiExplainButton) {
                aiExplainButton.disabled = loading;
            }

            if (loading) {
                showAiMessage("AI формирует ответ, подождите...", "warning");
            }
        }

        async function extractErrorMessage(response) {
            const defaultMessage = "Не удалось выполнить AI-запрос";

            const contentType = response.headers.get("content-type");

            if (contentType && contentType.includes("application/json")) {
                try {
                    const body = await response.json();

                    if (body.message) {
                        return body.message;
                    }

                    if (body.error) {
                        return body.error;
                    }

                    return defaultMessage;
                } catch (e) {
                    return defaultMessage;
                }
            }

            try {
                const text = await response.text();

                if (text && text.trim().length > 0 && !text.includes("<!DOCTYPE html")) {
                    return text;
                }

                return defaultMessage;
            } catch (e) {
                return defaultMessage;
            }
        }

        function isUnauthorizedResponse(response) {
            return response.status === 401
                || response.status === 403
                || (response.redirected && response.url.includes("/auth/login"));
        }

        async function readJsonResponse(response) {
            const contentType = response.headers.get("content-type");

            if (!contentType || !contentType.includes("application/json")) {
                throw new Error("Response is not json");
            }

            return await response.json();
        }

        function getSelectedTextInsideArticle() {
            const selection = window.getSelection();

            if (!selection || selection.rangeCount === 0) {
                return "";
            }

            const selectedText = selection.toString().trim();

            if (!selectedText) {
                return "";
            }

            const range = selection.getRangeAt(0);
            let container = range.commonAncestorContainer;

            if (container.nodeType === Node.TEXT_NODE) {
                container = container.parentNode;
            }

            if (!articleContent || !articleContent.contains(container)) {
                return "";
            }

            return selectedText;
        }

        function updateSelectedTermView() {
            const selectedText = getSelectedTextInsideArticle();

            if (!selectedText) {
                aiSelectedTerm.style.display = "none";
                aiSelectedTermText.textContent = "";
                return;
            }

            aiSelectedTermText.textContent = selectedText;
            aiSelectedTerm.style.display = "block";
        }

        document.addEventListener("selectionchange", updateSelectedTermView);

        async function sendAiSummaryRequest() {
            if (aiRequestInProgress) {
                return;
            }

            hideAiResult();
            clearAiMessage();
            setAiLoading(true);

            try {
                const response = await fetch("/api/content/" + contentItemId + "/ai/summary", {
                    method: "POST",
                    headers: buildHeaders(false),
                    credentials: "same-origin"
                });

                if (isUnauthorizedResponse(response)) {
                    hideAiResult();
                    showAiMessage("Для использования AI-функций необходимо войти в аккаунт.", "warning");
                    return;
                }

                if (!response.ok) {
                    const message = await extractErrorMessage(response);
                    hideAiResult();
                    showAiMessage(message, "error");
                    return;
                }

                const body = await readJsonResponse(response);

                clearAiMessage();
                showAiResult("Краткое содержание", body.summary || "AI вернул пустой ответ");
            } catch (e) {
                console.error(e);
                hideAiResult();
                showAiMessage("Не удалось получить краткое содержание контента", "error");
            } finally {
                setAiLoading(false);
            }
        }

        async function sendAiExplainRequest() {
            if (aiRequestInProgress) {
                return;
            }

            const selectedText = getSelectedTextInsideArticle();

            if (!selectedText) {
                hideAiResult();
                showAiMessage("Выделите термин в тексте статьи, который нужно объяснить.", "warning");
                return;
            }

            hideAiResult();
            clearAiMessage();
            setAiLoading(true);

            try {
                const response = await fetch("/api/content/" + contentItemId + "/ai/explain", {
                    method: "POST",
                    headers: buildHeaders(true),
                    credentials: "same-origin",
                    body: JSON.stringify({
                        term: selectedText
                    })
                });

                if (isUnauthorizedResponse(response)) {
                    hideAiResult();
                    showAiMessage("Для использования AI-функций необходимо войти в аккаунт.", "warning");
                    return;
                }

                if (!response.ok) {
                    const message = await extractErrorMessage(response);
                    hideAiResult();
                    showAiMessage(message, "error");
                    return;
                }

                const body = await readJsonResponse(response);

                clearAiMessage();
                showAiResult(
                    "Объяснение термина: " + (body.term || selectedText),
                    body.explanation || "AI вернул пустой ответ"
                );
            } catch (e) {
                console.error(e);
                hideAiResult();
                showAiMessage("Не удалось получить объяснение термина", "error");
            } finally {
                setAiLoading(false);
            }
        }

        if (aiSummaryButton) {
            aiSummaryButton.addEventListener("click", sendAiSummaryRequest);
        }

        if (aiExplainButton) {
            aiExplainButton.addEventListener("click", sendAiExplainRequest);
        }

        if (likeButton && dislikeButton && likesCount && dislikesCount) {
            function setReactionButtonsDisabled(disabled) {
                likeButton.disabled = disabled;
                dislikeButton.disabled = disabled;
            }

            function updateReactionView(reaction) {
                likesCount.textContent = reaction.likesCount;
                dislikesCount.textContent = reaction.dislikesCount;

                likeButton.classList.remove("active-like");
                dislikeButton.classList.remove("active-dislike");

                if (reaction.currentReaction === "LIKE") {
                    likeButton.classList.add("active-like");
                }

                if (reaction.currentReaction === "DISLIKE") {
                    dislikeButton.classList.add("active-dislike");
                }
            }

            async function sendReaction(type) {
                const url = "/api/content-items/" + contentItemId + "/reactions/" + type;

                setReactionButtonsDisabled(true);

                try {
                    const response = await fetch(url, {
                        method: "POST",
                        headers: buildHeaders(false),
                        credentials: "same-origin"
                    });

                    if (response.status === 401 || (response.redirected && response.url.includes("/auth/login"))) {
                        showPageMessage("Для реакции необходимо войти в аккаунт.", "warning");
                        setReactionButtonsDisabled(false);
                        return;
                    }

                    if (response.status === 403) {
                        showPageMessage("Недостаточно прав для выполнения действия.", "error");
                        setReactionButtonsDisabled(false);
                        return;
                    }

                    if (!response.ok) {
                        showPageMessage("Не удалось обновить реакцию.", "error");
                        setReactionButtonsDisabled(false);
                        return;
                    }

                    const reaction = await response.json();

                    updateReactionView(reaction);
                    setReactionButtonsDisabled(false);
                } catch (e) {
                    console.error(e);
                    showPageMessage("Не удалось обновить реакцию.", "error");
                    setReactionButtonsDisabled(false);
                }
            }

            likeButton.addEventListener("click", function () {
                sendReaction("like");
            });

            dislikeButton.addEventListener("click", function () {
                sendReaction("dislike");
            });
        }
    });
    </script>

    </body>
    </html>