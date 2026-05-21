<#--&lt;#&ndash; templates/content/my-content.ftlh &ndash;&gt;-->
<#--<#if _csrf??>-->
<#--    <#assign csrfHeaderName = _csrf.headerName>-->
<#--    <#assign csrfToken = _csrf.token>-->
<#--<#else>-->
<#--    <#assign csrfHeaderName = "">-->
<#--    <#assign csrfToken = "">-->
<#--</#if>-->
<#--<!DOCTYPE html>-->
<#--<html lang="ru">-->
<#--<head>-->
<#--    <meta charset="UTF-8">-->
<#--    <title>Мой контент</title>-->

<#--    <style>-->
<#--        :root {-->
<#--            --bg: #f6f7f9;-->
<#--            --card-bg: #ffffff;-->
<#--            --text-main: #1f2937;-->
<#--            --text-muted: #6b7280;-->
<#--            --border: #e5e7eb;-->
<#--            --link: #2563eb;-->
<#--            --link-hover: #1d4ed8;-->
<#--            --danger: #dc2626;-->
<#--            --danger-bg: #fef2f2;-->
<#--            --danger-border: #fecaca;-->
<#--            --warning-bg: #fffbeb;-->
<#--            --warning-text: #b45309;-->
<#--            --success-bg: #f0fdf4;-->
<#--            --success-text: #15803d;-->
<#--            --rejected-bg: #fef2f2;-->
<#--            --rejected-text: #b91c1c;-->
<#--            --draft-bg: #f3f4f6;-->
<#--            --draft-text: #4b5563;-->
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
<#--        }-->

<#--        .page-wrapper {-->
<#--            max-width: 980px;-->
<#--            margin: 0 auto;-->
<#--            padding: 40px 20px 64px;-->
<#--        }-->

<#--        .page-header {-->
<#--            margin-bottom: 32px;-->
<#--        }-->

<#--        .page-title {-->
<#--            margin: 0 0 8px;-->
<#--            font-size: 36px;-->
<#--            line-height: 1.2;-->
<#--            letter-spacing: -0.03em;-->
<#--        }-->

<#--        .page-description {-->
<#--            margin: 0;-->
<#--            color: var(--text-muted);-->
<#--            font-size: 16px;-->
<#--        }-->

<#--        .content-list {-->
<#--            display: grid;-->
<#--            gap: 18px;-->
<#--        }-->

<#--        .content-card {-->
<#--            padding: 24px 28px;-->
<#--            background: var(--card-bg);-->
<#--            border: 1px solid var(--border);-->
<#--            border-radius: 16px;-->
<#--            box-shadow: 0 8px 24px rgba(15, 23, 42, 0.05);-->
<#--        }-->

<#--        .content-card-header {-->
<#--            display: flex;-->
<#--            justify-content: space-between;-->
<#--            gap: 16px;-->
<#--            align-items: flex-start;-->
<#--            margin-bottom: 12px;-->
<#--        }-->

<#--        .content-type {-->
<#--            display: inline-flex;-->
<#--            align-items: center;-->
<#--            margin-bottom: 10px;-->
<#--            padding: 3px 9px;-->
<#--            border-radius: 999px;-->
<#--            background: #eff6ff;-->
<#--            color: #1d4ed8;-->
<#--            border: 1px solid #bfdbfe;-->
<#--            font-size: 12px;-->
<#--            font-weight: 650;-->
<#--            line-height: 1.3;-->
<#--        }-->

<#--        .status-badge {-->
<#--            display: inline-flex;-->
<#--            align-items: center;-->
<#--            padding: 4px 10px;-->
<#--            border-radius: 999px;-->
<#--            font-size: 12px;-->
<#--            font-weight: 700;-->
<#--            white-space: nowrap;-->
<#--        }-->

<#--        .status-draft {-->
<#--            background: var(--draft-bg);-->
<#--            color: var(--draft-text);-->
<#--        }-->

<#--        .status-pending {-->
<#--            background: var(--warning-bg);-->
<#--            color: var(--warning-text);-->
<#--        }-->

<#--        .status-published {-->
<#--            background: var(--success-bg);-->
<#--            color: var(--success-text);-->
<#--        }-->

<#--        .status-rejected {-->
<#--            background: var(--rejected-bg);-->
<#--            color: var(--rejected-text);-->
<#--        }-->

<#--        .content-title {-->
<#--            margin: 0 0 10px;-->
<#--            font-size: 24px;-->
<#--            line-height: 1.3;-->
<#--            color: #111827;-->
<#--        }-->

<#--        .content-preview {-->
<#--            margin: 0 0 18px;-->
<#--            color: #374151;-->
<#--            line-height: 1.6;-->
<#--            font-size: 16px;-->
<#--        }-->

<#--        .content-meta {-->
<#--            display: flex;-->
<#--            flex-wrap: wrap;-->
<#--            gap: 10px 18px;-->
<#--            color: var(--text-muted);-->
<#--            font-size: 14px;-->
<#--            margin-bottom: 18px;-->
<#--        }-->

<#--        .rejection-notice {-->
<#--            margin: 0 0 14px;-->
<#--            padding: 12px 14px;-->
<#--            border: 1px solid var(--danger-border);-->
<#--            border-radius: 12px;-->
<#--            background: var(--danger-bg);-->
<#--            color: var(--rejected-text);-->
<#--            font-size: 14px;-->
<#--        }-->

<#--        .rejection-comment {-->
<#--            display: none;-->
<#--            margin: 0 0 16px;-->
<#--            padding: 12px 14px;-->
<#--            border: 1px solid var(--border);-->
<#--            border-radius: 12px;-->
<#--            background: #f9fafb;-->
<#--            color: #374151;-->
<#--            white-space: pre-wrap;-->
<#--            overflow-wrap: anywhere;-->
<#--            font-size: 14px;-->
<#--        }-->

<#--        .content-actions {-->
<#--            display: flex;-->
<#--            flex-wrap: wrap;-->
<#--            gap: 10px;-->
<#--        }-->

<#--        .action-link,-->
<#--        .action-button {-->
<#--            display: inline-flex;-->
<#--            align-items: center;-->
<#--            justify-content: center;-->
<#--            min-height: 38px;-->
<#--            padding: 8px 13px;-->
<#--            border-radius: 10px;-->
<#--            border: 1px solid var(--border);-->
<#--            background: #ffffff;-->
<#--            color: var(--text-main);-->
<#--            text-decoration: none;-->
<#--            font: inherit;-->
<#--            font-size: 14px;-->
<#--            cursor: pointer;-->
<#--        }-->

<#--        .action-link.primary {-->
<#--            border-color: #bfdbfe;-->
<#--            background: #eff6ff;-->
<#--            color: var(--link);-->
<#--        }-->

<#--        .action-link.primary:hover {-->
<#--            color: var(--link-hover);-->
<#--            border-color: #93c5fd;-->
<#--        }-->

<#--        .action-link:hover,-->
<#--        .action-button:hover {-->
<#--            border-color: #cbd5e1;-->
<#--            background: #f9fafb;-->
<#--        }-->

<#--        .withdraw-button {-->
<#--            border-color: #fde68a;-->
<#--            background: #fffbeb;-->
<#--            color: #b45309;-->
<#--        }-->

<#--        .withdraw-button:hover {-->
<#--            background: #fef3c7;-->
<#--        }-->

<#--        .delete-button {-->
<#--            border-color: var(--danger-border);-->
<#--            background: var(--danger-bg);-->
<#--            color: var(--danger);-->
<#--        }-->

<#--        .delete-button:hover {-->
<#--            background: #fee2e2;-->
<#--        }-->

<#--        .empty-state {-->
<#--            padding: 32px;-->
<#--            background: var(--card-bg);-->
<#--            border: 1px solid var(--border);-->
<#--            border-radius: 16px;-->
<#--            color: var(--text-muted);-->
<#--            text-align: center;-->
<#--        }-->

<#--        .pagination {-->
<#--            display: flex;-->
<#--            justify-content: center;-->
<#--            align-items: center;-->
<#--            gap: 8px;-->
<#--            margin-top: 34px;-->
<#--        }-->

<#--        .pagination a,-->
<#--        .pagination span {-->
<#--            min-width: 38px;-->
<#--            padding: 9px 12px;-->
<#--            border: 1px solid var(--border);-->
<#--            border-radius: 10px;-->
<#--            background: var(--card-bg);-->
<#--            color: var(--text-main);-->
<#--            text-align: center;-->
<#--            text-decoration: none;-->
<#--            font-size: 14px;-->
<#--        }-->

<#--        .pagination a:hover {-->
<#--            color: var(--link-hover);-->
<#--            border-color: #bfdbfe;-->
<#--            background: #eff6ff;-->
<#--        }-->

<#--        .pagination .active {-->
<#--            color: #ffffff;-->
<#--            border-color: var(--link);-->
<#--            background: var(--link);-->
<#--        }-->

<#--        .pagination .disabled {-->
<#--            color: #9ca3af;-->
<#--            background: #f3f4f6;-->
<#--        }-->

<#--        .pagination-info {-->
<#--            margin-top: 14px;-->
<#--            color: var(--text-muted);-->
<#--            text-align: center;-->
<#--            font-size: 14px;-->
<#--        }-->

<#--        .visibility-badge {-->
<#--            display: inline-flex;-->
<#--            align-items: center;-->
<#--            padding: 4px 10px;-->
<#--            border-radius: 999px;-->
<#--            font-size: 12px;-->
<#--            font-weight: 700;-->
<#--            white-space: nowrap;-->
<#--        }-->

<#--        .visibility-public {-->
<#--            background: #eff6ff;-->
<#--            color: #1d4ed8;-->
<#--        }-->

<#--        .visibility-private {-->
<#--            background: #f3f4f6;-->
<#--            color: #4b5563;-->
<#--        }-->

<#--        .card-badges {-->
<#--            display: flex;-->
<#--            flex-wrap: wrap;-->
<#--            gap: 8px;-->
<#--            justify-content: flex-end;-->
<#--        }-->

<#--        .create-actions {-->
<#--            display: flex;-->
<#--            gap: 10px;-->
<#--            margin-top: 18px;-->
<#--        }-->

<#--        .create-button {-->
<#--            display: inline-flex;-->
<#--            align-items: center;-->
<#--            min-height: 38px;-->
<#--            padding: 9px 16px;-->
<#--            border: none;-->
<#--            border-radius: 10px;-->
<#--            background: var(--link);-->
<#--            color: #ffffff;-->
<#--            font: inherit;-->
<#--            font-size: 14px;-->
<#--            font-weight: 600;-->
<#--            cursor: pointer;-->
<#--            transition: background 0.12s;-->
<#--        }-->

<#--        .create-button:hover {-->
<#--            background: var(--link-hover);-->
<#--        }-->

<#--        .create-button-secondary {-->
<#--            background: #ffffff;-->
<#--            color: var(--text-main);-->
<#--            border: 1px solid var(--border);-->
<#--        }-->

<#--        .create-button-secondary:hover {-->
<#--            background: #f3f4f6;-->
<#--        }-->

<#--        @media (max-width: 700px) {-->
<#--            .page-wrapper {-->
<#--                padding: 24px 14px 40px;-->
<#--            }-->

<#--            .page-title {-->
<#--                font-size: 30px;-->
<#--            }-->

<#--            .content-card {-->
<#--                padding: 20px;-->
<#--            }-->

<#--            .content-title {-->
<#--                font-size: 21px;-->
<#--            }-->

<#--            .content-card-header {-->
<#--                display: block;-->
<#--            }-->

<#--            .status-badge {-->
<#--                margin-top: 8px;-->
<#--            }-->

<#--            .pagination {-->
<#--                flex-wrap: wrap;-->
<#--            }-->
<#--        }-->
<#--    </style>-->
<#--</head>-->
<#--<body>-->
<#--<#include "/fragments/header.ftlh">-->

<#--<main class="page-wrapper">-->
<#--    <header class="page-header">-->
<#--        <h1 class="page-title">Мой контент</h1>-->
<#--        <p class="page-description">-->
<#--            Здесь отображаются ваши статьи и кейсы.-->
<#--        </p>-->

<#--        <div class="create-actions">-->
<#--            <form method="post" action="/articles/drafts" style="display:inline;">-->
<#--                <#if _csrf??>-->
<#--                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">-->
<#--                </#if>-->
<#--                <button type="submit" class="create-button">Создать статью</button>-->
<#--            </form>-->

<#--            <form method="post" action="/cases/drafts" style="display:inline;">-->
<#--                <#if _csrf??>-->
<#--                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">-->
<#--                </#if>-->
<#--                <button type="submit" class="create-button create-button-secondary">Создать кейс</button>-->
<#--            </form>-->
<#--        </div>-->
<#--    </header>-->

<#--    <#if page.contents()?has_content>-->
<#--        <section class="content-list" id="contentList">-->
<#--            <#list page.contents() as content>-->
<#--                <#assign isArticle = content.itemType() == "ARTICLE">-->
<#--                <#assign isDraft = content.contentStatus() == "DRAFT">-->
<#--                <#assign isPending = content.contentStatus() == "PENDING_REVIEW">-->
<#--                <#assign isPublished = content.contentStatus() == "PUBLISHED">-->
<#--                <#assign isRejected = content.contentStatus() == "REJECTED">-->

<#--                <#if isArticle>-->
<#--                    <#assign typeName = "Статья">-->
<#--                    <#assign viewUrl = "/articles/" + content.contentItemId()>-->
<#--                    <#assign editUrl = "/articles/" + content.contentItemId() + "/edit">-->
<#--                    <#assign draftEditUrl = "/articles/drafts/" + content.contentItemId() + "/edit">-->
<#--                    <#assign deleteUrl = "/articles/" + content.contentItemId()>-->
<#--                <#else>-->
<#--                    <#assign typeName = "Кейс">-->
<#--                    <#assign viewUrl = "/cases/" + content.contentItemId()>-->
<#--                    <#assign editUrl = "/cases/" + content.contentItemId() + "/edit">-->
<#--                    <#assign draftEditUrl = "/cases/drafts/" + content.contentItemId() + "/edit">-->
<#--                    <#assign deleteUrl = "/cases/" + content.contentItemId()>-->
<#--                </#if>-->

<#--                <#if isDraft>-->
<#--                    <#assign statusText = "Черновик">-->
<#--                    <#assign statusClass = "status-draft">-->
<#--                <#elseif isPending>-->
<#--                    <#assign statusText = "На проверке">-->
<#--                    <#assign statusClass = "status-pending">-->
<#--                <#elseif isPublished>-->
<#--                    <#assign statusText = "Опубликовано">-->
<#--                    <#assign statusClass = "status-published">-->
<#--                <#elseif isRejected>-->
<#--                    <#assign statusText = "Отклонено">-->
<#--                    <#assign statusClass = "status-rejected">-->
<#--                <#else>-->
<#--                    <#assign statusText = content.contentStatus()>-->
<#--                    <#assign statusClass = "status-draft">-->
<#--                </#if>-->

<#--                <#assign isPublic = content.visibility() == "PUBLIC">-->
<#--                <#assign isPrivate = content.visibility() == "PRIVATE">-->

<#--                <#if isPublic>-->
<#--                    <#assign visibilityText = "Публичный">-->
<#--                    <#assign visibilityClass = "visibility-public">-->
<#--                <#elseif isPrivate>-->
<#--                    <#assign visibilityText = "Приватный">-->
<#--                    <#assign visibilityClass = "visibility-private">-->
<#--                <#else>-->
<#--                    <#assign visibilityText = content.visibility()>-->
<#--                    <#assign visibilityClass = "visibility-private">-->
<#--                </#if>-->

<#--                <article class="content-card" id="content-card-${content.contentItemId()}">-->
<#--                    <div class="content-card-header">-->
<#--                        <div>-->
<#--                            <span class="content-type">${typeName}</span>-->
<#--                            <h2 class="content-title">${content.title()}</h2>-->
<#--                        </div>-->

<#--                        <div class="card-badges">-->
<#--                            <span class="status-badge ${statusClass}">-->
<#--                                ${statusText}-->
<#--                            </span>-->

<#--                            <span class="visibility-badge ${visibilityClass}">-->
<#--                                ${visibilityText}-->
<#--                            </span>-->
<#--                        </div>-->
<#--                    </div>-->

<#--                    <#if content.preview()?has_content>-->
<#--                        <p class="content-preview">${content.preview()}</p>-->
<#--                    <#else>-->
<#--                        <p class="content-preview">Описание отсутствует.</p>-->
<#--                    </#if>-->

<#--                    <div class="content-meta">-->
<#--                        <span>Автор: ${content.owner()}</span>-->
<#--                        <span>Создано: ${content.createdAt()}</span>-->
<#--                    </div>-->

<#--                    <#if isRejected>-->
<#--                        <div class="rejection-notice">-->
<#--                            Контент отклонён. Можно посмотреть комментарий модерации и отредактировать материал.-->
<#--                        </div>-->

<#--                        <div-->
<#--                                class="rejection-comment"-->
<#--                                id="rejection-comment-${content.contentItemId()}">-->
<#--                        </div>-->
<#--                    </#if>-->

<#--                    <div class="content-actions">-->
<#--                        <#if isDraft>-->
<#--                            <a class="action-link primary" href="${draftEditUrl}">-->
<#--                                Продолжить редактирование-->
<#--                            </a>-->

<#--                            <button-->
<#--                                    class="action-button delete-button"-->
<#--                                    type="button"-->
<#--                                    data-delete-url="${deleteUrl}"-->
<#--                                    data-card-id="content-card-${content.contentItemId()}">-->
<#--                                Удалить-->
<#--                            </button>-->
<#--                        </#if>-->

<#--                        <#if isPending>-->
<#--                            <a class="action-link primary" href="${viewUrl}">-->
<#--                                Подробнее-->
<#--                            </a>-->

<#--                            <button-->
<#--                                    class="action-button withdraw-button"-->
<#--                                    type="button"-->
<#--                                    data-content-id="${content.contentItemId()}">-->
<#--                                Отозвать с проверки-->
<#--                            </button>-->

<#--                            <button-->
<#--                                    class="action-button delete-button"-->
<#--                                    type="button"-->
<#--                                    data-delete-url="${deleteUrl}"-->
<#--                                    data-card-id="content-card-${content.contentItemId()}">-->
<#--                                Удалить-->
<#--                            </button>-->
<#--                        </#if>-->

<#--                        <#if isPublished>-->
<#--                            <a class="action-link primary" href="${viewUrl}">-->
<#--                                Подробнее-->
<#--                            </a>-->

<#--                            <a class="action-link" href="${editUrl}">-->
<#--                                Редактировать-->
<#--                            </a>-->

<#--                            <button-->
<#--                                    class="action-button delete-button"-->
<#--                                    type="button"-->
<#--                                    data-delete-url="${deleteUrl}"-->
<#--                                    data-card-id="content-card-${content.contentItemId()}">-->
<#--                                Удалить-->
<#--                            </button>-->
<#--                        </#if>-->

<#--                        <#if isRejected>-->
<#--                            <a class="action-link primary" href="${viewUrl}">-->
<#--                                Подробнее-->
<#--                            </a>-->

<#--                            <a class="action-link" href="${editUrl}">-->
<#--                                Редактировать-->
<#--                            </a>-->

<#--                            <button-->
<#--                                    class="action-button show-rejection-comment-button"-->
<#--                                    type="button"-->
<#--                                    data-content-id="${content.contentItemId()}">-->
<#--                                Показать комментарий-->
<#--                            </button>-->

<#--                            <button-->
<#--                                    class="action-button delete-button"-->
<#--                                    type="button"-->
<#--                                    data-delete-url="${deleteUrl}"-->
<#--                                    data-card-id="content-card-${content.contentItemId()}">-->
<#--                                Удалить-->
<#--                            </button>-->
<#--                        </#if>-->
<#--                    </div>-->
<#--                </article>-->
<#--            </#list>-->
<#--        </section>-->

<#--        <#if page.totalPages() gt 1>-->
<#--            <nav class="pagination">-->
<#--                <#if page.hasPrevious()>-->
<#--                    <a href="/my-content?page=${page.currentPage() - 1}&size=${page.size()}">Назад</a>-->
<#--                <#else>-->
<#--                    <span class="disabled">Назад</span>-->
<#--                </#if>-->

<#--                <#list 0..(page.totalPages() - 1) as pageNumber>-->
<#--                    <#if pageNumber == page.currentPage()>-->
<#--                        <span class="active">${pageNumber + 1}</span>-->
<#--                    <#else>-->
<#--                        <a href="/my-content?page=${pageNumber}&size=${page.size()}">${pageNumber + 1}</a>-->
<#--                    </#if>-->
<#--                </#list>-->

<#--                <#if page.hasNext()>-->
<#--                    <a href="/my-content?page=${page.currentPage() + 1}&size=${page.size()}">Вперёд</a>-->
<#--                <#else>-->
<#--                    <span class="disabled">Вперёд</span>-->
<#--                </#if>-->
<#--            </nav>-->
<#--        </#if>-->

<#--        <div class="pagination-info">-->
<#--            Страница ${page.currentPage() + 1} из ${page.totalPages()},-->
<#--            всего элементов: ${page.totalElements()}-->
<#--        </div>-->
<#--    <#else>-->
<#--        <div class="empty-state">-->
<#--            У вас пока нет созданного контента.-->
<#--        </div>-->
<#--    </#if>-->
<#--</main>-->

<#--<script>-->
<#--    const csrfHeaderName = <#if csrfHeaderName?has_content>"${csrfHeaderName?js_string}"<#else>null</#if>;-->
<#--    const csrfToken = <#if csrfToken?has_content>"${csrfToken?js_string}"<#else>null</#if>;-->

<#--    function buildHeaders(jsonBody) {-->
<#--        const headers = {};-->

<#--        if (csrfHeaderName && csrfToken) {-->
<#--            headers[csrfHeaderName] = csrfToken;-->
<#--        }-->

<#--        if (jsonBody) {-->
<#--            headers["Content-Type"] = "application/json";-->
<#--        }-->

<#--        return headers;-->
<#--    }-->

<#--    async function extractErrorMessage(response, defaultMessage) {-->
<#--        const contentType = response.headers.get("content-type");-->

<#--        if (contentType && contentType.includes("application/json")) {-->
<#--            try {-->
<#--                const body = await response.json();-->

<#--                if (body.message) {-->
<#--                    return body.message;-->
<#--                }-->

<#--                return defaultMessage;-->
<#--            } catch (e) {-->
<#--                return defaultMessage;-->
<#--            }-->
<#--        }-->

<#--        try {-->
<#--            const text = await response.text();-->

<#--            if (text && text.trim().length > 0) {-->
<#--                return text;-->
<#--            }-->

<#--            return defaultMessage;-->
<#--        } catch (e) {-->
<#--            return defaultMessage;-->
<#--        }-->
<#--    }-->

<#--    async function deleteContent(button) {-->
<#--        const deleteUrl = button.dataset.deleteUrl;-->
<#--        const cardId = button.dataset.cardId;-->

<#--        if (!deleteUrl || !cardId) {-->
<#--            return;-->
<#--        }-->

<#--        const confirmed = confirm("Удалить этот контент?");-->

<#--        if (!confirmed) {-->
<#--            return;-->
<#--        }-->

<#--        button.disabled = true;-->

<#--        try {-->
<#--            const response = await fetch(deleteUrl, {-->
<#--                method: "DELETE",-->
<#--                headers: buildHeaders(false)-->
<#--            });-->

<#--            if (!response.ok) {-->
<#--                const message = await extractErrorMessage(response, "Не удалось удалить контент");-->
<#--                alert(message);-->
<#--                button.disabled = false;-->
<#--                return;-->
<#--            }-->

<#--            const card = document.getElementById(cardId);-->

<#--            if (card) {-->
<#--                card.remove();-->
<#--            }-->

<#--            const contentList = document.getElementById("contentList");-->

<#--            if (contentList && contentList.children.length === 0) {-->
<#--                location.reload();-->
<#--            }-->
<#--        } catch (e) {-->
<#--            console.error(e);-->
<#--            alert("Не удалось удалить контент");-->
<#--            button.disabled = false;-->
<#--        }-->
<#--    }-->

<#--    async function withdrawContent(button) {-->
<#--        const contentId = button.dataset.contentId;-->

<#--        if (!contentId) {-->
<#--            return;-->
<#--        }-->

<#--        const confirmed = confirm("Отозвать контент с проверки?");-->

<#--        if (!confirmed) {-->
<#--            return;-->
<#--        }-->

<#--        button.disabled = true;-->

<#--        try {-->
<#--            const response = await fetch("/api/content/" + contentId + "/withdraw", {-->
<#--                method: "POST",-->
<#--                headers: buildHeaders(false)-->
<#--            });-->

<#--            if (!response.ok) {-->
<#--                const message = await extractErrorMessage(response, "Не удалось отозвать контент");-->
<#--                alert(message);-->
<#--                button.disabled = false;-->
<#--                return;-->
<#--            }-->

<#--            location.reload();-->
<#--        } catch (e) {-->
<#--            console.error(e);-->
<#--            alert("Не удалось отозвать контент");-->
<#--            button.disabled = false;-->
<#--        }-->
<#--    }-->

<#--    async function toggleRejectionComment(button) {-->
<#--        const contentId = button.dataset.contentId;-->

<#--        if (!contentId) {-->
<#--            return;-->
<#--        }-->

<#--        const commentBlock = document.getElementById("rejection-comment-" + contentId);-->

<#--        if (!commentBlock) {-->
<#--            return;-->
<#--        }-->

<#--        if (commentBlock.style.display === "block") {-->
<#--            commentBlock.style.display = "none";-->
<#--            button.textContent = "Показать комментарий";-->
<#--            return;-->
<#--        }-->

<#--        button.disabled = true;-->

<#--        try {-->
<#--            const response = await fetch("/api/my-content/" + contentId + "/rejection-comment");-->

<#--            if (!response.ok) {-->
<#--                const message = await extractErrorMessage(response, "Не удалось загрузить комментарий");-->
<#--                alert(message);-->
<#--                button.disabled = false;-->
<#--                return;-->
<#--            }-->

<#--            const body = await response.json();-->

<#--            commentBlock.textContent = body.comment || "Комментарий отсутствует";-->
<#--            commentBlock.style.display = "block";-->
<#--            button.textContent = "Скрыть комментарий";-->
<#--            button.disabled = false;-->
<#--        } catch (e) {-->
<#--            console.error(e);-->
<#--            alert("Не удалось загрузить комментарий");-->
<#--            button.disabled = false;-->
<#--        }-->
<#--    }-->

<#--    document.addEventListener("click", async function (event) {-->
<#--        const deleteButton = event.target.closest(".delete-button");-->

<#--        if (deleteButton) {-->
<#--            await deleteContent(deleteButton);-->
<#--            return;-->
<#--        }-->

<#--        const withdrawButton = event.target.closest(".withdraw-button");-->

<#--        if (withdrawButton) {-->
<#--            await withdrawContent(withdrawButton);-->
<#--            return;-->
<#--        }-->

<#--        const rejectionCommentButton = event.target.closest(".show-rejection-comment-button");-->

<#--        if (rejectionCommentButton) {-->
<#--            await toggleRejectionComment(rejectionCommentButton);-->
<#--        }-->
<#--    });-->
<#--</script>-->

<#--<#include "/fragments/footer.ftlh">-->
<#--</body>-->
<#--</html>-->
<#-- templates/content/my-content.ftlh -->
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Мой контент</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <#if _csrf??>
        <meta name="_csrf" content="${_csrf.token}">
        <meta name="_csrf_header" content="${_csrf.headerName}">
    </#if>

    <link rel="stylesheet" href="/css/styles.css">
    <script src="/js/my-content.js" defer></script>
</head>

<body class="app-body my-content-page">
<#include "/fragments/header.ftlh">

<main class="my-content">
    <div class="my-content__visual" aria-hidden="true">
        <div class="my-content__dots"></div>
        <div class="my-content__wave"></div>
        <div class="my-content__wave-secondary"></div>
        <div class="my-content__circle"></div>
    </div>

    <div class="my-content__container">
        <header class="my-content__header">
            <h1 class="my-content__title">Мой контент</h1>
            <p class="my-content__description">
                Здесь отображаются ваши статьи и кейсы.
            </p>

            <div class="my-content__create-actions">
                <form method="post" action="/articles/drafts" class="my-content__create-form">
                    <#if _csrf??>
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                    </#if>

                    <button type="submit" class="my-content-create-button my-content-create-button--primary">
                        <span class="my-content-create-button__icon" aria-hidden="true">
                            <svg viewBox="0 0 24 24" fill="none">
                                <path d="M12 5V19" stroke="currentColor" stroke-width="1.9" stroke-linecap="round"/>
                                <path d="M5 12H19" stroke="currentColor" stroke-width="1.9" stroke-linecap="round"/>
                            </svg>
                        </span>
                        <span>Создать статью</span>
                    </button>
                </form>

                <form method="post" action="/cases/drafts" class="my-content__create-form">
                    <#if _csrf??>
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                    </#if>

                    <button type="submit" class="my-content-create-button my-content-create-button--secondary">
                        <span class="my-content-create-button__icon" aria-hidden="true">
                            <svg viewBox="0 0 24 24" fill="none">
                                <path d="M4 7.5C4 6.67 4.67 6 5.5 6H10L12 8H18.5C19.33 8 20 8.67 20 9.5V17.5C20 18.33 19.33 19 18.5 19H5.5C4.67 19 4 18.33 4 17.5V7.5Z"
                                      stroke="currentColor"
                                      stroke-width="1.8"
                                      stroke-linejoin="round"/>
                            </svg>
                        </span>
                        <span>Создать кейс</span>
                    </button>
                </form>
            </div>
        </header>

        <#if page.contents()?has_content>
            <section class="my-content__list" id="contentList">
                <#list page.contents() as content>
                    <#assign isArticle = content.itemType() == "ARTICLE">
                    <#assign isDraft = content.contentStatus() == "DRAFT">
                    <#assign isPending = content.contentStatus() == "PENDING_REVIEW">
                    <#assign isPublished = content.contentStatus() == "PUBLISHED">
                    <#assign isRejected = content.contentStatus() == "REJECTED">

                    <#if isArticle>
                        <#assign typeName = "Статья">
                        <#assign viewUrl = "/articles/" + content.contentItemId()>
                        <#assign editUrl = "/articles/" + content.contentItemId() + "/edit">
                        <#assign draftEditUrl = "/articles/drafts/" + content.contentItemId() + "/edit">
                        <#assign deleteUrl = "/articles/" + content.contentItemId()>
                    <#else>
                        <#assign typeName = "Кейс">
                        <#assign viewUrl = "/cases/" + content.contentItemId()>
                        <#assign editUrl = "/cases/" + content.contentItemId() + "/edit">
                        <#assign draftEditUrl = "/cases/drafts/" + content.contentItemId() + "/edit">
                        <#assign deleteUrl = "/cases/" + content.contentItemId()>
                    </#if>

                    <#if isDraft>
                        <#assign statusText = "Черновик">
                        <#assign statusClass = "my-content-status--draft">
                    <#elseif isPending>
                        <#assign statusText = "На проверке">
                        <#assign statusClass = "my-content-status--pending">
                    <#elseif isPublished>
                        <#assign statusText = "Опубликовано">
                        <#assign statusClass = "my-content-status--published">
                    <#elseif isRejected>
                        <#assign statusText = "Отклонено">
                        <#assign statusClass = "my-content-status--rejected">
                    <#else>
                        <#assign statusText = content.contentStatus()>
                        <#assign statusClass = "my-content-status--draft">
                    </#if>

                    <#assign isPublic = content.visibility() == "PUBLIC">
                    <#assign isPrivate = content.visibility() == "PRIVATE">

                    <#if isPublic>
                        <#assign visibilityText = "Публичный">
                        <#assign visibilityClass = "my-content-visibility--public">
                    <#elseif isPrivate>
                        <#assign visibilityText = "Приватный">
                        <#assign visibilityClass = "my-content-visibility--private">
                    <#else>
                        <#assign visibilityText = content.visibility()>
                        <#assign visibilityClass = "my-content-visibility--private">
                    </#if>

                    <article class="my-content-card" id="content-card-${content.contentItemId()}">
                        <div class="my-content-card__main">
                            <div class="my-content-card__content">
                                <div class="my-content-card__type">
                                    <span class="my-content-card__type-icon" aria-hidden="true">
                                        <#if isArticle>
                                            <svg viewBox="0 0 24 24" fill="none">
                                                <path d="M6.5 3.5H15.5L19.5 7.5V20.5H6.5V3.5Z"
                                                      stroke="currentColor"
                                                      stroke-width="1.8"
                                                      stroke-linejoin="round"/>
                                                <path d="M9 3.5V9H16"
                                                      stroke="currentColor"
                                                      stroke-width="1.8"
                                                      stroke-linejoin="round"/>
                                            </svg>
                                        <#else>
                                            <svg viewBox="0 0 24 24" fill="none">
                                                <path d="M4 7.5C4 6.67 4.67 6 5.5 6H10L12 8H18.5C19.33 8 20 8.67 20 9.5V17.5C20 18.33 19.33 19 18.5 19H5.5C4.67 19 4 18.33 4 17.5V7.5Z"
                                                      stroke="currentColor"
                                                      stroke-width="1.8"
                                                      stroke-linejoin="round"/>
                                            </svg>
                                        </#if>
                                    </span>
                                    <span>${typeName}</span>
                                </div>

                                <h2 class="my-content-card__title">${content.title()}</h2>

                                <#if content.preview()?has_content>
                                    <p class="my-content-card__preview">${content.preview()}</p>
                                <#else>
                                    <p class="my-content-card__preview">Описание отсутствует.</p>
                                </#if>

                                <div class="my-content-card__meta">
                                    <span class="my-content-card__meta-item">
                                        <span class="my-content-card__meta-icon" aria-hidden="true">
                                            <svg viewBox="0 0 24 24" fill="none">
                                                <path d="M12 12.5C14.0711 12.5 15.75 10.8211 15.75 8.75C15.75 6.67893 14.0711 5 12 5C9.92893 5 8.25 6.67893 8.25 8.75C8.25 10.8211 9.92893 12.5 12 12.5Z"
                                                      stroke="currentColor"
                                                      stroke-width="1.7"/>
                                                <path d="M5.5 20C6.3 16.75 8.55 15.25 12 15.25C15.45 15.25 17.7 16.75 18.5 20"
                                                      stroke="currentColor"
                                                      stroke-width="1.7"
                                                      stroke-linecap="round"/>
                                            </svg>
                                        </span>
                                        <span>Автор: ${content.owner()}</span>
                                    </span>

                                    <span class="my-content-card__dot">•</span>

                                    <span class="my-content-card__meta-item">
                                        <span class="my-content-card__meta-icon" aria-hidden="true">
                                            <svg viewBox="0 0 24 24" fill="none">
                                                <path d="M7 4V7" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/>
                                                <path d="M17 4V7" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/>
                                                <path d="M5 8.5H19" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/>
                                                <path d="M6.5 5.5H17.5C18.6 5.5 19.5 6.4 19.5 7.5V18.5C19.5 19.6 18.6 20.5 17.5 20.5H6.5C5.4 20.5 4.5 19.6 4.5 18.5V7.5C4.5 6.4 5.4 5.5 6.5 5.5Z"
                                                      stroke="currentColor"
                                                      stroke-width="1.8"
                                                      stroke-linejoin="round"/>
                                            </svg>
                                        </span>
                                        <span>Создано: ${content.createdAt()}</span>
                                    </span>
                                </div>
                            </div>

                            <div class="my-content-card__side">
                                <div class="my-content-card__badges">
                                    <span class="my-content-status ${statusClass}">
                                        ${statusText}
                                    </span>

                                    <span class="my-content-visibility ${visibilityClass}">
                                        <span class="my-content-visibility__icon" aria-hidden="true">
                                            <#if isPublic>
                                                <svg viewBox="0 0 24 24" fill="none">
                                                    <path d="M12 21C16.9706 21 21 16.9706 21 12C21 7.02944 16.9706 3 12 3C7.02944 3 3 7.02944 3 12C3 16.9706 7.02944 21 12 21Z"
                                                          stroke="currentColor"
                                                          stroke-width="1.7"/>
                                                    <path d="M3.5 12H20.5"
                                                          stroke="currentColor"
                                                          stroke-width="1.7"
                                                          stroke-linecap="round"/>
                                                    <path d="M12 3C14.2 5.3 15.25 8.3 15.25 12C15.25 15.7 14.2 18.7 12 21C9.8 18.7 8.75 15.7 8.75 12C8.75 8.3 9.8 5.3 12 3Z"
                                                          stroke="currentColor"
                                                          stroke-width="1.7"
                                                          stroke-linejoin="round"/>
                                                </svg>
                                            <#else>
                                                <svg viewBox="0 0 24 24" fill="none">
                                                    <path d="M7 10V8C7 5.24 9.24 3 12 3C14.76 3 17 5.24 17 8V10"
                                                          stroke="currentColor"
                                                          stroke-width="1.8"
                                                          stroke-linecap="round"/>
                                                    <path d="M6.5 10H17.5C18.6 10 19.5 10.9 19.5 12V19C19.5 20.1 18.6 21 17.5 21H6.5C5.4 21 4.5 20.1 4.5 19V12C4.5 10.9 5.4 10 6.5 10Z"
                                                          stroke="currentColor"
                                                          stroke-width="1.8"
                                                          stroke-linejoin="round"/>
                                                </svg>
                                            </#if>
                                        </span>
                                        <span>${visibilityText}</span>
                                    </span>
                                </div>

                                <div class="my-content-card__actions">
                                    <#if isDraft>
                                        <a class="my-content-action my-content-action--primary" href="${draftEditUrl}">
                                            Продолжить редактирование
                                        </a>

                                        <button
                                                class="my-content-action my-content-action--secondary delete-button"
                                                type="button"
                                                data-delete-url="${deleteUrl}"
                                                data-card-id="content-card-${content.contentItemId()}">
                                            Удалить
                                        </button>
                                    </#if>

                                    <#if isPending>
                                        <a class="my-content-action my-content-action--secondary" href="${viewUrl}">
                                            Подробнее
                                        </a>

                                        <button
                                                class="my-content-action my-content-action--secondary withdraw-button"
                                                type="button"
                                                data-content-id="${content.contentItemId()}">
                                            Отозвать с проверки
                                        </button>

                                        <button
                                                class="my-content-action my-content-action--secondary delete-button"
                                                type="button"
                                                data-delete-url="${deleteUrl}"
                                                data-card-id="content-card-${content.contentItemId()}">
                                            Удалить
                                        </button>
                                    </#if>

                                    <#if isPublished>
                                        <a class="my-content-action my-content-action--secondary" href="${viewUrl}">
                                            Подробнее
                                        </a>

                                        <a class="my-content-action my-content-action--secondary" href="${editUrl}">
                                            Редактировать
                                        </a>

                                        <button
                                                class="my-content-action my-content-action--secondary delete-button"
                                                type="button"
                                                data-delete-url="${deleteUrl}"
                                                data-card-id="content-card-${content.contentItemId()}">
                                            Удалить
                                        </button>
                                    </#if>

                                    <#if isRejected>
                                        <a class="my-content-action my-content-action--secondary" href="${viewUrl}">
                                            Подробнее
                                        </a>

                                        <a class="my-content-action my-content-action--primary" href="${editUrl}">
                                            Продолжить редактирование
                                        </a>

                                        <button
                                                class="my-content-action my-content-action--secondary show-rejection-comment-button"
                                                type="button"
                                                data-content-id="${content.contentItemId()}">
                                            Показать комментарий
                                        </button>

                                        <button
                                                class="my-content-action my-content-action--secondary delete-button"
                                                type="button"
                                                data-delete-url="${deleteUrl}"
                                                data-card-id="content-card-${content.contentItemId()}">
                                            Удалить
                                        </button>
                                    </#if>
                                </div>
                            </div>
                        </div>

                        <#if isRejected>
                            <div class="my-content-rejection">
                                Контент отклонён. Можно посмотреть комментарий модерации и отредактировать материал.
                            </div>

                            <div
                                    class="my-content-rejection-comment"
                                    id="rejection-comment-${content.contentItemId()}">
                            </div>
                        </#if>
                    </article>
                </#list>
            </section>

            <#if page.totalPages() gt 1>
                <nav class="pagination">
                    <#if page.hasPrevious()>
                        <a href="/my-content?page=${page.currentPage() - 1}&size=${page.size()}">Назад</a>
                    <#else>
                        <span class="disabled">Назад</span>
                    </#if>

                    <#list 0..(page.totalPages() - 1) as pageNumber>
                        <#if pageNumber == page.currentPage()>
                            <span class="active">${pageNumber + 1}</span>
                        <#else>
                            <a href="/my-content?page=${pageNumber}&size=${page.size()}">${pageNumber + 1}</a>
                        </#if>
                    </#list>

                    <#if page.hasNext()>
                        <a href="/my-content?page=${page.currentPage() + 1}&size=${page.size()}">Вперёд</a>
                    <#else>
                        <span class="disabled">Вперёд</span>
                    </#if>
                </nav>
            </#if>

            <div class="pagination-info">
                Страница ${page.currentPage() + 1} из ${page.totalPages()},
                всего элементов: ${page.totalElements()}
            </div>
        <#else>
            <div class="empty-state">
                У вас пока нет созданного контента.
            </div>
        </#if>
    </div>
</main>

<#include "/fragments/footer.ftlh">
</body>
</html>