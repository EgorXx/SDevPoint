<#-- templates/case/public_list.ftlh -->
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Публичные кейсы</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <#if _csrf??>
        <meta name="csrf-header" content="${_csrf.headerName}">
        <meta name="csrf-token" content="${_csrf.token}">
    </#if>

    <link rel="stylesheet" href="/css/styles.css">
    <script src="/js/favorites.js" defer></script>
</head>

<body class="app-body cases-public-page">
<#include "/fragments/header.ftlh">

<main class="articles-page cases-page">
    <section class="articles-hero cases-hero">
        <div class="articles-hero__content cases-hero__content">
            <h1 class="articles-hero__title cases-hero__title">Кейсы</h1>
            <p class="articles-hero__description cases-hero__description">
                Подборка практических кейсов и разборов сообщества.
            </p>
        </div>

        <div class="articles-hero__visual cases-hero__visual" aria-hidden="true">
            <div class="articles-visual articles-visual--dots"></div>
            <div class="articles-visual articles-visual--wave"></div>
            <div class="articles-visual articles-visual--wave-secondary"></div>
        </div>
    </section>

    <section class="articles-content cases-content">
        <div id="pageError" class="page-error"></div>

        <#if page.cases()?has_content>
            <section class="articles-grid cases-grid" aria-label="Список кейсов">
                <#list page.cases() as caseItem>
                    <article class="article-card case-card" id="case-card-${caseItem.contentItemId()}">
                        <a class="article-card-link case-card-link" href="/cases/${caseItem.contentItemId()}">
                            <div class="article-card__meta case-card__meta">
                                <span>Автор: ${caseItem.owner()}</span>
                            </div>

                            <h2 class="article-card__title case-card__title">${caseItem.title()}</h2>

                            <#if caseItem.preview()?has_content>
                                <p class="article-card__preview case-card__preview">${caseItem.preview()}</p>
                            <#else>
                                <p class="article-card__preview case-card__preview">У кейса пока нет краткого описания.</p>
                            </#if>

                            <div class="article-card__date case-card__date">
                                ${caseItem.createdAt()}
                            </div>
                        </a>

                        <button
                                class="favorite-button <#if caseItem.favorite()>active</#if>"
                                type="button"
                                data-content-id="${caseItem.contentItemId()}"
                                title="<#if caseItem.favorite()>Убрать из избранного<#else>Добавить в избранное</#if>"
                                aria-label="<#if caseItem.favorite()>Убрать из избранного<#else>Добавить в избранное</#if>">
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
                <nav class="pagination" aria-label="Пагинация кейсов">
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
    </section>
</main>

<#include "/fragments/footer.ftlh">
</body>
</html>