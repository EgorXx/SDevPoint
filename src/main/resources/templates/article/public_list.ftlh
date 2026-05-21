<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Публичные статьи</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <#if _csrf??>
        <meta name="csrf-header" content="${_csrf.headerName}">
        <meta name="csrf-token" content="${_csrf.token}">
    </#if>

    <link rel="stylesheet" href="/css/styles.css">
    <script src="/js/articles-public.js" defer></script>
</head>

<body class="app-body articles-public-page">
<#include "/fragments/header.ftlh">

<main class="articles-page">
    <section class="articles-hero">
        <div class="articles-hero__content">
            <h1 class="articles-hero__title">Статьи</h1>
            <p class="articles-hero__description">
                Подборка технических статей и заметок сообщества.
            </p>
        </div>

        <div class="articles-hero__visual" aria-hidden="true">
            <div class="articles-visual articles-visual--dots"></div>
            <div class="articles-visual articles-visual--wave"></div>
            <div class="articles-visual articles-visual--wave-secondary"></div>
        </div>
    </section>

    <section class="articles-content">
        <div id="pageError" class="page-error"></div>

        <#if page.articles()?has_content>
            <section class="articles-grid" aria-label="Список статей">
                <#list page.articles() as article>
                    <article class="article-card" id="article-card-${article.contentItemId()}">
                        <a class="article-card-link" href="/articles/${article.contentItemId()}">
                            <div class="article-card__meta">
                                <span>Автор: ${article.owner()}</span>
                            </div>

                            <h2 class="article-card__title">${article.title()}</h2>

                            <#if article.preview()?has_content>
                                <p class="article-card__preview">${article.preview()}</p>
                            <#else>
                                <p class="article-card__preview">У статьи пока нет описания.</p>
                            </#if>

                            <div class="article-card__date">
                                ${article.createdAt()}
                            </div>
                        </a>

                        <button
                                class="favorite-button <#if article.favorite()>active</#if>"
                                type="button"
                                data-content-id="${article.contentItemId()}"
                                title="<#if article.favorite()>Убрать из избранного<#else>Добавить в избранное</#if>"
                                aria-label="<#if article.favorite()>Убрать из избранного<#else>Добавить в избранное</#if>">
                            <span class="favorite-button__icon" aria-hidden="true">
                                <svg viewBox="0 0 24 24" fill="none">
                                    <path d="M12 20.6L10.55 19.28C5.4 14.6 2 11.52 2 7.75C2 4.67 4.42 2.25 7.5 2.25C9.24 2.25 10.91 3.06 12 4.34C13.09 3.06 14.76 2.25 16.5 2.25C19.58 2.25 22 4.67 22 7.75C22 11.52 18.6 14.6 13.45 19.29L12 20.6Z"
                                          stroke="currentColor"
                                          stroke-width="1.9"
                                          stroke-linecap="round"
                                          stroke-linejoin="round"/>
                                </svg>
                            </span>
                        </button>
                    </article>
                </#list>
            </section>

            <#if page.totalPages() gt 1>
                <nav class="pagination" aria-label="Пагинация статей">
                    <#if page.hasPrevious()>
                        <a href="/articles/public?page=${page.currentPage() - 1}&size=${page.size()}">Назад</a>
                    <#else>
                        <span class="disabled">Назад</span>
                    </#if>

                    <#list 0..(page.totalPages() - 1) as pageNumber>
                        <#if pageNumber == page.currentPage()>
                            <span class="active">${pageNumber + 1}</span>
                        <#else>
                            <a href="/articles/public?page=${pageNumber}&size=${page.size()}">${pageNumber + 1}</a>
                        </#if>
                    </#list>

                    <#if page.hasNext()>
                        <a href="/articles/public?page=${page.currentPage() + 1}&size=${page.size()}">Вперёд</a>
                    <#else>
                        <span class="disabled">Вперёд</span>
                    </#if>
                </nav>
            </#if>

            <div class="pagination-info">
                Страница ${page.currentPage() + 1} из ${page.totalPages()},
                всего статей: ${page.totalElements()}
            </div>
        <#else>
            <div class="empty-state">
                Пока нет опубликованных статей.
            </div>
        </#if>
    </section>
</main>

<#include "/fragments/footer.ftlh">
</body>
</html>