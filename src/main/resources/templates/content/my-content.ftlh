<#-- templates/content/my-content.ftlh -->
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
    <title>Мой контент</title>

    <style>
        :root {
            --bg: #f6f7f9;
            --card-bg: #ffffff;
            --text-main: #1f2937;
            --text-muted: #6b7280;
            --border: #e5e7eb;
            --link: #2563eb;
            --link-hover: #1d4ed8;
            --danger: #dc2626;
            --danger-bg: #fef2f2;
            --danger-border: #fecaca;
            --warning-bg: #fffbeb;
            --warning-text: #b45309;
            --success-bg: #f0fdf4;
            --success-text: #15803d;
            --rejected-bg: #fef2f2;
            --rejected-text: #b91c1c;
            --draft-bg: #f3f4f6;
            --draft-text: #4b5563;
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
        }

        .page-wrapper {
            max-width: 980px;
            margin: 0 auto;
            padding: 40px 20px 64px;
        }

        .page-header {
            margin-bottom: 32px;
        }

        .page-title {
            margin: 0 0 8px;
            font-size: 36px;
            line-height: 1.2;
            letter-spacing: -0.03em;
        }

        .page-description {
            margin: 0;
            color: var(--text-muted);
            font-size: 16px;
        }

        .content-list {
            display: grid;
            gap: 18px;
        }

        .content-card {
            padding: 24px 28px;
            background: var(--card-bg);
            border: 1px solid var(--border);
            border-radius: 16px;
            box-shadow: 0 8px 24px rgba(15, 23, 42, 0.05);
        }

        .content-card-header {
            display: flex;
            justify-content: space-between;
            gap: 16px;
            align-items: flex-start;
            margin-bottom: 12px;
        }

        .content-type {
            display: inline-flex;
            align-items: center;
            margin-bottom: 10px;
            padding: 3px 9px;
            border-radius: 999px;
            background: #eff6ff;
            color: #1d4ed8;
            border: 1px solid #bfdbfe;
            font-size: 12px;
            font-weight: 650;
            line-height: 1.3;
        }

        .status-badge {
            display: inline-flex;
            align-items: center;
            padding: 4px 10px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 700;
            white-space: nowrap;
        }

        .status-draft {
            background: var(--draft-bg);
            color: var(--draft-text);
        }

        .status-pending {
            background: var(--warning-bg);
            color: var(--warning-text);
        }

        .status-published {
            background: var(--success-bg);
            color: var(--success-text);
        }

        .status-rejected {
            background: var(--rejected-bg);
            color: var(--rejected-text);
        }

        .content-title {
            margin: 0 0 10px;
            font-size: 24px;
            line-height: 1.3;
            color: #111827;
        }

        .content-preview {
            margin: 0 0 18px;
            color: #374151;
            line-height: 1.6;
            font-size: 16px;
        }

        .content-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 10px 18px;
            color: var(--text-muted);
            font-size: 14px;
            margin-bottom: 18px;
        }

        .rejection-notice {
            margin: 0 0 14px;
            padding: 12px 14px;
            border: 1px solid var(--danger-border);
            border-radius: 12px;
            background: var(--danger-bg);
            color: var(--rejected-text);
            font-size: 14px;
        }

        .rejection-comment {
            display: none;
            margin: 0 0 16px;
            padding: 12px 14px;
            border: 1px solid var(--border);
            border-radius: 12px;
            background: #f9fafb;
            color: #374151;
            white-space: pre-wrap;
            overflow-wrap: anywhere;
            font-size: 14px;
        }

        .content-actions {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }

        .action-link,
        .action-button {
            display: inline-flex;
            align-items: center;
            justify-content: center;
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

        .action-link.primary {
            border-color: #bfdbfe;
            background: #eff6ff;
            color: var(--link);
        }

        .action-link.primary:hover {
            color: var(--link-hover);
            border-color: #93c5fd;
        }

        .action-link:hover,
        .action-button:hover {
            border-color: #cbd5e1;
            background: #f9fafb;
        }

        .withdraw-button {
            border-color: #fde68a;
            background: #fffbeb;
            color: #b45309;
        }

        .withdraw-button:hover {
            background: #fef3c7;
        }

        .delete-button {
            border-color: var(--danger-border);
            background: var(--danger-bg);
            color: var(--danger);
        }

        .delete-button:hover {
            background: #fee2e2;
        }

        .empty-state {
            padding: 32px;
            background: var(--card-bg);
            border: 1px solid var(--border);
            border-radius: 16px;
            color: var(--text-muted);
            text-align: center;
        }

        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 8px;
            margin-top: 34px;
        }

        .pagination a,
        .pagination span {
            min-width: 38px;
            padding: 9px 12px;
            border: 1px solid var(--border);
            border-radius: 10px;
            background: var(--card-bg);
            color: var(--text-main);
            text-align: center;
            text-decoration: none;
            font-size: 14px;
        }

        .pagination a:hover {
            color: var(--link-hover);
            border-color: #bfdbfe;
            background: #eff6ff;
        }

        .pagination .active {
            color: #ffffff;
            border-color: var(--link);
            background: var(--link);
        }

        .pagination .disabled {
            color: #9ca3af;
            background: #f3f4f6;
        }

        .pagination-info {
            margin-top: 14px;
            color: var(--text-muted);
            text-align: center;
            font-size: 14px;
        }

        .visibility-badge {
            display: inline-flex;
            align-items: center;
            padding: 4px 10px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 700;
            white-space: nowrap;
        }

        .visibility-public {
            background: #eff6ff;
            color: #1d4ed8;
        }

        .visibility-private {
            background: #f3f4f6;
            color: #4b5563;
        }

        .card-badges {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            justify-content: flex-end;
        }

        .create-actions {
            display: flex;
            gap: 10px;
            margin-top: 18px;
        }

        .create-button {
            display: inline-flex;
            align-items: center;
            min-height: 38px;
            padding: 9px 16px;
            border: none;
            border-radius: 10px;
            background: var(--link);
            color: #ffffff;
            font: inherit;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.12s;
        }

        .create-button:hover {
            background: var(--link-hover);
        }

        .create-button-secondary {
            background: #ffffff;
            color: var(--text-main);
            border: 1px solid var(--border);
        }

        .create-button-secondary:hover {
            background: #f3f4f6;
        }

        @media (max-width: 700px) {
            .page-wrapper {
                padding: 24px 14px 40px;
            }

            .page-title {
                font-size: 30px;
            }

            .content-card {
                padding: 20px;
            }

            .content-title {
                font-size: 21px;
            }

            .content-card-header {
                display: block;
            }

            .status-badge {
                margin-top: 8px;
            }

            .pagination {
                flex-wrap: wrap;
            }
        }
    </style>
</head>
<body>
<#include "/fragments/header.ftlh">

<main class="page-wrapper">
    <header class="page-header">
        <h1 class="page-title">Мой контент</h1>
        <p class="page-description">
            Здесь отображаются ваши статьи и кейсы.
        </p>

        <div class="create-actions">
            <form method="post" action="/articles/drafts" style="display:inline;">
                <#if _csrf??>
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                </#if>
                <button type="submit" class="create-button">Создать статью</button>
            </form>

            <form method="post" action="/cases/drafts" style="display:inline;">
                <#if _csrf??>
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                </#if>
                <button type="submit" class="create-button create-button-secondary">Создать кейс</button>
            </form>
        </div>
    </header>

    <#if page.contents()?has_content>
        <section class="content-list" id="contentList">
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
                    <#assign statusClass = "status-draft">
                <#elseif isPending>
                    <#assign statusText = "На проверке">
                    <#assign statusClass = "status-pending">
                <#elseif isPublished>
                    <#assign statusText = "Опубликовано">
                    <#assign statusClass = "status-published">
                <#elseif isRejected>
                    <#assign statusText = "Отклонено">
                    <#assign statusClass = "status-rejected">
                <#else>
                    <#assign statusText = content.contentStatus()>
                    <#assign statusClass = "status-draft">
                </#if>

                <#assign isPublic = content.visibility() == "PUBLIC">
                <#assign isPrivate = content.visibility() == "PRIVATE">

                <#if isPublic>
                    <#assign visibilityText = "Публичный">
                    <#assign visibilityClass = "visibility-public">
                <#elseif isPrivate>
                    <#assign visibilityText = "Приватный">
                    <#assign visibilityClass = "visibility-private">
                <#else>
                    <#assign visibilityText = content.visibility()>
                    <#assign visibilityClass = "visibility-private">
                </#if>

                <article class="content-card" id="content-card-${content.contentItemId()}">
                    <div class="content-card-header">
                        <div>
                            <span class="content-type">${typeName}</span>
                            <h2 class="content-title">${content.title()}</h2>
                        </div>

                        <div class="card-badges">
                            <span class="status-badge ${statusClass}">
                                ${statusText}
                            </span>

                            <span class="visibility-badge ${visibilityClass}">
                                ${visibilityText}
                            </span>
                        </div>
                    </div>

                    <#if content.preview()?has_content>
                        <p class="content-preview">${content.preview()}</p>
                    <#else>
                        <p class="content-preview">Описание отсутствует.</p>
                    </#if>

                    <div class="content-meta">
                        <span>Автор: ${content.owner()}</span>
                        <span>Создано: ${content.createdAt()}</span>
                    </div>

                    <#if isRejected>
                        <div class="rejection-notice">
                            Контент отклонён. Можно посмотреть комментарий модерации и отредактировать материал.
                        </div>

                        <div
                                class="rejection-comment"
                                id="rejection-comment-${content.contentItemId()}">
                        </div>
                    </#if>

                    <div class="content-actions">
                        <#if isDraft>
                            <a class="action-link primary" href="${draftEditUrl}">
                                Продолжить редактирование
                            </a>

                            <button
                                    class="action-button delete-button"
                                    type="button"
                                    data-delete-url="${deleteUrl}"
                                    data-card-id="content-card-${content.contentItemId()}">
                                Удалить
                            </button>
                        </#if>

                        <#if isPending>
                            <a class="action-link primary" href="${viewUrl}">
                                Подробнее
                            </a>

                            <button
                                    class="action-button withdraw-button"
                                    type="button"
                                    data-content-id="${content.contentItemId()}">
                                Отозвать с проверки
                            </button>

                            <button
                                    class="action-button delete-button"
                                    type="button"
                                    data-delete-url="${deleteUrl}"
                                    data-card-id="content-card-${content.contentItemId()}">
                                Удалить
                            </button>
                        </#if>

                        <#if isPublished>
                            <a class="action-link primary" href="${viewUrl}">
                                Подробнее
                            </a>

                            <a class="action-link" href="${editUrl}">
                                Редактировать
                            </a>

                            <button
                                    class="action-button delete-button"
                                    type="button"
                                    data-delete-url="${deleteUrl}"
                                    data-card-id="content-card-${content.contentItemId()}">
                                Удалить
                            </button>
                        </#if>

                        <#if isRejected>
                            <a class="action-link primary" href="${viewUrl}">
                                Подробнее
                            </a>

                            <a class="action-link" href="${editUrl}">
                                Редактировать
                            </a>

                            <button
                                    class="action-button show-rejection-comment-button"
                                    type="button"
                                    data-content-id="${content.contentItemId()}">
                                Показать комментарий
                            </button>

                            <button
                                    class="action-button delete-button"
                                    type="button"
                                    data-delete-url="${deleteUrl}"
                                    data-card-id="content-card-${content.contentItemId()}">
                                Удалить
                            </button>
                        </#if>
                    </div>
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
</main>

<script>
    const csrfHeaderName = <#if csrfHeaderName?has_content>"${csrfHeaderName?js_string}"<#else>null</#if>;
    const csrfToken = <#if csrfToken?has_content>"${csrfToken?js_string}"<#else>null</#if>;

    function buildHeaders(jsonBody) {
        const headers = {};

        if (csrfHeaderName && csrfToken) {
            headers[csrfHeaderName] = csrfToken;
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

                return defaultMessage;
            } catch (e) {
                return defaultMessage;
            }
        }

        try {
            const text = await response.text();

            if (text && text.trim().length > 0) {
                return text;
            }

            return defaultMessage;
        } catch (e) {
            return defaultMessage;
        }
    }

    async function deleteContent(button) {
        const deleteUrl = button.dataset.deleteUrl;
        const cardId = button.dataset.cardId;

        if (!deleteUrl || !cardId) {
            return;
        }

        const confirmed = confirm("Удалить этот контент?");

        if (!confirmed) {
            return;
        }

        button.disabled = true;

        try {
            const response = await fetch(deleteUrl, {
                method: "DELETE",
                headers: buildHeaders(false)
            });

            if (!response.ok) {
                const message = await extractErrorMessage(response, "Не удалось удалить контент");
                alert(message);
                button.disabled = false;
                return;
            }

            const card = document.getElementById(cardId);

            if (card) {
                card.remove();
            }

            const contentList = document.getElementById("contentList");

            if (contentList && contentList.children.length === 0) {
                location.reload();
            }
        } catch (e) {
            console.error(e);
            alert("Не удалось удалить контент");
            button.disabled = false;
        }
    }

    async function withdrawContent(button) {
        const contentId = button.dataset.contentId;

        if (!contentId) {
            return;
        }

        const confirmed = confirm("Отозвать контент с проверки?");

        if (!confirmed) {
            return;
        }

        button.disabled = true;

        try {
            const response = await fetch("/api/content/" + contentId + "/withdraw", {
                method: "POST",
                headers: buildHeaders(false)
            });

            if (!response.ok) {
                const message = await extractErrorMessage(response, "Не удалось отозвать контент");
                alert(message);
                button.disabled = false;
                return;
            }

            location.reload();
        } catch (e) {
            console.error(e);
            alert("Не удалось отозвать контент");
            button.disabled = false;
        }
    }

    async function toggleRejectionComment(button) {
        const contentId = button.dataset.contentId;

        if (!contentId) {
            return;
        }

        const commentBlock = document.getElementById("rejection-comment-" + contentId);

        if (!commentBlock) {
            return;
        }

        if (commentBlock.style.display === "block") {
            commentBlock.style.display = "none";
            button.textContent = "Показать комментарий";
            return;
        }

        button.disabled = true;

        try {
            const response = await fetch("/api/my-content/" + contentId + "/rejection-comment");

            if (!response.ok) {
                const message = await extractErrorMessage(response, "Не удалось загрузить комментарий");
                alert(message);
                button.disabled = false;
                return;
            }

            const body = await response.json();

            commentBlock.textContent = body.comment || "Комментарий отсутствует";
            commentBlock.style.display = "block";
            button.textContent = "Скрыть комментарий";
            button.disabled = false;
        } catch (e) {
            console.error(e);
            alert("Не удалось загрузить комментарий");
            button.disabled = false;
        }
    }

    document.addEventListener("click", async function (event) {
        const deleteButton = event.target.closest(".delete-button");

        if (deleteButton) {
            await deleteContent(deleteButton);
            return;
        }

        const withdrawButton = event.target.closest(".withdraw-button");

        if (withdrawButton) {
            await withdrawContent(withdrawButton);
            return;
        }

        const rejectionCommentButton = event.target.closest(".show-rejection-comment-button");

        if (rejectionCommentButton) {
            await toggleRejectionComment(rejectionCommentButton);
        }
    });
</script>

<#include "/fragments/footer.ftlh">
</body>
</html>