<#-- templates/case/discussion.ftlh -->
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
    <title>Обсуждение кейса — ${discussionPage.title()}</title>

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
            line-height: 1.6;
        }

        .page-wrapper {
            max-width: 980px;
            margin: 0 auto;
            padding: 40px 20px 64px;
        }

        .case-card,
        .comment-form-card,
        .comment-card {
            background: var(--card-bg);
            border: 1px solid var(--border);
            border-radius: 16px;
            box-shadow: 0 8px 24px rgba(15, 23, 42, 0.05);
        }

        .case-card {
            padding: 32px 36px;
            margin-bottom: 28px;
        }

        .case-header {
            display: flex;
            justify-content: space-between;
            gap: 20px;
            align-items: flex-start;
            margin-bottom: 18px;
        }

        .case-title {
            margin: 0 0 10px;
            font-size: 34px;
            line-height: 1.2;
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

        .case-link {
            flex-shrink: 0;
            display: inline-block;
            padding: 10px 16px;
            border-radius: 10px;
            background: var(--link);
            color: #ffffff;
            text-decoration: none;
            font-size: 15px;
            white-space: nowrap;
        }

        .case-link:hover {
            background: var(--link-hover);
        }

        .case-description {
            margin-top: 24px;
            font-size: 17px;
        }

        .case-description h1,
        .case-description h2,
        .case-description h3 {
            margin: 26px 0 12px;
            line-height: 1.25;
            color: #111827;
        }

        .case-description p {
            margin: 14px 0;
        }

        .case-description pre {
            overflow-x: auto;
            padding: 16px 18px;
            border-radius: 12px;
            background: #111827;
            color: #f9fafb;
        }

        .case-description code {
            padding: 2px 6px;
            border-radius: 6px;
            background: #f3f4f6;
            font-family: "JetBrains Mono", "Fira Code", Consolas, monospace;
        }

        .case-description pre code {
            padding: 0;
            background: transparent;
            color: inherit;
        }

        .case-description img {
            display: block;
            max-width: 100%;
            height: auto;
            margin: 24px auto;
            border-radius: 12px;
            border: 1px solid var(--border);
        }

        .section-title {
            margin: 30px 0 16px;
            font-size: 26px;
            line-height: 1.25;
            color: #111827;
        }

        .comment-form-card {
            padding: 24px 28px;
            margin-bottom: 22px;
        }

        .comment-form-title {
            margin: 0 0 14px;
            font-size: 20px;
        }

        .comment-textarea {
            width: 100%;
            min-height: 120px;
            resize: vertical;
            padding: 12px 14px;
            border: 1px solid var(--border);
            border-radius: 12px;
            font: inherit;
            color: var(--text-main);
            background: #ffffff;
        }

        .comment-textarea:focus {
            outline: none;
            border-color: #93c5fd;
            box-shadow: 0 0 0 3px rgba(147, 197, 253, 0.35);
        }

        .comment-submit {
            margin-top: 12px;
            padding: 10px 16px;
            border: none;
            border-radius: 10px;
            background: var(--link);
            color: #ffffff;
            font-size: 15px;
            cursor: pointer;
        }

        .comment-submit:hover {
            background: var(--link-hover);
        }

        .comments {
            display: grid;
            gap: 14px;
        }

        .comment-card {
            padding: 20px 24px;
        }

        .comment-header {
            display: flex;
            justify-content: space-between;
            gap: 16px;
            align-items: flex-start;
            margin-bottom: 10px;
        }

        .comment-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 8px 14px;
            color: var(--text-muted);
            font-size: 14px;
        }

        .comment-author {
            color: #111827;
            font-weight: 650;
        }

        .comment-text {
            margin: 0;
            white-space: pre-wrap;
            overflow-wrap: anywhere;
            font-size: 16px;
        }

        .comment-author-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: #111827;
            text-decoration: none;
            font-weight: 650;
        }

        .comment-author-link:hover {
            color: var(--link-hover);
            text-decoration: underline;
        }

        .comment-avatar {
            width: 28px;
            height: 28px;
            border-radius: 999px;
            object-fit: cover;
            border: 1px solid var(--border);
            background: #f3f4f6;
        }

        .delete-comment-button {
            width: 36px;
            height: 36px;
            border: 1px solid var(--danger-border);
            border-radius: 10px;
            background: var(--danger-bg);
            color: var(--danger);
            cursor: pointer;
            font-size: 17px;
            line-height: 1;
        }

        .delete-comment-button:hover {
            background: #fee2e2;
        }

        .empty-state {
            padding: 28px;
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
            margin-top: 28px;
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

        .page-message {
            display: none;
            margin-bottom: 18px;
            padding: 12px 14px;
            border: 1px solid var(--danger-border);
            border-radius: 12px;
            background: var(--danger-bg);
            color: var(--danger);
            font-size: 14px;
            line-height: 1.45;
        }

        .page-message-error {
            display: block;
        }

        @media (max-width: 700px) {
            .page-wrapper {
                padding: 24px 14px 40px;
            }

            .case-card,
            .comment-form-card,
            .comment-card {
                padding: 20px;
            }

            .case-header {
                display: block;
            }

            .case-link {
                margin-top: 16px;
            }

            .case-title {
                font-size: 28px;
            }

            .pagination {
                flex-wrap: wrap;
            }

            .comment-meta {
                display: flex;
                flex-wrap: wrap;
                align-items: center;
                gap: 8px 12px;
                color: var(--text-muted);
                font-size: 14px;
            }

            .comment-author {
                color: #111827;
                font-weight: 650;
            }

            .comment-author-badge {
                display: inline-flex;
                align-items: center;
                padding: 3px 9px;
                border-radius: 999px;
                background: #eff6ff;
                color: #1d4ed8;
                border: 1px solid #bfdbfe;
                font-size: 12px;
                font-weight: 650;
                line-height: 1.2;
            }
        }
    </style>
</head>
<body>

<main class="page-wrapper">
    <div id="pageMessage" class="page-message"></div>

    <section class="case-card">
        <div class="case-header">
            <div>
                <h1 class="case-title">${discussionPage.title()}</h1>

                <div class="case-meta">
                    <span>Автор: ${discussionPage.owner()}</span>
                    <span>Создано: ${discussionPage.createdAt()}</span>
                </div>
            </div>

            <a class="case-link" href="/cases/${discussionPage.contentItemId()}">
                Перейти к кейсу
            </a>
        </div>

        <div class="case-description">
            <#if discussionPage.description()?has_content>
                ${discussionPage.description()?no_esc}
            <#else>
                <p>Описание кейса отсутствует.</p>
            </#if>
        </div>
    </section>

    <h2 class="section-title">Обсуждение</h2>

    <#if discussionPage.canComment()>
        <section class="comment-form-card">
            <h3 class="comment-form-title">Добавить комментарий</h3>

            <#if commentError?? && commentError?has_content>
                <div style="color: red; margin-bottom: 12px;">
                    ${commentError}
                </div>
            </#if>

            <form method="post" action="/cases/${discussionPage.contentItemId()}/comments">
                <#if csrfToken?has_content>
                    <input type="hidden"
                           name="_csrf"
                           value="${csrfToken}">
                </#if>

                <textarea
                        class="comment-textarea"
                        name="text"
                        placeholder="Напишите комментарий..."
                        required>${(commentText)!''}</textarea>

                <br>

                <button class="comment-submit" type="submit">
                    Отправить
                </button>
            </form>
        </section>
    <#else>
        <div class="empty-state">
            Чтобы оставить комментарий, нужно войти в аккаунт.
        </div>
    </#if>

    <#if discussionPage.caseComments()?has_content>
        <section class="comments" id="comments">
            <#list discussionPage.caseComments() as comment>
                <article class="comment-card" id="comment-${comment.commentId()}">
                    <div class="comment-header">
                        <div class="comment-meta">
                            <a class="comment-author-link" href="/users/${comment.ownerId()}">
                                <#if comment.ownerAvatarUrl()?has_content>
                                    <img
                                            class="comment-avatar"
                                            src="${comment.ownerAvatarUrl()}"
                                            alt="${comment.owner()}"
                                            loading="lazy"
                                    >
                                </#if>

                                <span class="comment-author">${comment.owner()}</span>
                            </a>

                            <#if comment.isAuthor()>
                                <span class="comment-author-badge">Автор кейса</span>
                            </#if>

                            <span>${comment.createdAt()}</span>
                        </div>

                        <#if comment.canDelete()>
                            <button
                                    class="delete-comment-button"
                                    type="button"
                                    data-comment-id="${comment.commentId()}"
                                    title="Удалить комментарий"
                                    aria-label="Удалить комментарий">
                                🗑
                            </button>
                        </#if>
                    </div>

                    <p class="comment-text">${comment.text()}</p>
                </article>
            </#list>
        </section>

        <#if discussionPage.totalPages() gt 1>
            <nav class="pagination">
                <#if discussionPage.hasPrevious()>
                    <a href="/cases/${discussionPage.contentItemId()}/comments?page=${discussionPage.currentPage() - 1}&size=${discussionPage.size()}">Назад</a>
                <#else>
                    <span class="disabled">Назад</span>
                </#if>

                <#list 0..(discussionPage.totalPages() - 1) as pageNumber>
                    <#if pageNumber == discussionPage.currentPage()>
                        <span class="active">${pageNumber + 1}</span>
                    <#else>
                        <a href="/cases/${discussionPage.contentItemId()}/comments?page=${pageNumber}&size=${discussionPage.size()}">${pageNumber + 1}</a>
                    </#if>
                </#list>

                <#if discussionPage.hasNext()>
                    <a href="/cases/${discussionPage.contentItemId()}/comments?page=${discussionPage.currentPage() + 1}&size=${discussionPage.size()}">Вперёд</a>
                <#else>
                    <span class="disabled">Вперёд</span>
                </#if>
            </nav>
        </#if>

        <div class="pagination-info">
            Страница ${discussionPage.currentPage() + 1} из ${discussionPage.totalPages()},
            всего комментариев: ${discussionPage.totalElements()}
        </div>
    <#else>
        <div class="empty-state">
            Комментариев пока нет. Оставьте первый комментарий.
        </div>
    </#if>
</main>

<script>
    const caseId = "${discussionPage.contentItemId()}";

    const csrfHeaderName = <#if csrfHeaderName?has_content>"${csrfHeaderName?js_string}"<#else>null</#if>;
    const csrfToken = <#if csrfToken?has_content>"${csrfToken?js_string}"<#else>null</#if>;

    function showPageMessage(message) {
        const pageMessage = document.getElementById("pageMessage");

        if (!pageMessage) {
            return;
        }

        pageMessage.textContent = message || "Произошла ошибка";
        pageMessage.className = "page-message page-message-error";

        setTimeout(function () {
            pageMessage.textContent = "";
            pageMessage.className = "page-message";
        }, 7000);
    }

    document.addEventListener("click", async function (event) {
        const button = event.target.closest(".delete-comment-button");

        if (!button) {
            return;
        }

        const commentId = button.dataset.commentId;

        if (!commentId) {
            return;
        }

        const confirmed = confirm("Удалить комментарий?");

        if (!confirmed) {
            return;
        }

        const headers = {};

        if (csrfHeaderName && csrfToken) {
            headers[csrfHeaderName] = csrfToken;
        }

        try {
            const response = await fetch("/api/cases/" + caseId + "/comments/" + commentId, {
                method: "DELETE",
                headers: headers
            });

            if (!response.ok) {
                showPageMessage("Не удалось удалить комментарий.");
                return;
            }

            const commentElement = document.getElementById("comment-" + commentId);

            if (commentElement) {
                commentElement.remove();
            }
        } catch (e) {
            console.error(e);
            showPageMessage("Не удалось удалить комментарий.");
        }
    });
</script>

</body>
</html>