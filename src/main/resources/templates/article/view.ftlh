<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>${article.title()}</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <#if _csrf??>
        <meta name="csrf-header" content="${_csrf.headerName}">
        <meta name="csrf-token" content="${_csrf.token}">
    </#if>

    <link rel="stylesheet" href="/css/styles.css">
    <script src="/js/article-view.js" defer></script>
</head>

<body class="app-body article-view-page">
<#include "/fragments/header.ftlh">

<main class="content-view-page" data-content-id="${article.id()}">
    <div class="content-view-visual" aria-hidden="true">
        <div class="content-view-visual__dots"></div>
        <div class="content-view-visual__wave"></div>
        <div class="content-view-visual__wave-secondary"></div>
    </div>

    <div class="content-view-container">
        <div id="pageMessage" class="content-message"></div>

        <header class="content-view-header">
            <h1 class="content-view-title">${article.title()}</h1>

            <div class="content-view-meta-row">
                <div class="content-view-meta">
                    <span>Автор: ${article.owner()}</span>
                    <span>Создано: ${article.createdAt()}</span>
                    <span>Обновлено: ${article.updatedAt()}</span>
                </div>

                <div class="content-view-counter">
                    <span class="content-view-counter__icon" aria-hidden="true">
                        <svg viewBox="0 0 24 24" fill="none">
                            <path d="M2.5 12C4.6 7.9 8 5.75 12 5.75C16 5.75 19.4 7.9 21.5 12C19.4 16.1 16 18.25 12 18.25C8 18.25 4.6 16.1 2.5 12Z"
                                  stroke="currentColor"
                                  stroke-width="1.9"
                                  stroke-linejoin="round"/>
                            <path d="M12 14.75C13.5188 14.75 14.75 13.5188 14.75 12C14.75 10.4812 13.5188 9.25 12 9.25C10.4812 9.25 9.25 10.4812 9.25 12C9.25 13.5188 10.4812 14.75 12 14.75Z"
                                  stroke="currentColor"
                                  stroke-width="1.9"/>
                        </svg>
                    </span>
                    <span>Просмотры: ${(article.countViews())!0}</span>
                </div>
            </div>

            <div class="content-actions">
                <button
                        id="favoriteButton"
                        class="content-action-button content-favorite-button <#if article.isFavourite()>active</#if>"
                        type="button"
                        data-authenticated="${(isAuthenticated!false)?c}"
                        data-favourite="${(article.isFavourite())?c}">
                    <span class="content-action-button__icon" aria-hidden="true">
                        <svg viewBox="0 0 24 24" fill="none">
                            <path d="M12 20.6L10.55 19.28C5.4 14.6 2 11.52 2 7.75C2 4.67 4.42 2.25 7.5 2.25C9.24 2.25 10.91 3.06 12 4.34C13.09 3.06 14.76 2.25 16.5 2.25C19.58 2.25 22 4.67 22 7.75C22 11.52 18.6 14.6 13.45 19.29L12 20.6Z"
                                  stroke="currentColor"
                                  stroke-width="1.9"
                                  stroke-linecap="round"
                                  stroke-linejoin="round"/>
                        </svg>
                    </span>
                    <span id="favoriteText">
                        <#if article.isFavourite()>
                            В избранном
                        <#else>
                            В избранное
                        </#if>
                    </span>
                </button>

                <#if article.reactionsAllowed()>
                    <#assign reaction = article.reactionResponse()>
                    <#assign currentReaction = ((reaction.currentReaction())!'')?string>

                    <div class="content-reactions">
                        <button
                                id="likeButton"
                                class="content-action-button reaction-button <#if currentReaction == 'LIKE'>active-like</#if>"
                                type="button">
                            <span class="content-action-button__icon" aria-hidden="true">
                                <svg viewBox="0 0 24 24" fill="none">
                                    <path d="M7.5 10.4L11.45 3.75C12.35 4.05 13 4.88 13 5.85V8.6H18.45C19.7 8.6 20.6 9.8 20.25 11L18.65 16.55C18.35 17.58 17.42 18.3 16.35 18.3H7.5V10.4Z"
                                          stroke="currentColor"
                                          stroke-width="1.8"
                                          stroke-linejoin="round"/>
                                    <path d="M3.75 10.4H7.5V18.3H3.75V10.4Z"
                                          stroke="currentColor"
                                          stroke-width="1.8"
                                          stroke-linejoin="round"/>
                                </svg>
                            </span>
                            <span id="likesCount">${reaction.likesCount()}</span>
                        </button>

                        <button
                                id="dislikeButton"
                                class="content-action-button reaction-button <#if currentReaction == 'DISLIKE'>active-dislike</#if>"
                                type="button">
                            <span class="content-action-button__icon" aria-hidden="true">
                                <svg viewBox="0 0 24 24" fill="none">
                                    <path d="M16.5 13.6L12.55 20.25C11.65 19.95 11 19.12 11 18.15V15.4H5.55C4.3 15.4 3.4 14.2 3.75 13L5.35 7.45C5.65 6.42 6.58 5.7 7.65 5.7H16.5V13.6Z"
                                          stroke="currentColor"
                                          stroke-width="1.8"
                                          stroke-linejoin="round"/>
                                    <path d="M20.25 13.6H16.5V5.7H20.25V13.6Z"
                                          stroke="currentColor"
                                          stroke-width="1.8"
                                          stroke-linejoin="round"/>
                                </svg>
                            </span>
                            <span id="dislikesCount">${reaction.dislikesCount()}</span>
                        </button>
                    </div>
                </#if>
            </div>
        </header>

        <div class="content-view-layout">
            <article class="content-main-card">
                <section id="articleContent" class="content-markdown">
                    <#if article.htmlText()?has_content>
                        ${article.htmlText()?no_esc}
                    <#else>
                        <p class="empty-content">Текст статьи отсутствует.</p>
                    </#if>
                </section>
            </article>

            <aside class="content-ai-panel">
                <div class="content-ai-panel__header">
                    <h2 class="content-ai-panel__title">AI-помощник</h2>
                    <p class="content-ai-panel__description">
                        Можно получить краткое содержание статьи или объяснить выделенный термин.
                    </p>
                </div>

                <div class="content-ai-panel__actions">
                    <button id="aiSummaryButton" class="ai-button ai-button--primary" type="button">
                        <span class="ai-button__icon" aria-hidden="true">
                            <svg viewBox="0 0 24 24" fill="none">
                                <path d="M12 2.75L13.35 8.4L18.75 10L13.35 11.6L12 17.25L10.65 11.6L5.25 10L10.65 8.4L12 2.75Z"
                                      stroke="currentColor"
                                      stroke-width="1.8"
                                      stroke-linejoin="round"/>
                                <path d="M18.2 15.2L18.85 17.45L21.1 18.1L18.85 18.75L18.2 21L17.55 18.75L15.3 18.1L17.55 17.45L18.2 15.2Z"
                                      stroke="currentColor"
                                      stroke-width="1.6"
                                      stroke-linejoin="round"/>
                            </svg>
                        </span>
                        <span>Получить summary</span>
                    </button>

                    <button id="aiExplainButton" class="ai-button ai-button--secondary" type="button">
                        <span class="ai-button__icon" aria-hidden="true">
                            <svg viewBox="0 0 24 24" fill="none">
                                <path d="M12 21C16.9706 21 21 16.9706 21 12C21 7.02944 16.9706 3 12 3C7.02944 3 3 7.02944 3 12C3 16.9706 7.02944 21 12 21Z"
                                      stroke="currentColor"
                                      stroke-width="1.8"/>
                                <path d="M9.75 9.35C9.95 8.15 10.8 7.35 12.1 7.35C13.45 7.35 14.35 8.18 14.35 9.35C14.35 10.35 13.75 10.88 12.85 11.48C12.08 12 11.75 12.45 11.75 13.25V13.55"
                                      stroke="currentColor"
                                      stroke-width="1.8"
                                      stroke-linecap="round"/>
                                <path d="M12 16.5H12.01"
                                      stroke="currentColor"
                                      stroke-width="2.4"
                                      stroke-linecap="round"/>
                            </svg>
                        </span>
                        <span>Объяснить выделенный термин</span>
                    </button>
                </div>

                <div id="aiSelectedTerm" class="ai-selected-term">
                    Выбранный термин: <strong id="aiSelectedTermText"></strong>
                </div>

                <div id="aiMessage" class="ai-message"></div>

                <section id="aiSummaryResult" class="content-ai-result">
                    <h3 class="content-ai-result__title">Summary</h3>
                    <p id="aiSummaryResultContent" class="content-ai-result__content"></p>
                    <div class="content-ai-result__placeholder" aria-hidden="true">
                        <span></span>
                        <span></span>
                        <span></span>
                    </div>
                </section>

                <section id="aiTermResult" class="content-ai-result">
                    <h3 id="aiTermResultTitle" class="content-ai-result__title">Термин</h3>
                    <p id="aiTermResultContent" class="content-ai-result__content"></p>
                    <div class="content-ai-result__placeholder" aria-hidden="true">
                        <span></span>
                        <span></span>
                        <span></span>
                    </div>
                </section>

                <p class="content-ai-panel__hint">
                    Выделите термин в тексте, чтобы получить объяснение. Ответ появится здесь.
                </p>
            </aside>
        </div>
    </div>
</main>

<#include "/fragments/footer.ftlh">
</body>
</html>