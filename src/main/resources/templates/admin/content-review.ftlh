<#-- templates/admin/content-review.ftlh -->
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Модерация контента</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <#if _csrf??>
        <meta name="csrf-header" content="${_csrf.headerName}">
        <meta name="csrf-token" content="${_csrf.token}">
    </#if>

    <link rel="stylesheet" href="/css/styles.css">
    <script src="/js/admin-content-review.js" defer></script>
</head>

<body class="app-body moderation-page">
<#include "/fragments/header.ftlh">

<main class="moderation">
    <div class="moderation__visual" aria-hidden="true">
        <div class="moderation__dots"></div>
        <div class="moderation__wave"></div>
        <div class="moderation__wave-secondary"></div>
    </div>

    <div class="moderation__container">
        <header class="moderation__header">
            <h1 class="moderation__title">Модерация контента</h1>
            <p class="moderation__description">
                Контент, ожидающий проверки перед публикацией.
            </p>
        </header>

        <#if page.contents()?has_content>
            <section class="moderation__list" id="contentList">
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

                    <article class="moderation-card content-card" id="content-card-${content.contentItemId()}">
                        <div class="moderation-card__main">
                            <div class="moderation-card__content">
                                <div class="moderation-card__type">
                                    <span class="moderation-card__type-icon" aria-hidden="true">
                                        <#if isArticle>
                                            <svg viewBox="0 0 24 24" fill="none">
                                                <path d="M7 3.5H14.5L19 8V20.5H7V3.5Z"
                                                      stroke="currentColor"
                                                      stroke-width="1.9"
                                                      stroke-linejoin="round"/>
                                                <path d="M14.5 3.5V8H19"
                                                      stroke="currentColor"
                                                      stroke-width="1.9"
                                                      stroke-linejoin="round"/>
                                                <path d="M10 12H16M10 15.5H16"
                                                      stroke="currentColor"
                                                      stroke-width="1.9"
                                                      stroke-linecap="round"/>
                                            </svg>
                                        <#else>
                                            <svg viewBox="0 0 24 24" fill="none">
                                                <path d="M3.5 7.5H9L11 9.5H20.5V19H3.5V7.5Z"
                                                      stroke="currentColor"
                                                      stroke-width="1.9"
                                                      stroke-linejoin="round"/>
                                                <path d="M3.5 7.5V5H8.5L10.5 7.5"
                                                      stroke="currentColor"
                                                      stroke-width="1.9"
                                                      stroke-linejoin="round"/>
                                            </svg>
                                        </#if>
                                    </span>
                                    <span>${typeName}</span>
                                </div>

                                <h2 class="moderation-card__title">${content.title()}</h2>

                                <#if content.preview()?has_content>
                                    <p class="moderation-card__preview">${content.preview()}</p>
                                <#else>
                                    <p class="moderation-card__preview">Описание отсутствует.</p>
                                </#if>

                                <div class="moderation-card__meta">
                                    <span class="moderation-card__meta-item">
                                        <span class="moderation-card__meta-icon" aria-hidden="true">
                                            <svg viewBox="0 0 24 24" fill="none">
                                                <path d="M12 12C14.21 12 16 10.21 16 8C16 5.79 14.21 4 12 4C9.79 4 8 5.79 8 8C8 10.21 9.79 12 12 12Z"
                                                      stroke="currentColor"
                                                      stroke-width="1.8"/>
                                                <path d="M5 20C5.75 16.75 8.25 15 12 15C15.75 15 18.25 16.75 19 20"
                                                      stroke="currentColor"
                                                      stroke-width="1.8"
                                                      stroke-linecap="round"/>
                                            </svg>
                                        </span>
                                        <span>Автор: ${content.owner()}</span>
                                    </span>

                                    <span class="moderation-card__dot">•</span>

                                    <span class="moderation-card__meta-item">
                                        <span class="moderation-card__meta-icon" aria-hidden="true">
                                            <svg viewBox="0 0 24 24" fill="none">
                                                <path d="M7 4V7M17 4V7M5 9H19M6 6H18C18.55 6 19 6.45 19 7V19C19 19.55 18.55 20 18 20H6C5.45 20 5 19.55 5 19V7C5 6.45 5.45 6 6 6Z"
                                                      stroke="currentColor"
                                                      stroke-width="1.8"
                                                      stroke-linecap="round"
                                                      stroke-linejoin="round"/>
                                            </svg>
                                        </span>
                                        <span>Создано: ${content.createdAt()}</span>
                                    </span>
                                </div>
                            </div>

                            <aside class="moderation-card__side">
                                <div class="moderation-card__badges card-badges">
                                    <span class="moderation-badge moderation-badge--pending badge badge-pending">
                                        На проверке
                                    </span>

                                    <span class="moderation-badge moderation-badge--visibility badge ${visibilityClass}">
                                        <span class="moderation-badge__icon" aria-hidden="true">
                                            <#if isPublic>
                                                <svg viewBox="0 0 24 24" fill="none">
                                                    <path d="M12 21C16.97 21 21 16.97 21 12C21 7.03 16.97 3 12 3C7.03 3 3 7.03 3 12C3 16.97 7.03 21 12 21Z"
                                                          stroke="currentColor"
                                                          stroke-width="1.8"/>
                                                    <path d="M3.6 9H20.4M3.6 15H20.4M12 3C14 5.2 15 8.2 15 12C15 15.8 14 18.8 12 21M12 3C10 5.2 9 8.2 9 12C9 15.8 10 18.8 12 21"
                                                          stroke="currentColor"
                                                          stroke-width="1.8"
                                                          stroke-linecap="round"/>
                                                </svg>
                                            <#else>
                                                <svg viewBox="0 0 24 24" fill="none">
                                                    <path d="M7 10V8C7 5.24 8.79 3.5 12 3.5C15.21 3.5 17 5.24 17 8V10"
                                                          stroke="currentColor"
                                                          stroke-width="1.8"
                                                          stroke-linecap="round"/>
                                                    <path d="M6.5 10H17.5C18.05 10 18.5 10.45 18.5 11V19.5C18.5 20.05 18.05 20.5 17.5 20.5H6.5C5.95 20.5 5.5 20.05 5.5 19.5V11C5.5 10.45 5.95 10 6.5 10Z"
                                                          stroke="currentColor"
                                                          stroke-width="1.8"/>
                                                </svg>
                                            </#if>
                                        </span>
                                        <span>${visibilityText}</span>
                                    </span>
                                </div>

                                <div class="moderation-card__actions content-actions">
                                    <a class="moderation-action moderation-action--details action-link primary" href="${viewUrl}">
                                        Подробнее
                                    </a>

                                    <button
                                            class="moderation-action moderation-action--approve action-button approve-button"
                                            type="button"
                                            data-content-id="${content.contentItemId()}"
                                            data-card-id="content-card-${content.contentItemId()}">
                                        Принять
                                    </button>

                                    <button
                                            class="moderation-action moderation-action--reject action-button reject-button"
                                            type="button"
                                            data-content-id="${content.contentItemId()}"
                                            data-form-id="reject-form-${content.contentItemId()}">
                                        Отклонить
                                    </button>
                                </div>
                            </aside>
                        </div>

                        <div class="moderation-reject-form reject-form" id="reject-form-${content.contentItemId()}">
                            <label class="moderation-reject-form__label" for="reject-comment-${content.contentItemId()}">
                                Причина отклонения
                            </label>

                            <textarea
                                    class="moderation-reject-textarea"
                                    id="reject-comment-${content.contentItemId()}"
                                    rows="1"
                                    placeholder="Причина отклонения..."></textarea>

                            <div class="moderation-reject-error reject-error" id="reject-error-${content.contentItemId()}"></div>

                            <div class="moderation-reject-form__actions reject-form-actions">
                                <button
                                        class="moderation-action moderation-action--confirm-reject action-button reject-button confirm-reject-button"
                                        type="button"
                                        data-content-id="${content.contentItemId()}"
                                        data-card-id="content-card-${content.contentItemId()}"
                                        data-comment-id="reject-comment-${content.contentItemId()}"
                                        data-error-id="reject-error-${content.contentItemId()}">
                                    Подтвердить отклонение
                                </button>

                                <button
                                        class="moderation-action moderation-action--cancel action-button cancel-reject-button"
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
    </div>
</main>

</body>
</html>