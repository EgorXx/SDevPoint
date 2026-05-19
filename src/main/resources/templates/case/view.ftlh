<#--<#assign currentCase = .vars["case"]>-->

<#--<!DOCTYPE html>-->
<#--<html lang="ru">-->
<#--<head>-->
<#--    <meta charset="UTF-8">-->
<#--    <title>${currentCase.title()}</title>-->

<#--    <#if _csrf??>-->
<#--        <meta name="_csrf" content="${_csrf.token}">-->
<#--        <meta name="_csrf_header" content="${_csrf.headerName}">-->
<#--    </#if>-->

<#--    <style>-->
<#--        :root {-->
<#--            --bg: #f6f7f9;-->
<#--            --card-bg: #ffffff;-->
<#--            --text-main: #1f2937;-->
<#--            --text-muted: #6b7280;-->
<#--            --border: #e5e7eb;-->
<#--            --link: #2563eb;-->
<#--            --link-hover: #1d4ed8;-->
<#--            --warning-bg: #fff7ed;-->
<#--            --warning-border: #fed7aa;-->
<#--            --warning-text: #9a3412;-->
<#--            --solution-bg: #f8fafc;-->
<#--            --danger: #dc2626;-->
<#--            --danger-bg: #fef2f2;-->
<#--            --danger-border: #fecaca;-->
<#--            --success: #15803d;-->
<#--            --success-bg: #f0fdf4;-->
<#--            --success-border: #bbf7d0;-->
<#--            --ai-warning: #b45309;-->
<#--            --ai-warning-bg: #fffbeb;-->
<#--            --ai-warning-border: #fde68a;-->
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
<#--            max-width: 940px;-->
<#--            margin: 0 auto;-->
<#--            padding: 40px 20px 64px;-->
<#--        }-->

<#--        .case-card {-->
<#--            background: var(--card-bg);-->
<#--            border: 1px solid var(--border);-->
<#--            border-radius: 18px;-->
<#--            padding: 42px 48px;-->
<#--            box-shadow: 0 10px 30px rgba(15, 23, 42, 0.06);-->
<#--        }-->

<#--        .case-header {-->
<#--            padding-bottom: 26px;-->
<#--            margin-bottom: 34px;-->
<#--            border-bottom: 1px solid var(--border);-->
<#--        }-->

<#--        .case-title {-->
<#--            margin: 0 0 16px;-->
<#--            font-size: 38px;-->
<#--            line-height: 1.2;-->
<#--            font-weight: 750;-->
<#--            letter-spacing: -0.03em;-->
<#--            color: #111827;-->
<#--        }-->

<#--        .case-meta {-->
<#--            display: flex;-->
<#--            flex-wrap: wrap;-->
<#--            gap: 10px 18px;-->
<#--            color: var(--text-muted);-->
<#--            font-size: 14px;-->
<#--        }-->

<#--        .case-meta span {-->
<#--            white-space: nowrap;-->
<#--        }-->

<#--        .section {-->
<#--            margin-top: 34px;-->
<#--        }-->

<#--        .section:first-of-type {-->
<#--            margin-top: 0;-->
<#--        }-->

<#--        .section-title {-->
<#--            margin: 0 0 18px;-->
<#--            font-size: 26px;-->
<#--            line-height: 1.25;-->
<#--            color: #111827;-->
<#--        }-->

<#--        .content {-->
<#--            font-size: 18px;-->
<#--        }-->

<#--        .content h1,-->
<#--        .content h2,-->
<#--        .content h3,-->
<#--        .content h4 {-->
<#--            margin: 32px 0 14px;-->
<#--            line-height: 1.25;-->
<#--            color: #111827;-->
<#--        }-->

<#--        .content h1 {-->
<#--            font-size: 32px;-->
<#--        }-->

<#--        .content h2 {-->
<#--            font-size: 27px;-->
<#--            padding-bottom: 8px;-->
<#--            border-bottom: 1px solid var(--border);-->
<#--        }-->

<#--        .content h3 {-->
<#--            font-size: 22px;-->
<#--        }-->

<#--        .content p {-->
<#--            margin: 16px 0;-->
<#--        }-->

<#--        .content a {-->
<#--            color: var(--link);-->
<#--            text-decoration: none;-->
<#--        }-->

<#--        .content a:hover {-->
<#--            text-decoration: underline;-->
<#--        }-->

<#--        .content ul,-->
<#--        .content ol {-->
<#--            padding-left: 28px;-->
<#--            margin: 16px 0;-->
<#--        }-->

<#--        .content li {-->
<#--            margin: 6px 0;-->
<#--        }-->

<#--        .content blockquote {-->
<#--            margin: 24px 0;-->
<#--            padding: 14px 20px;-->
<#--            color: #4b5563;-->
<#--            background: #f9fafb;-->
<#--            border-left: 4px solid #d1d5db;-->
<#--            border-radius: 8px;-->
<#--        }-->

<#--        .content code {-->
<#--            padding: 2px 6px;-->
<#--            border-radius: 6px;-->
<#--            background: #f3f4f6;-->
<#--            font-size: 0.92em;-->
<#--            font-family: "JetBrains Mono", "Fira Code", Consolas, monospace;-->
<#--        }-->

<#--        .content pre {-->
<#--            overflow-x: auto;-->
<#--            margin: 24px 0;-->
<#--            padding: 18px 20px;-->
<#--            border-radius: 12px;-->
<#--            background: #111827;-->
<#--            color: #f9fafb;-->
<#--            font-size: 15px;-->
<#--            line-height: 1.55;-->
<#--        }-->

<#--        .content pre code {-->
<#--            padding: 0;-->
<#--            background: transparent;-->
<#--            color: inherit;-->
<#--            font-size: inherit;-->
<#--        }-->

<#--        .content img {-->
<#--            display: block;-->
<#--            max-width: 100%;-->
<#--            height: auto;-->
<#--            margin: 28px auto;-->
<#--            border-radius: 14px;-->
<#--            border: 1px solid var(--border);-->
<#--        }-->

<#--        .content table {-->
<#--            width: 100%;-->
<#--            border-collapse: collapse;-->
<#--            margin: 24px 0;-->
<#--            font-size: 16px;-->
<#--        }-->

<#--        .content th,-->
<#--        .content td {-->
<#--            padding: 10px 12px;-->
<#--            border: 1px solid var(--border);-->
<#--            text-align: left;-->
<#--        }-->

<#--        .content th {-->
<#--            background: #f9fafb;-->
<#--            font-weight: 650;-->
<#--        }-->

<#--        .case-views {-->
<#--            color: #374151;-->
<#--            font-weight: 600;-->
<#--        }-->

<#--        .empty-solution {-->
<#--            margin-top: 18px;-->
<#--            padding: 18px 20px;-->
<#--            border: 1px solid var(--warning-border);-->
<#--            border-radius: 14px;-->
<#--            background: var(--warning-bg);-->
<#--            color: var(--warning-text);-->
<#--            font-size: 16px;-->
<#--        }-->

<#--        .solution-preview {-->
<#--            margin-top: 18px;-->
<#--            padding: 22px;-->
<#--            border: 1px solid var(--border);-->
<#--            border-radius: 14px;-->
<#--            background: var(--solution-bg);-->
<#--        }-->

<#--        .solution-actions {-->
<#--            display: flex;-->
<#--            align-items: center;-->
<#--            gap: 12px;-->
<#--            margin-top: 18px;-->
<#--        }-->

<#--        .solution-button {-->
<#--            border: none;-->
<#--            border-radius: 10px;-->
<#--            padding: 10px 16px;-->
<#--            background: #2563eb;-->
<#--            color: #ffffff;-->
<#--            font-size: 15px;-->
<#--            cursor: pointer;-->
<#--        }-->

<#--        .solution-button:hover {-->
<#--            background: #1d4ed8;-->
<#--        }-->

<#--        .solution-hint {-->
<#--            color: var(--text-muted);-->
<#--            font-size: 14px;-->
<#--        }-->

<#--        .solution-content {-->
<#--            margin-top: 22px;-->
<#--            padding-top: 22px;-->
<#--            border-top: 1px solid var(--border);-->
<#--        }-->

<#--        .case-reactions {-->
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

<#--        .case-ai {-->
<#--            margin-top: 24px;-->
<#--            padding: 18px 20px;-->
<#--            border: 1px solid var(--border);-->
<#--            border-radius: 14px;-->
<#--            background: #f9fafb;-->
<#--        }-->

<#--        .case-ai-header {-->
<#--            display: flex;-->
<#--            justify-content: space-between;-->
<#--            align-items: flex-start;-->
<#--            gap: 14px;-->
<#--            margin-bottom: 14px;-->
<#--        }-->

<#--        .case-ai-title {-->
<#--            margin: 0;-->
<#--            font-size: 20px;-->
<#--            line-height: 1.3;-->
<#--            color: #111827;-->
<#--        }-->

<#--        .case-ai-description {-->
<#--            margin: 6px 0 0;-->
<#--            color: var(--text-muted);-->
<#--            font-size: 14px;-->
<#--            line-height: 1.45;-->
<#--        }-->

<#--        .case-ai-actions {-->
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
<#--            color: var(--ai-warning);-->
<#--            background: var(--ai-warning-bg);-->
<#--            border: 1px solid var(--ai-warning-border);-->
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

<#--        .page-message {-->
<#--            display: none;-->
<#--            margin-bottom: 18px;-->
<#--            padding: 12px 14px;-->
<#--            border-radius: 12px;-->
<#--            font-size: 14px;-->
<#--            line-height: 1.45;-->
<#--        }-->

<#--        .page-message-error {-->
<#--            display: block;-->
<#--            color: var(--danger);-->
<#--            background: var(--danger-bg);-->
<#--            border: 1px solid var(--danger-border);-->
<#--        }-->

<#--        .page-message-warning {-->
<#--            display: block;-->
<#--            color: var(--ai-warning);-->
<#--            background: var(--ai-warning-bg);-->
<#--            border: 1px solid var(--ai-warning-border);-->
<#--        }-->

<#--        @media (max-width: 700px) {-->
<#--            .page {-->
<#--                padding: 20px 12px 40px;-->
<#--            }-->

<#--            .case-card {-->
<#--                padding: 26px 22px;-->
<#--                border-radius: 14px;-->
<#--            }-->

<#--            .case-title {-->
<#--                font-size: 30px;-->
<#--            }-->

<#--            .content {-->
<#--                font-size: 16px;-->
<#--            }-->

<#--            .section-title {-->
<#--                font-size: 23px;-->
<#--            }-->

<#--            .case-ai-header {-->
<#--                display: block;-->
<#--            }-->

<#--            .case-ai-actions {-->
<#--                margin-top: 14px;-->
<#--            }-->
<#--        }-->
<#--    </style>-->
<#--</head>-->
<#--<body>-->
<#--<#include "/fragments/header.ftlh">-->

<#--<main class="page">-->
<#--    <div id="pageMessage" class="page-message"></div>-->

<#--    <article class="case-card">-->
<#--        <header class="case-header">-->
<#--            <h1 class="case-title">${currentCase.title()}</h1>-->

<#--            <div class="case-meta">-->
<#--                <span>Автор: ${currentCase.owner()}</span>-->
<#--                <span>Создано: ${currentCase.createdAt()}</span>-->
<#--                <span>Обновлено: ${currentCase.updatedAt()}</span>-->
<#--                <span class="case-views">Просмотры: ${(currentCase.countViews())!0}</span>-->
<#--            </div>-->

<#--            <#if currentCase.reactionsAllowed()>-->
<#--                <#assign reaction = currentCase.reactionResponse()>-->
<#--                <#assign currentReaction = ((reaction.currentReaction())!'')?string>-->

<#--                <div class="case-reactions">-->
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

<#--            <section class="case-ai">-->
<#--                <div class="case-ai-header">-->
<#--                    <div>-->
<#--                        <h2 class="case-ai-title">AI-помощник</h2>-->
<#--                        <p class="case-ai-description">-->
<#--                            Можно получить краткое содержание кейса или объяснить выделенный термин.-->
<#--                        </p>-->
<#--                    </div>-->

<#--                    <div class="case-ai-actions">-->
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

<#--        <div id="caseAiContent">-->
<#--            <section class="section">-->
<#--                <h2 class="section-title">Описание кейса</h2>-->

<#--                <div class="content">-->
<#--                    <#if currentCase.htmlTextDescription()?has_content>-->
<#--                        ${currentCase.htmlTextDescription()?no_esc}-->
<#--                    <#else>-->
<#--                        <p class="empty-content">Описание кейса отсутствует.</p>-->
<#--                    </#if>-->
<#--                </div>-->
<#--            </section>-->

<#--            <section class="section">-->
<#--                <h2 class="section-title">Решение</h2>-->

<#--                <#if !currentCase.hasSolution()>-->
<#--                    <div class="empty-solution">-->
<#--                        Решения этого кейса пока что нет.-->
<#--                    </div>-->
<#--                <#else>-->
<#--                    <div class="solution-preview">-->
<#--                        <div class="solution-actions">-->
<#--                            <button-->
<#--                                    id="toggleSolutionButton"-->
<#--                                    class="solution-button"-->
<#--                                    type="button"-->
<#--                                    aria-expanded="false"-->
<#--                                    aria-controls="solutionContent">-->
<#--                                Показать решение-->
<#--                            </button>-->

<#--                            <span class="solution-hint">-->
<#--                                Решение скрыто, чтобы можно было сначала попробовать решить кейс самостоятельно.-->
<#--                            </span>-->
<#--                        </div>-->

<#--                        <div id="solutionContent" class="solution-content" hidden>-->
<#--                            <div class="content">-->
<#--                                <#if currentCase.htmlTextSolution()?has_content>-->
<#--                                    ${currentCase.htmlTextSolution()?no_esc}-->
<#--                                <#else>-->
<#--                                    <p class="empty-content">Текст решения отсутствует.</p>-->
<#--                                </#if>-->
<#--                            </div>-->
<#--                        </div>-->
<#--                    </div>-->
<#--                </#if>-->
<#--            </section>-->
<#--        </div>-->
<#--    </article>-->
<#--</main>-->

<#--<script>-->
<#--    document.addEventListener("DOMContentLoaded", function () {-->
<#--        initSolutionToggle();-->
<#--        initReactions();-->
<#--        initAi();-->
<#--    });-->

<#--    function getCsrfData() {-->
<#--        const csrfTokenMeta = document.querySelector("meta[name='_csrf']");-->
<#--        const csrfHeaderMeta = document.querySelector("meta[name='_csrf_header']");-->

<#--        return {-->
<#--            token: csrfTokenMeta ? csrfTokenMeta.getAttribute("content") : null,-->
<#--            headerName: csrfHeaderMeta ? csrfHeaderMeta.getAttribute("content") : null-->
<#--        };-->
<#--    }-->

<#--    function buildHeaders(jsonBody) {-->
<#--        const csrf = getCsrfData();-->

<#--        const headers = {-->
<#--            "Accept": "application/json",-->
<#--            "X-Requested-With": "XMLHttpRequest"-->
<#--        };-->

<#--        if (csrf.headerName && csrf.token) {-->
<#--            headers[csrf.headerName] = csrf.token;-->
<#--        }-->

<#--        if (jsonBody) {-->
<#--            headers["Content-Type"] = "application/json";-->
<#--        }-->

<#--        return headers;-->
<#--    }-->

<#--    function initSolutionToggle() {-->
<#--        const toggleSolutionButton = document.getElementById("toggleSolutionButton");-->
<#--        const solutionContent = document.getElementById("solutionContent");-->

<#--        if (!toggleSolutionButton || !solutionContent) {-->
<#--            return;-->
<#--        }-->

<#--        toggleSolutionButton.addEventListener("click", function () {-->
<#--            const isHidden = solutionContent.hidden;-->

<#--            solutionContent.hidden = !isHidden;-->
<#--            toggleSolutionButton.setAttribute("aria-expanded", String(isHidden));-->
<#--            toggleSolutionButton.textContent = isHidden-->
<#--                ? "Скрыть решение"-->
<#--                : "Показать решение";-->
<#--        });-->
<#--    }-->

<#--    function showPageMessage(message, type) {-->
<#--        const pageMessage = document.getElementById("pageMessage");-->

<#--        if (!pageMessage) {-->
<#--            return;-->
<#--        }-->

<#--        pageMessage.textContent = message || "Произошла ошибка";-->
<#--        pageMessage.className = "page-message page-message-" + type;-->

<#--        setTimeout(function () {-->
<#--            pageMessage.textContent = "";-->
<#--            pageMessage.className = "page-message";-->
<#--        }, 7000);-->
<#--    }-->

<#--    function initReactions() {-->
<#--        const contentItemId = "${currentCase.contentId()}";-->

<#--        const likeButton = document.getElementById("likeButton");-->
<#--        const dislikeButton = document.getElementById("dislikeButton");-->
<#--        const likesCount = document.getElementById("likesCount");-->
<#--        const dislikesCount = document.getElementById("dislikesCount");-->

<#--        if (!likeButton || !dislikeButton || !likesCount || !dislikesCount) {-->
<#--            return;-->
<#--        }-->

<#--        function setButtonsDisabled(disabled) {-->
<#--            likeButton.disabled = disabled;-->
<#--            dislikeButton.disabled = disabled;-->
<#--        }-->

<#--        function updateReactionView(reaction) {-->
<#--            likesCount.textContent = reaction.likesCount;-->
<#--            dislikesCount.textContent = reaction.dislikesCount;-->

<#--            likeButton.classList.remove("active-like");-->
<#--            dislikeButton.classList.remove("active-dislike");-->

<#--            if (reaction.currentReaction === "LIKE") {-->
<#--                likeButton.classList.add("active-like");-->
<#--            }-->

<#--            if (reaction.currentReaction === "DISLIKE") {-->
<#--                dislikeButton.classList.add("active-dislike");-->
<#--            }-->
<#--        }-->

<#--        async function sendReaction(type) {-->
<#--            const url = "/api/content-items/" + contentItemId + "/reactions/" + type;-->

<#--            setButtonsDisabled(true);-->

<#--            try {-->
<#--                const response = await fetch(url, {-->
<#--                    method: "POST",-->
<#--                    headers: buildHeaders(false),-->
<#--                    credentials: "same-origin"-->
<#--                });-->

<#--                if (response.status === 401) {-->
<#--                    showPageMessage("Для реакции необходимо войти в аккаунт.", "warning");-->
<#--                    setButtonsDisabled(false);-->
<#--                    return;-->
<#--                }-->

<#--                if (response.status === 403) {-->
<#--                    showPageMessage("Недостаточно прав для выполнения действия.", "error");-->
<#--                    setButtonsDisabled(false);-->
<#--                    return;-->
<#--                }-->

<#--                if (!response.ok) {-->
<#--                    showPageMessage("Не удалось обновить реакцию.", "error");-->
<#--                    setButtonsDisabled(false);-->
<#--                    return;-->
<#--                }-->

<#--                const reaction = await response.json();-->

<#--                updateReactionView(reaction);-->
<#--                setButtonsDisabled(false);-->
<#--            } catch (e) {-->
<#--                console.error(e);-->
<#--                showPageMessage("Не удалось обновить реакцию.", "error");-->
<#--                setButtonsDisabled(false);-->
<#--            }-->
<#--        }-->

<#--        likeButton.addEventListener("click", function () {-->
<#--            sendReaction("like");-->
<#--        });-->

<#--        dislikeButton.addEventListener("click", function () {-->
<#--            sendReaction("dislike");-->
<#--        });-->
<#--    }-->

<#--    function initAi() {-->
<#--        const contentItemId = "${currentCase.contentId()}";-->

<#--        const caseAiContent = document.getElementById("caseAiContent");-->

<#--        const aiSummaryButton = document.getElementById("aiSummaryButton");-->
<#--        const aiExplainButton = document.getElementById("aiExplainButton");-->
<#--        const aiSelectedTerm = document.getElementById("aiSelectedTerm");-->
<#--        const aiSelectedTermText = document.getElementById("aiSelectedTermText");-->
<#--        const aiMessage = document.getElementById("aiMessage");-->
<#--        const aiResult = document.getElementById("aiResult");-->
<#--        const aiResultTitle = document.getElementById("aiResultTitle");-->
<#--        const aiResultContent = document.getElementById("aiResultContent");-->

<#--        if (!caseAiContent-->
<#--            || !aiSummaryButton-->
<#--            || !aiExplainButton-->
<#--            || !aiSelectedTerm-->
<#--            || !aiSelectedTermText-->
<#--            || !aiMessage-->
<#--            || !aiResult-->
<#--            || !aiResultTitle-->
<#--            || !aiResultContent) {-->
<#--            return;-->
<#--        }-->

<#--        let aiRequestInProgress = false;-->

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
<#--            aiSummaryButton.disabled = loading;-->
<#--            aiExplainButton.disabled = loading;-->

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
<#--                || response.status === 403;-->
<#--        }-->

<#--        async function readJsonResponse(response) {-->
<#--            const contentType = response.headers.get("content-type");-->

<#--            if (!contentType || !contentType.includes("application/json")) {-->
<#--                throw new Error("Response is not json");-->
<#--            }-->

<#--            return await response.json();-->
<#--        }-->

<#--        function getSelectedTextInsideCase() {-->
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

<#--            if (!caseAiContent.contains(container)) {-->
<#--                return "";-->
<#--            }-->

<#--            return selectedText;-->
<#--        }-->

<#--        function updateSelectedTermView() {-->
<#--            const selectedText = getSelectedTextInsideCase();-->

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
<#--                showAiMessage("Не удалось получить краткое содержание кейса", "error");-->
<#--            } finally {-->
<#--                setAiLoading(false);-->
<#--            }-->
<#--        }-->

<#--        async function sendAiExplainRequest() {-->
<#--            if (aiRequestInProgress) {-->
<#--                return;-->
<#--            }-->

<#--            const selectedText = getSelectedTextInsideCase();-->

<#--            if (!selectedText) {-->
<#--                hideAiResult();-->
<#--                showAiMessage("Выделите термин в описании или решении кейса, который нужно объяснить.", "warning");-->
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

<#--        aiSummaryButton.addEventListener("click", sendAiSummaryRequest);-->
<#--        aiExplainButton.addEventListener("click", sendAiExplainRequest);-->
<#--    }-->
<#--    </script>-->

<#--    <#include "/fragments/footer.ftlh">-->

<#--    </body>-->
<#--    </html>-->
<#assign currentCase = .vars["case"]>

<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>${currentCase.title()}</title>

    <#if _csrf??>
        <meta name="_csrf" content="${_csrf.token}">
        <meta name="_csrf_header" content="${_csrf.headerName}">
    </#if>

    <style>
        :root {
            --bg: #f6f7f9;
            --card-bg: #ffffff;
            --text-main: #1f2937;
            --text-muted: #6b7280;
            --border: #e5e7eb;
            --link: #2563eb;
            --link-hover: #1d4ed8;
            --warning-bg: #fff7ed;
            --warning-border: #fed7aa;
            --warning-text: #9a3412;
            --solution-bg: #f8fafc;
            --danger: #dc2626;
            --danger-bg: #fef2f2;
            --danger-border: #fecaca;
            --success: #15803d;
            --success-bg: #f0fdf4;
            --success-border: #bbf7d0;
            --ai-warning: #b45309;
            --ai-warning-bg: #fffbeb;
            --ai-warning-border: #fde68a;
            --favorite: #d97706;
            --favorite-bg: #fffbeb;
            --favorite-border: #fde68a;
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

        .case-actions {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 18px;
        }

        .case-action-link,
        .case-action-button {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 7px;
            min-height: 38px;
            padding: 8px 13px;
            border-radius: 10px;
            border: 1px solid var(--border);
            background: #ffffff;
            color: var(--text-main);
            text-decoration: none;
            font: inherit;
            font-size: 14px;
            cursor: pointer;
        }

        .case-action-link:hover,
        .case-action-button:hover {
            border-color: #cbd5e1;
            background: #f9fafb;
        }

        .discussion-link {
            border-color: #bfdbfe;
            background: #eff6ff;
            color: var(--link);
        }

        .discussion-link:hover {
            color: var(--link-hover);
            border-color: #93c5fd;
            background: #dbeafe;
        }

        .favorite-button {
            border-color: var(--favorite-border);
            background: #ffffff;
            color: #4b5563;
        }

        .favorite-button:hover {
            color: var(--favorite);
            background: var(--favorite-bg);
            border-color: var(--favorite-border);
        }

        .favorite-button.active {
            color: var(--favorite);
            background: var(--favorite-bg);
            border-color: var(--favorite-border);
            font-weight: 650;
        }

        .favorite-button:disabled {
            cursor: default;
            opacity: 0.65;
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

        .case-reactions {
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

        .case-ai {
            margin-top: 24px;
            padding: 18px 20px;
            border: 1px solid var(--border);
            border-radius: 14px;
            background: #f9fafb;
        }

        .case-ai-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 14px;
            margin-bottom: 14px;
        }

        .case-ai-title {
            margin: 0;
            font-size: 20px;
            line-height: 1.3;
            color: #111827;
        }

        .case-ai-description {
            margin: 6px 0 0;
            color: var(--text-muted);
            font-size: 14px;
            line-height: 1.45;
        }

        .case-ai-actions {
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
            color: var(--ai-warning);
            background: var(--ai-warning-bg);
            border: 1px solid var(--ai-warning-border);
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
            color: var(--ai-warning);
            background: var(--ai-warning-bg);
            border: 1px solid var(--ai-warning-border);
        }

        .page-message-success {
            display: block;
            color: var(--success);
            background: var(--success-bg);
            border: 1px solid var(--success-border);
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

            .case-ai-header {
                display: block;
            }

            .case-ai-actions {
                margin-top: 14px;
            }
        }
    </style>
</head>
<body>
<#include "/fragments/header.ftlh">

<main class="page">
    <div id="pageMessage" class="page-message"></div>

    <article class="case-card">
        <header class="case-header">
            <h1 class="case-title">${currentCase.title()}</h1>

            <div class="case-meta">
                <span>Автор: ${currentCase.owner()}</span>
                <span>Создано: ${currentCase.createdAt()}</span>
                <span>Обновлено: ${currentCase.updatedAt()}</span>
                <span class="case-views">Просмотры: ${(currentCase.countViews())!0}</span>
            </div>

            <div class="case-actions">
                <button
                        id="favoriteButton"
                        class="case-action-button favorite-button <#if currentCase.isFavourite()>active</#if>"
                        type="button"
                        data-authenticated="${(isAuthenticated!false)?c}"
                        data-favourite="${(currentCase.isFavourite())?c}">
                    <span id="favoriteIcon"><#if currentCase.isFavourite()>★<#else>☆</#if></span>
                    <span id="favoriteText">
                        <#if currentCase.isFavourite()>
                            В избранном
                        <#else>
                            В избранное
                        </#if>
                    </span>
                </button>

                <a
                        class="case-action-link discussion-link"
                        href="/cases/${currentCase.contentId()}/comments">
                    Перейти в обсуждение
                </a>
            </div>

            <#if currentCase.reactionsAllowed()>
                <#assign reaction = currentCase.reactionResponse()>
                <#assign currentReaction = ((reaction.currentReaction())!'')?string>

                <div class="case-reactions">
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

            <section class="case-ai">
                <div class="case-ai-header">
                    <div>
                        <h2 class="case-ai-title">AI-помощник</h2>
                        <p class="case-ai-description">
                            Можно получить краткое содержание кейса или объяснить выделенный термин.
                        </p>
                    </div>

                    <div class="case-ai-actions">
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

        <div id="caseAiContent">
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
        </div>
    </article>
</main>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        initSolutionToggle();
        initFavourite();
        initReactions();
        initAi();
    });

    function getCsrfData() {
        const csrfTokenMeta = document.querySelector("meta[name='_csrf']");
        const csrfHeaderMeta = document.querySelector("meta[name='_csrf_header']");

        return {
            token: csrfTokenMeta ? csrfTokenMeta.getAttribute("content") : null,
            headerName: csrfHeaderMeta ? csrfHeaderMeta.getAttribute("content") : null
        };
    }

    function buildHeaders(jsonBody) {
        const csrf = getCsrfData();

        const headers = {
            "Accept": "application/json",
            "X-Requested-With": "XMLHttpRequest"
        };

        if (csrf.headerName && csrf.token) {
            headers[csrf.headerName] = csrf.token;
        }

        if (jsonBody) {
            headers["Content-Type"] = "application/json";
        }

        return headers;
    }

    async function extractErrorMessage(response, defaultMessage) {
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

    function initSolutionToggle() {
        const toggleSolutionButton = document.getElementById("toggleSolutionButton");
        const solutionContent = document.getElementById("solutionContent");

        if (!toggleSolutionButton || !solutionContent) {
            return;
        }

        toggleSolutionButton.addEventListener("click", function () {
            const isHidden = solutionContent.hidden;

            solutionContent.hidden = !isHidden;
            toggleSolutionButton.setAttribute("aria-expanded", String(isHidden));
            toggleSolutionButton.textContent = isHidden
                ? "Скрыть решение"
                : "Показать решение";
        });
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

    function initFavourite() {
        const contentItemId = "${currentCase.contentId()}";

        const favoriteButton = document.getElementById("favoriteButton");
        const favoriteIcon = document.getElementById("favoriteIcon");
        const favoriteText = document.getElementById("favoriteText");

        if (!favoriteButton || !favoriteIcon || !favoriteText) {
            return;
        }

        function isAuthenticated() {
            return favoriteButton.dataset.authenticated === "true";
        }

        function isFavourite() {
            return favoriteButton.dataset.favourite === "true";
        }

        function updateFavouriteView(favourite) {
            favoriteButton.dataset.favourite = String(favourite);

            if (favourite) {
                favoriteButton.classList.add("active");
                favoriteIcon.textContent = "★";
                favoriteText.textContent = "В избранном";
            } else {
                favoriteButton.classList.remove("active");
                favoriteIcon.textContent = "☆";
                favoriteText.textContent = "В избранное";
            }
        }

        async function readFavouriteState(response) {
            const contentType = response.headers.get("content-type");

            if (!contentType || !contentType.includes("application/json")) {
                return !isFavourite();
            }

            const body = await response.json();

            if (typeof body.isFavourite === "boolean") {
                return body.isFavourite;
            }

            if (typeof body.favourite === "boolean") {
                return body.favourite;
            }

            if (typeof body.favorite === "boolean") {
                return body.favorite;
            }

            return !isFavourite();
        }

        favoriteButton.addEventListener("click", async function () {
            if (!isAuthenticated()) {
                showPageMessage(
                    "Чтобы добавить кейс в избранное, нужно войти в аккаунт.",
                    "warning"
                );
                return;
            }

            favoriteButton.disabled = true;

            try {
                const response = await fetch("/api/favorites/content/" + contentItemId, {
                    method: "POST",
                    headers: buildHeaders(false),
                    credentials: "same-origin"
                });

                if (response.status === 401) {
                    showPageMessage(
                        "Чтобы добавить кейс в избранное, нужно войти в аккаунт.",
                        "warning"
                    );
                    favoriteButton.disabled = false;
                    return;
                }

                if (response.status === 403) {
                    showPageMessage("Недостаточно прав для выполнения действия.", "error");
                    favoriteButton.disabled = false;
                    return;
                }

                if (!response.ok) {
                    const message = await extractErrorMessage(
                        response,
                        "Не удалось обновить избранное."
                    );

                    showPageMessage(message, "error");
                    favoriteButton.disabled = false;
                    return;
                }

                const favourite = await readFavouriteState(response);

                updateFavouriteView(favourite);

                showPageMessage(
                    favourite
                        ? "Кейс добавлен в избранное."
                        : "Кейс удалён из избранного.",
                    "success"
                );

                favoriteButton.disabled = false;
            } catch (e) {
                console.error(e);
                showPageMessage("Не удалось обновить избранное.", "error");
                favoriteButton.disabled = false;
            }
        });
    }

    function initReactions() {
        const contentItemId = "${currentCase.contentId()}";

        const likeButton = document.getElementById("likeButton");
        const dislikeButton = document.getElementById("dislikeButton");
        const likesCount = document.getElementById("likesCount");
        const dislikesCount = document.getElementById("dislikesCount");

        if (!likeButton || !dislikeButton || !likesCount || !dislikesCount) {
            return;
        }

        function setButtonsDisabled(disabled) {
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

            setButtonsDisabled(true);

            try {
                const response = await fetch(url, {
                    method: "POST",
                    headers: buildHeaders(false),
                    credentials: "same-origin"
                });

                if (response.status === 401) {
                    showPageMessage("Для реакции необходимо войти в аккаунт.", "warning");
                    setButtonsDisabled(false);
                    return;
                }

                if (response.status === 403) {
                    showPageMessage("Недостаточно прав для выполнения действия.", "error");
                    setButtonsDisabled(false);
                    return;
                }

                if (!response.ok) {
                    showPageMessage("Не удалось обновить реакцию.", "error");
                    setButtonsDisabled(false);
                    return;
                }

                const reaction = await response.json();

                updateReactionView(reaction);
                setButtonsDisabled(false);
            } catch (e) {
                console.error(e);
                showPageMessage("Не удалось обновить реакцию.", "error");
                setButtonsDisabled(false);
            }
        }

        likeButton.addEventListener("click", function () {
            sendReaction("like");
        });

        dislikeButton.addEventListener("click", function () {
            sendReaction("dislike");
        });
    }

    function initAi() {
        const contentItemId = "${currentCase.contentId()}";

        const caseAiContent = document.getElementById("caseAiContent");

        const aiSummaryButton = document.getElementById("aiSummaryButton");
        const aiExplainButton = document.getElementById("aiExplainButton");
        const aiSelectedTerm = document.getElementById("aiSelectedTerm");
        const aiSelectedTermText = document.getElementById("aiSelectedTermText");
        const aiMessage = document.getElementById("aiMessage");
        const aiResult = document.getElementById("aiResult");
        const aiResultTitle = document.getElementById("aiResultTitle");
        const aiResultContent = document.getElementById("aiResultContent");

        if (!caseAiContent
            || !aiSummaryButton
            || !aiExplainButton
            || !aiSelectedTerm
            || !aiSelectedTermText
            || !aiMessage
            || !aiResult
            || !aiResultTitle
            || !aiResultContent) {
            return;
        }

        let aiRequestInProgress = false;

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
            aiSummaryButton.disabled = loading;
            aiExplainButton.disabled = loading;

            if (loading) {
                showAiMessage("AI формирует ответ, подождите...", "warning");
            }
        }

        function isUnauthorizedResponse(response) {
            return response.status === 401 || response.status === 403;
        }

        async function readJsonResponse(response) {
            const contentType = response.headers.get("content-type");

            if (!contentType || !contentType.includes("application/json")) {
                throw new Error("Response is not json");
            }

            return await response.json();
        }

        function getSelectedTextInsideCase() {
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

            if (!caseAiContent.contains(container)) {
                return "";
            }

            return selectedText;
        }

        function updateSelectedTermView() {
            const selectedText = getSelectedTextInsideCase();

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
                    const message = await extractErrorMessage(
                        response,
                        "Не удалось выполнить AI-запрос"
                    );

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
                showAiMessage("Не удалось получить краткое содержание кейса", "error");
            } finally {
                setAiLoading(false);
            }
        }

        async function sendAiExplainRequest() {
            if (aiRequestInProgress) {
                return;
            }

            const selectedText = getSelectedTextInsideCase();

            if (!selectedText) {
                hideAiResult();
                showAiMessage("Выделите термин в описании или решении кейса, который нужно объяснить.", "warning");
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
                    const message = await extractErrorMessage(
                        response,
                        "Не удалось выполнить AI-запрос"
                    );

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

        aiSummaryButton.addEventListener("click", sendAiSummaryRequest);
        aiExplainButton.addEventListener("click", sendAiExplainRequest);
    }
    </script>

    <#include "/fragments/footer.ftlh">

    </body>
    </html>