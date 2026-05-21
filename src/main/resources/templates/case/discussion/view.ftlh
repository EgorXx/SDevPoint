<#-- templates/case/discussion.ftlh -->
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Обсуждение кейса — ${discussionPage.title()}</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <#if _csrf??>
        <meta name="csrf-header" content="${_csrf.headerName}">
        <meta name="csrf-token" content="${_csrf.token}">
    </#if>

    <link rel="stylesheet" href="/css/styles.css">
    <script src="/js/case-discussion.js" defer></script>
</head>

<body class="app-body case-discussion-page">
<#include "/fragments/header.ftlh">

<main class="case-discussion" data-case-id="${discussionPage.contentItemId()}">
    <div class="case-discussion__visual" aria-hidden="true">
        <div class="case-discussion__dots"></div>
        <div class="case-discussion__wave"></div>
        <div class="case-discussion__wave-secondary"></div>
        <div class="case-discussion__plus"></div>
        <div class="case-discussion__circle"></div>
    </div>

    <div class="case-discussion__container">
        <div id="pageMessage" class="discussion-message"></div>

        <header class="case-discussion__hero">
            <div class="case-discussion__hero-content">
                <h1 class="case-discussion__title">
                    ${discussionPage.title()}
                </h1>

                <div class="case-discussion__meta">
                    <span class="case-discussion__meta-item">
                        <span class="case-discussion__meta-icon" aria-hidden="true">
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
                        <span>Автор: ${discussionPage.owner()}</span>
                    </span>

                    <span class="case-discussion__meta-dot">•</span>

                    <span class="case-discussion__meta-item">
                        <span class="case-discussion__meta-icon" aria-hidden="true">
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
                        <span>Создано: ${discussionPage.createdAt()}</span>
                    </span>
                </div>

                <a class="case-discussion__case-link" href="/cases/${discussionPage.contentItemId()}">
                    <span class="case-discussion__case-link-icon" aria-hidden="true">
                        <svg viewBox="0 0 24 24" fill="none">
                            <path d="M4 7.5C4 6.67 4.67 6 5.5 6H10L12 8H18.5C19.33 8 20 8.67 20 9.5V17.5C20 18.33 19.33 19 18.5 19H5.5C4.67 19 4 18.33 4 17.5V7.5Z"
                                  stroke="currentColor"
                                  stroke-width="1.8"
                                  stroke-linejoin="round"/>
                        </svg>
                    </span>
                    <span>Перейти к кейсу</span>
                </a>
            </div>
        </header>

        <section class="case-discussion__description-card">
            <div class="case-discussion__section-header">
                <span class="case-discussion__section-icon" aria-hidden="true">
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
                </span>

                <h2 class="case-discussion__section-title">Описание кейса</h2>
            </div>

            <div class="case-discussion__description content-markdown">
                <#if discussionPage.description()?has_content>
                    ${discussionPage.description()?no_esc}
                <#else>
                    <p class="empty-content">Описание кейса отсутствует.</p>
                </#if>
            </div>
        </section>

        <section class="case-discussion__comments-card">
            <h2 class="case-discussion__comments-title">Обсуждение</h2>

            <#if discussionPage.canComment()>
                <section class="discussion-form-card">
                    <#if commentError?? && commentError?has_content>
                        <div class="discussion-form-error">
                            ${commentError}
                        </div>
                    </#if>

                    <form
                            class="discussion-comment-form"
                            method="post"
                            action="/cases/${discussionPage.contentItemId()}/comments">
                        <#if _csrf??>
                            <input
                                    type="hidden"
                                    name="${_csrf.parameterName}"
                                    value="${_csrf.token}">
                        </#if>

                        <textarea
                                class="discussion-comment-textarea"
                                name="text"
                                placeholder="Напишите комментарий..."
                                rows="1"
                                required>${(commentText)!''}</textarea>

                        <button class="discussion-comment-submit" type="submit">
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
                <section class="discussion-comments" id="comments">
                    <#list discussionPage.caseComments() as comment>
                        <article class="discussion-comment-card" id="comment-${comment.commentId()}">
                            <div class="discussion-comment-card__main">
                                <a class="discussion-comment-card__avatar-link" href="/users/${comment.ownerId()}">
                                    <#if comment.ownerAvatarUrl()?has_content>
                                        <img
                                                class="discussion-comment-card__avatar"
                                                src="${comment.ownerAvatarUrl()}"
                                                alt="${comment.owner()}"
                                                loading="lazy"
                                        >
                                    <#else>
                                        <span class="discussion-comment-card__avatar discussion-comment-card__avatar--empty" aria-hidden="true">
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
                                    </#if>
                                </a>

                                <div class="discussion-comment-card__body">
                                    <header class="discussion-comment-card__header">
                                        <a class="discussion-comment-card__author" href="/users/${comment.ownerId()}">
                                            ${comment.owner()}
                                        </a>

                                        <#if comment.isAuthor()>
                                            <span class="discussion-author-badge">Автор кейса</span>
                                        </#if>

                                        <span class="discussion-comment-card__dot">•</span>

                                        <span class="discussion-comment-card__date">
                                            <span class="discussion-comment-card__date-icon" aria-hidden="true">
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
                                            <span>${comment.createdAt()}</span>
                                        </span>
                                    </header>

                                    <p class="discussion-comment-card__text">${comment.text()}</p>
                                </div>
                            </div>

                            <#if comment.canDelete()>
                                <button
                                        class="delete-comment-button discussion-comment-delete"
                                        type="button"
                                        data-comment-id="${comment.commentId()}"
                                        title="Удалить комментарий"
                                        aria-label="Удалить комментарий">
                                    <span class="discussion-comment-delete__icon" aria-hidden="true">
                                        <svg viewBox="0 0 24 24" fill="none">
                                            <path d="M5 7H19"
                                                  stroke="currentColor"
                                                  stroke-width="1.8"
                                                  stroke-linecap="round"/>
                                            <path d="M9 7V5.5C9 4.67 9.67 4 10.5 4H13.5C14.33 4 15 4.67 15 5.5V7"
                                                  stroke="currentColor"
                                                  stroke-width="1.8"
                                                  stroke-linecap="round"
                                                  stroke-linejoin="round"/>
                                            <path d="M8 10V18"
                                                  stroke="currentColor"
                                                  stroke-width="1.8"
                                                  stroke-linecap="round"/>
                                            <path d="M12 10V18"
                                                  stroke="currentColor"
                                                  stroke-width="1.8"
                                                  stroke-linecap="round"/>
                                            <path d="M16 10V18"
                                                  stroke="currentColor"
                                                  stroke-width="1.8"
                                                  stroke-linecap="round"/>
                                            <path d="M6.5 7L7.25 19C7.32 20.12 8.25 21 9.37 21H14.63C15.75 21 16.68 20.12 16.75 19L17.5 7"
                                                  stroke="currentColor"
                                                  stroke-width="1.8"
                                                  stroke-linejoin="round"/>
                                        </svg>
                                    </span>
                                </button>
                            </#if>
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
        </section>
    </div>
</main>

<#include "/fragments/footer.ftlh">
</body>
</html>