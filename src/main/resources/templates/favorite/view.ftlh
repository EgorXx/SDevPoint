<#-- templates/favorite/view.ftlh -->
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Избранное</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <#if _csrf??>
        <meta name="csrf-header" content="${_csrf.headerName}">
        <meta name="csrf-token" content="${_csrf.token}">
    </#if>

    <link rel="stylesheet" href="/css/styles.css">
    <script src="/js/favorites.js" defer></script>
</head>

<body class="app-body favorites-page">
<#include "/fragments/header.ftlh">

<main class="favorites">
    <div class="favorites__visual" aria-hidden="true">
        <div class="favorites__dots"></div>
        <div class="favorites__wave"></div>
        <div class="favorites__wave-secondary"></div>
        <div class="favorites__plus"></div>
        <div class="favorites__circle"></div>
    </div>

    <div class="favorites__container">
        <header class="favorites__header">
            <h1 class="favorites__title">Избранное</h1>
            <p class="favorites__description">
                Здесь собраны сохранённые статьи и кейсы.
            </p>
        </header>

        <div id="pageError" class="page-error"></div>

        <#if page.contents()?has_content>
            <section class="favorites__list" id="favoriteList">
                <#list page.contents() as content>
                    <#assign contentUrl = "/articles/" + content.contentItemId()>
                    <#assign contentTypeName = "Статья">
                    <#assign isArticle = true>

                    <#if content.itemType() == "CASE">
                        <#assign contentUrl = "/cases/" + content.contentItemId()>
                        <#assign contentTypeName = "Кейс">
                        <#assign isArticle = false>
                    </#if>

                    <article class="favorites-card" id="favorite-card-${content.contentItemId()}">
                        <div class="favorites-card__type">
                            <span class="favorites-card__type-icon" aria-hidden="true">
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
                                        <path d="M9 14.5H16"
                                              stroke="currentColor"
                                              stroke-width="1.8"
                                              stroke-linecap="round"/>
                                        <path d="M9 17.5H14"
                                              stroke="currentColor"
                                              stroke-width="1.8"
                                              stroke-linecap="round"/>
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
                            <span>${contentTypeName}</span>
                        </div>

                        <a class="favorites-card__content" href="${contentUrl}">
                            <h2 class="favorites-card__title">${content.title()}</h2>

                            <#if content.preview()?has_content>
                                <p class="favorites-card__preview">${content.preview()}</p>
                            <#else>
                                <p class="favorites-card__preview">Описание отсутствует.</p>
                            </#if>

                            <div class="favorites-card__meta">
                                <span class="favorites-card__meta-item">
                                    <span class="favorites-card__meta-icon" aria-hidden="true">
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

                                <span class="favorites-card__dot">•</span>

                                <span class="favorites-card__meta-item">
                                    <span class="favorites-card__meta-icon" aria-hidden="true">
                                        <svg viewBox="0 0 24 24" fill="none">
                                            <path d="M7 4V7"
                                                  stroke="currentColor"
                                                  stroke-width="1.8"
                                                  stroke-linecap="round"/>
                                            <path d="M17 4V7"
                                                  stroke="currentColor"
                                                  stroke-width="1.8"
                                                  stroke-linecap="round"/>
                                            <path d="M5 8.5H19"
                                                  stroke="currentColor"
                                                  stroke-width="1.8"
                                                  stroke-linecap="round"/>
                                            <path d="M6.5 5.5H17.5C18.6 5.5 19.5 6.4 19.5 7.5V18.5C19.5 19.6 18.6 20.5 17.5 20.5H6.5C5.4 20.5 4.5 19.6 4.5 18.5V7.5C4.5 6.4 5.4 5.5 6.5 5.5Z"
                                                  stroke="currentColor"
                                                  stroke-width="1.8"
                                                  stroke-linejoin="round"/>
                                        </svg>
                                    </span>
                                    <span>Создано: ${content.createdAt()}</span>
                                </span>
                            </div>
                        </a>

                        <div class="favorites-card__side">
                            <button
                                    class="favorite-button favorites-heart-button active"
                                    type="button"
                                    data-content-id="${content.contentItemId()}"
                                    title="Убрать из избранного"
                                    aria-label="Убрать из избранного">
                                <span class="favorites-heart-button__icon" aria-hidden="true">
                                    <svg viewBox="0 0 24 24" fill="none">
                                        <path d="M12 20.6L10.55 19.28C5.4 14.6 2 11.52 2 7.75C2 4.67 4.42 2.25 7.5 2.25C9.24 2.25 10.91 3.06 12 4.34C13.09 3.06 14.76 2.25 16.5 2.25C19.58 2.25 22 4.67 22 7.75C22 11.52 18.6 14.6 13.45 19.29L12 20.6Z"
                                              stroke="currentColor"
                                              stroke-width="1.9"
                                              stroke-linecap="round"
                                              stroke-linejoin="round"/>
                                    </svg>
                                </span>
                            </button>

                            <a class="favorites-details-link" href="${contentUrl}">
                                <span>Подробнее</span>
                                <span class="favorites-details-link__icon" aria-hidden="true">
                                    <svg viewBox="0 0 24 24" fill="none">
                                        <path d="M5 12H19"
                                              stroke="currentColor"
                                              stroke-width="1.9"
                                              stroke-linecap="round"/>
                                        <path d="M13 6L19 12L13 18"
                                              stroke="currentColor"
                                              stroke-width="1.9"
                                              stroke-linecap="round"
                                              stroke-linejoin="round"/>
                                    </svg>
                                </span>
                            </a>
                        </div>
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
    </div>
</main>

<#include "/fragments/footer.ftlh">
</body>
</html>