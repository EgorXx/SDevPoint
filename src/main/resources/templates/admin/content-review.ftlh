<#-- templates/admin/content-review.ftlh -->

<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Модерация контента</title>

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
            --success: #15803d;
            --success-bg: #f0fdf4;
            --success-border: #bbf7d0;
            --warning-bg: #fffbeb;
            --warning-text: #b45309;
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

        .card-badges {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            justify-content: flex-end;
        }

        .badge {
            display: inline-flex;
            align-items: center;
            padding: 4px 10px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 700;
            white-space: nowrap;
        }

        .badge-pending {
            background: var(--warning-bg);
            color: var(--warning-text);
        }

        .badge-public {
            background: #eff6ff;
            color: #1d4ed8;
        }

        .badge-private {
            background: #f3f4f6;
            color: #4b5563;
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

        .content-actions {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-bottom: 14px;
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

        .approve-button {
            border-color: var(--success-border);
            background: var(--success-bg);
            color: var(--success);
        }

        .approve-button:hover {
            background: #dcfce7;
        }

        .reject-button {
            border-color: var(--danger-border);
            background: var(--danger-bg);
            color: var(--danger);
        }

        .reject-button:hover {
            background: #fee2e2;
        }

        .reject-form {
            display: none;
            margin-top: 12px;
            padding: 14px;
            border: 1px solid var(--danger-border);
            border-radius: 12px;
            background: var(--danger-bg);
        }

        .reject-form textarea {
            width: 100%;
            min-height: 100px;
            resize: vertical;
            padding: 10px 12px;
            border: 1px solid var(--danger-border);
            border-radius: 10px;
            font: inherit;
            background: #ffffff;
            color: var(--text-main);
        }

        .reject-form-actions {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 10px;
        }

        .reject-error {
            display: none;
            margin-top: 8px;
            color: var(--danger);
            font-size: 14px;
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

            .card-badges {
                justify-content: flex-start;
                margin-top: 8px;
            }

            .pagination {
                flex-wrap: wrap;
            }
        }
    </style>
</head>
<body>

<main class="page-wrapper">
    <header class="page-header">
        <h1 class="page-title">Модерация контента</h1>
        <p class="page-description">
            Контент, ожидающий проверки перед публикацией.
        </p>
    </header>

    <#if page.contents()?has_content>
        <section class="content-list" id="contentList">
            <#list page.contents() as content>
                <#assign isArticle = content.itemType() == "ARTICLE">

                <#if isArticle>
                    <#assign typeName = "Статья">
                    <#assign viewUrl = "/articles/" + content.contentItemId()>
                <#else>
                    <#assign typeName = "Кейс">
                    <#assign viewUrl = "/cases/" + content.contentItemId()>
                </#if>

                <#assign isPublic = content.visibility() == "PUBLIC">

                <#if isPublic>
                    <#assign visibilityText = "Публичный">
                    <#assign visibilityClass = "badge-public">
                <#else>
                    <#assign visibilityText = "Приватный">
                    <#assign visibilityClass = "badge-private">
                </#if>

                <article class="content-card" id="content-card-${content.contentItemId()}">
                    <div class="content-card-header">
                        <div>
                            <span class="content-type">${typeName}</span>
                            <h2 class="content-title">${content.title()}</h2>
                        </div>

                        <div class="card-badges">
                            <span class="badge badge-pending">На проверке</span>
                            <span class="badge ${visibilityClass}">${visibilityText}</span>
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

                    <div class="content-actions">
                        <a class="action-link primary" href="${viewUrl}">
                            Подробнее
                        </a>

                        <button
                                class="action-button approve-button"
                                type="button"
                                data-content-id="${content.contentItemId()}"
                                data-card-id="content-card-${content.contentItemId()}">
                            Принять
                        </button>

                        <button
                                class="action-button reject-button"
                                type="button"
                                data-content-id="${content.contentItemId()}"
                                data-form-id="reject-form-${content.contentItemId()}">
                            Отклонить
                        </button>
                    </div>

                    <div class="reject-form" id="reject-form-${content.contentItemId()}">
                        <textarea
                                id="reject-comment-${content.contentItemId()}"
                                placeholder="Причина отклонения..."></textarea>

                        <div class="reject-error" id="reject-error-${content.contentItemId()}"></div>

                        <div class="reject-form-actions">
                            <button
                                    class="action-button reject-button confirm-reject-button"
                                    type="button"
                                    data-content-id="${content.contentItemId()}"
                                    data-card-id="content-card-${content.contentItemId()}"
                                    data-comment-id="reject-comment-${content.contentItemId()}"
                                    data-error-id="reject-error-${content.contentItemId()}">
                                Подтвердить отклонение
                            </button>

                            <button
                                    class="action-button cancel-reject-button"
                                    type="button"
                                    data-form-id="reject-form-${content.contentItemId()}">
                                Отмена
                            </button>
                        </div>
                    </div>
                </article>
            </#list>
        </section>

        <#if page.totalPages() gt 1>
            <nav class="pagination">
                <#if page.hasPrevious()>
                    <a href="/admin/content/review?page=${page.currentPage() - 1}&size=${page.size()}">Назад</a>
                <#else>
                    <span class="disabled">Назад</span>
                </#if>

                <#list 0..(page.totalPages() - 1) as pageNumber>
                    <#if pageNumber == page.currentPage()>
                        <span class="active">${pageNumber + 1}</span>
                    <#else>
                        <a href="/admin/content/review?page=${pageNumber}&size=${page.size()}">${pageNumber + 1}</a>
                    </#if>
                </#list>

                <#if page.hasNext()>
                    <a href="/admin/content/review?page=${page.currentPage() + 1}&size=${page.size()}">Вперёд</a>
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
            Контента на проверке пока нет.
        </div>
    </#if>
</main>

<script>
    const csrfHeaderName = <#if _csrf??>"${_csrf.headerName?js_string}"<#else>null</#if>;
    const csrfToken = <#if _csrf??>"${_csrf.token?js_string}"<#else>null</#if>;

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

    function removeCard(cardId) {
        const card = document.getElementById(cardId);

        if (card) {
            card.remove();
        }

        const contentList = document.getElementById("contentList");

        if (contentList && contentList.children.length === 0) {
            location.reload();
        }
    }

    async function approveContent(button) {
        const contentId = button.dataset.contentId;
        const cardId = button.dataset.cardId;

        if (!contentId || !cardId) {
            return;
        }

        const confirmed = confirm("Одобрить публикацию контента?");

        if (!confirmed) {
            return;
        }

        button.disabled = true;

        try {
            const response = await fetch("/api/admin/content/" + contentId + "/approve", {
                method: "POST",
                headers: buildHeaders(false)
            });

            if (!response.ok) {
                const message = await extractErrorMessage(response, "Не удалось одобрить контент");
                alert(message);
                button.disabled = false;
                return;
            }

            removeCard(cardId);
        } catch (e) {
            console.error(e);
            alert("Не удалось одобрить контент");
            button.disabled = false;
        }
    }

    function showRejectForm(button) {
        const formId = button.dataset.formId;

        if (!formId) {
            return;
        }

        const form = document.getElementById(formId);

        if (form) {
            form.style.display = "block";
        }
    }

    function hideRejectForm(button) {
        const formId = button.dataset.formId;

        if (!formId) {
            return;
        }

        const form = document.getElementById(formId);

        if (form) {
            form.style.display = "none";
        }
    }

    async function rejectContent(button) {
        const contentId = button.dataset.contentId;
        const cardId = button.dataset.cardId;
        const commentId = button.dataset.commentId;
        const errorId = button.dataset.errorId;

        if (!contentId || !cardId || !commentId || !errorId) {
            return;
        }

        const commentInput = document.getElementById(commentId);
        const errorBlock = document.getElementById(errorId);

        const comment = commentInput.value.trim();

        if (!comment) {
            errorBlock.textContent = "Укажите причину отклонения";
            errorBlock.style.display = "block";
            return;
        }

        errorBlock.style.display = "none";
        button.disabled = true;

        try {
            const response = await fetch("/api/admin/content/" + contentId + "/reject", {
                method: "POST",
                headers: buildHeaders(true),
                body: JSON.stringify({
                    comment: comment
                })
            });

            if (!response.ok) {
                const message = await extractErrorMessage(response, "Не удалось отклонить контент");
                errorBlock.textContent = message;
                errorBlock.style.display = "block";
                button.disabled = false;
                return;
            }

            removeCard(cardId);
        } catch (e) {
            console.error(e);
            errorBlock.textContent = "Не удалось отклонить контент";
            errorBlock.style.display = "block";
            button.disabled = false;
        }
    }

    document.addEventListener("click", async function (event) {
        const approveButton = event.target.closest(".approve-button");

        if (approveButton) {
            await approveContent(approveButton);
            return;
        }

        const rejectButton = event.target.closest(".reject-button:not(.confirm-reject-button)");

        if (rejectButton) {
            showRejectForm(rejectButton);
            return;
        }

        const confirmRejectButton = event.target.closest(".confirm-reject-button");

        if (confirmRejectButton) {
            await rejectContent(confirmRejectButton);
            return;
        }

        const cancelRejectButton = event.target.closest(".cancel-reject-button");

        if (cancelRejectButton) {
            hideRejectForm(cancelRejectButton);
        }
    });
</script>

</body>
</html>