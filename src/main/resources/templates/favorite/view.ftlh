<#-- templates/favorite/view.ftlh -->
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
    <title>Избранное</title>

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

        .content-list {
            display: grid;
            gap: 18px;
        }

        .content-card {
            position: relative;
            display: block;
            padding: 24px 72px 24px 28px;
            background: var(--card-bg);
            border: 1px solid var(--border);
            border-radius: 16px;
            box-shadow: 0 8px 24px rgba(15, 23, 42, 0.05);
            color: inherit;
            text-decoration: none;
            transition: transform 0.15s ease, box-shadow 0.15s ease, border-color 0.15s ease;
        }

        .content-card:hover {
            transform: translateY(-2px);
            border-color: #cbd5e1;
            box-shadow: 0 12px 30px rgba(15, 23, 42, 0.08);
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
            font-size: 23px;
            line-height: 1;
            cursor: pointer;
            transition: transform 0.12s ease, background 0.12s ease, color 0.12s ease, border-color 0.12s ease, opacity 0.12s ease;
        }

        .favorite-button.active {
            border-color: var(--star-border);
            background: var(--star-bg);
            color: var(--star);
        }

        .favorite-button:hover {
            transform: scale(1.06);
        }

        .favorite-button.active:hover {
            background: #fef3c7;
        }

        .favorite-button:disabled {
            cursor: default;
            opacity: 0.55;
            transform: none;
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
                padding: 20px 64px 20px 20px;
            }

            .content-title {
                font-size: 21px;
            }

            .favorite-button {
                top: 18px;
                right: 18px;
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
        <h1 class="page-title">Избранное</h1>
        <p class="page-description">
            Сохранённые статьи и кейсы.
        </p>
    </header>

    <#if page.contents()?has_content>
        <section class="content-list" id="favoriteList">
            <#list page.contents() as content>
                <#assign contentUrl = "/articles/" + content.contentItemId()>
                <#assign contentTypeName = "Статья">

                <#if content.itemType() == "CASE">
                    <#assign contentUrl = "/cases/" + content.contentItemId()>
                    <#assign contentTypeName = "Кейс">
                </#if>

                <article class="content-card" id="favorite-card-${content.contentItemId()}">
                    <button
                            class="favorite-button active"
                            type="button"
                            data-content-id="${content.contentItemId()}"
                            title="Убрать из избранного"
                            aria-label="Убрать из избранного">
                        ★
                    </button>

                    <a href="${contentUrl}" style="color: inherit; text-decoration: none;">
                        <span class="content-type">${contentTypeName}</span>

                        <h2 class="content-title">${content.title()}</h2>

                        <#if content.preview()?has_content>
                            <p class="content-preview">${content.preview()}</p>
                        <#else>
                            <p class="content-preview">Описание отсутствует.</p>
                        </#if>

                        <div class="content-meta">
                            <span>Автор: ${content.owner()}</span>
                            <span>Создано: ${content.createdAt()}</span>
                        </div>
                    </a>
                </article>
            </#list>
        </section>

        <#if page.totalPages() gt 1>
            <nav class="pagination">
                <#if page.hasPrevious()>
                    <a href="/favorites?page=${page.currentPage() - 1}&size=${page.size()}">Назад</a>
                <#else>
                    <span class="disabled">Назад</span>
                </#if>

                <#list 0..(page.totalPages() - 1) as pageNumber>
                    <#if pageNumber == page.currentPage()>
                        <span class="active">${pageNumber + 1}</span>
                    <#else>
                        <a href="/favorites?page=${pageNumber}&size=${page.size()}">${pageNumber + 1}</a>
                    </#if>
                </#list>

                <#if page.hasNext()>
                    <a href="/favorites?page=${page.currentPage() + 1}&size=${page.size()}">Вперёд</a>
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
            В избранном пока ничего нет.
        </div>
    </#if>
</main>

<script>
    const csrfHeaderName = <#if csrfHeaderName?has_content>"${csrfHeaderName?js_string}"<#else>null</#if>;
    const csrfToken = <#if csrfToken?has_content>"${csrfToken?js_string}"<#else>null</#if>;

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

            if (!response.ok) {
                alert("Не удалось изменить избранное");
                button.disabled = false;
                return;
            }

            const isFavoriteNow = button.classList.toggle("active");

            button.textContent = isFavoriteNow ? "★" : "☆";

            const title = isFavoriteNow
                ? "Убрать из избранного"
                : "Вернуть в избранное";

            button.title = title;
            button.setAttribute("aria-label", title);

            button.disabled = false;
        } catch (e) {
            console.error(e);
            alert("Не удалось изменить избранное");
            button.disabled = false;
        }
    });
</script>

<#include "/fragments/footer.ftlh">

</body>
</html>