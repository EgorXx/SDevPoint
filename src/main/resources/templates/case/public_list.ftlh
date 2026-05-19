<#-- templates/case/public_list.ftlh -->

<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Публичные кейсы</title>

    <style>
        :root {
            --bg: #f6f7f9;
            --card-bg: #ffffff;
            --text-main: #1f2937;
            --text-muted: #6b7280;
            --border: #e5e7eb;
            --link: #2563eb;
            --link-hover: #1d4ed8;
            --star: #f59e0b;
            --star-bg: #fffbeb;
            --star-border: #fde68a;
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

        .cases {
            display: grid;
            gap: 18px;
        }

        .case-card {
            position: relative;
            display: block;
            padding: 24px 72px 24px 28px;
            background: var(--card-bg);
            border: 1px solid var(--border);
            border-radius: 16px;
            box-shadow: 0 8px 24px rgba(15, 23, 42, 0.05);
            color: inherit;
            transition: transform 0.15s ease, box-shadow 0.15s ease, border-color 0.15s ease;
        }

        .case-card:hover {
            transform: translateY(-2px);
            border-color: #cbd5e1;
            box-shadow: 0 12px 30px rgba(15, 23, 42, 0.08);
        }

        .case-card-link {
            display: block;
            color: inherit;
            text-decoration: none;
        }

        .favorite-button {
            position: absolute;
            top: 22px;
            right: 24px;
            width: 42px;
            height: 42px;
            border: 1px solid var(--border);
            border-radius: 12px;
            background: #ffffff;
            color: #9ca3af;
            font-size: 24px;
            line-height: 1;
            cursor: pointer;
            transition: transform 0.12s ease, background 0.12s ease, color 0.12s ease, border-color 0.12s ease;
        }

        .favorite-button.active {
            background: var(--star-bg);
            color: var(--star);
            border-color: var(--star-border);
        }

        .favorite-button:hover {
            transform: scale(1.06);
        }

        .favorite-button:disabled {
            cursor: default;
            opacity: 0.6;
            transform: none;
        }

        .case-title {
            margin: 0 0 10px;
            font-size: 24px;
            line-height: 1.3;
            color: #111827;
        }

        .case-preview {
            margin: 0 0 18px;
            color: #374151;
            line-height: 1.6;
            font-size: 16px;
        }

        .case-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 10px 18px;
            color: var(--text-muted);
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

        .page-error {
            display: none;
            margin-bottom: 18px;
            padding: 12px 14px;
            border: 1px solid #fecaca;
            border-radius: 10px;
            background: #fef2f2;
            color: #991b1b;
            font-size: 15px;
        }

        @media (max-width: 700px) {
            .page-wrapper {
                padding: 24px 14px 40px;
            }

            .page-title {
                font-size: 30px;
            }

            .case-card {
                padding: 20px 64px 20px 20px;
            }

            .favorite-button {
                top: 18px;
                right: 18px;
            }

            .case-title {
                font-size: 21px;
            }

            .pagination {
                flex-wrap: wrap;
            }
        }
    </style>
</head>

<script>
    <#if _csrf??>
    const csrfHeaderName = "${_csrf.headerName?js_string}";
    const csrfToken = "${_csrf.token?js_string}";
    <#else>
    const csrfHeaderName = null;
    const csrfToken = null;
    </#if>

    function showPageError(message) {
        const errorBlock = document.getElementById("pageError");

        if (!errorBlock) {
            return;
        }

        errorBlock.textContent = message;
        errorBlock.style.display = "block";

        setTimeout(function () {
            errorBlock.style.display = "none";
            errorBlock.textContent = "";
        }, 7000);
    }

    document.addEventListener("click", async function (event) {
        const button = event.target.closest(".favorite-button");

        if (!button) {
            return;
        }

        event.preventDefault();
        event.stopPropagation();

        const contentId = button.dataset.contentId;

        if (!contentId) {
            return;
        }

        button.disabled = true;

        const headers = {};

        if (csrfHeaderName && csrfToken) {
            headers[csrfHeaderName] = csrfToken;
        }

        try {
            const response = await fetch("/api/favorites/content/" + contentId, {
                method: "POST",
                headers: headers
            });

            if (response.status === 401) {
                showPageError("Необходимо авторизоваться, чтобы добавить контент в избранное.");
                button.disabled = false;
                return;
            }

            if (response.status === 403) {
                showPageError("Недостаточно прав для изменения избранного.");
                button.disabled = false;
                return;
            }

            if (!response.ok) {
                showPageError("Не удалось изменить избранное.");
                button.disabled = false;
                return;
            }

            const isFavoriteNow = button.classList.toggle("active");

            button.textContent = isFavoriteNow ? "★" : "☆";

            const title = isFavoriteNow
                ? "Убрать из избранного"
                : "Добавить в избранное";

            button.title = title;
            button.setAttribute("aria-label", title);

            button.disabled = false;
        } catch (e) {
            console.error(e);
            showPageError("Не удалось изменить избранное.");
            button.disabled = false;
        }
    });
</script>

<body>
<#include "/fragments/header.ftlh">

<main class="page-wrapper">
    <header class="page-header">
        <h1 class="page-title">Публичные кейсы</h1>
        <p class="page-description">
            Список опубликованных практических кейсов пользователей.
        </p>
    </header>

    <div id="pageError" class="page-error"></div>

    <#if page.cases()?has_content>
        <section class="cases">
            <#list page.cases() as caseItem>
                <article class="case-card" id="case-card-${caseItem.contentItemId()}">
                    <button
                            class="favorite-button <#if caseItem.favorite()>active</#if>"
                            type="button"
                            data-content-id="${caseItem.contentItemId()}"
                            title="<#if caseItem.favorite()>Убрать из избранного<#else>Добавить в избранное</#if>"
                            aria-label="<#if caseItem.favorite()>Убрать из избранного<#else>Добавить в избранное</#if>">
                        <#if caseItem.favorite()>★<#else>☆</#if>
                    </button>

                    <a class="case-card-link" href="/cases/${caseItem.contentItemId()}">
                        <h2 class="case-title">${caseItem.title()}</h2>

                        <#if caseItem.preview()?has_content>
                            <p class="case-preview">${caseItem.preview()}</p>
                        <#else>
                            <p class="case-preview">У кейса пока нет краткого описания.</p>
                        </#if>

                        <div class="case-meta">
                            <span>Автор: ${caseItem.owner()}</span>
                            <span>Создано: ${caseItem.createdAt()}</span>
                        </div>
                    </a>
                </article>
            </#list>
        </section>

        <#if page.totalPages() gt 1>
            <nav class="pagination">
                <#if page.hasPrevious()>
                    <a href="/cases/public?page=${page.currentPage() - 1}&size=${page.size()}">Назад</a>
                <#else>
                    <span class="disabled">Назад</span>
                </#if>

                <#list 0..(page.totalPages() - 1) as pageNumber>
                    <#if pageNumber == page.currentPage()>
                        <span class="active">${pageNumber + 1}</span>
                    <#else>
                        <a href="/cases/public?page=${pageNumber}&size=${page.size()}">${pageNumber + 1}</a>
                    </#if>
                </#list>

                <#if page.hasNext()>
                    <a href="/cases/public?page=${page.currentPage() + 1}&size=${page.size()}">Вперёд</a>
                <#else>
                    <span class="disabled">Вперёд</span>
                </#if>
            </nav>
        </#if>

        <div class="pagination-info">
            Страница ${page.currentPage() + 1} из ${page.totalPages()},
            всего кейсов: ${page.totalElements()}
        </div>
    <#else>
        <div class="empty-state">
            Пока нет опубликованных кейсов.
        </div>
    </#if>
</main>

<#include "/fragments/footer.ftlh">
</body>
</html>