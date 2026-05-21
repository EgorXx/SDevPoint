<#import "/spring.ftl" as spring>

<#assign pageDraftId = draftId>
<#assign pageContentItemId = contentItemId!draftId>

<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Создание статьи</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <#if _csrf??>
        <meta name="_csrf" content="${_csrf.token}">
        <meta name="_csrf_header" content="${_csrf.headerName}">
    </#if>

    <link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css">
    <link rel="stylesheet" href="/css/styles.css">

    <script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>
    <script src="/js/article-create.js" defer></script>
</head>

<body class="app-body article-create-page">
<#include "/fragments/header.ftlh">

<main class="create-page" data-page-type="article">
    <div class="create-page__visual" aria-hidden="true">
        <div class="create-page__dots"></div>
        <div class="create-page__wave"></div>
        <div class="create-page__wave-secondary"></div>
    </div>

    <div class="create-page__container">
        <header class="create-page__header">
            <h1 class="create-page__title">Создание статьи</h1>
            <p class="create-page__description">
                Пишите материал в Markdown и публикуйте его в базе знаний.
            </p>
        </header>

        <#if error?? && error?has_content>
            <div class="create-alert create-alert--error">
                ${error}
            </div>
        </#if>

        <div id="uploadError" class="create-alert create-alert--error"></div>

        <form
                id="articleForm"
                class="create-layout"
                method="post"
                action="/articles/drafts/${pageDraftId}/publish"
                data-draft-id="${pageDraftId}"
                data-content-item-id="${pageContentItemId}"
        >
            <#if _csrf??>
                <input type="hidden"
                       name="${_csrf.parameterName}"
                       value="${_csrf.token}">
            </#if>

            <section class="create-main">
                <div class="create-field">
                    <label class="create-label" for="title">Название</label>

                    <input
                            id="title"
                            class="create-input"
                            type="text"
                            name="title"
                            value="${(form.title())!''}"
                            placeholder="Например: Как работает поток в Java"
                    >

                    <@spring.bind "form.title"/>
                    <#if spring.status.error>
                        <div class="field-error">
                            <#list spring.status.errorMessages as validationError>
                                <p>${validationError}</p>
                            </#list>
                        </div>
                    </#if>
                </div>

                <div class="create-field create-field--editor">
                    <label class="create-label" for="editor">Текст статьи</label>

                    <textarea
                            id="text"
                            class="create-hidden-textarea"
                            name="text">${(form.text())!''}</textarea>

                    <div id="editor" class="create-editor"></div>

                    <@spring.bind "form.text"/>
                    <#if spring.status.error>
                        <div class="field-error">
                            <#list spring.status.errorMessages as validationError>
                                <p>${validationError}</p>
                            </#list>
                        </div>
                    </#if>
                </div>

                <div class="create-actions">
                    <button
                            type="submit"
                            class="create-button create-button--secondary"
                            formaction="/articles/drafts/${pageDraftId}"
                            formmethod="post">
                        <span class="create-button__icon" aria-hidden="true">
                            <svg viewBox="0 0 24 24" fill="none">
                                <path d="M6.5 3.5H15.5L19.5 7.5V20.5H6.5V3.5Z"
                                      stroke="currentColor"
                                      stroke-width="1.8"
                                      stroke-linejoin="round"/>
                                <path d="M9 3.5V9H16"
                                      stroke="currentColor"
                                      stroke-width="1.8"
                                      stroke-linejoin="round"/>
                                <path d="M9 15H16"
                                      stroke="currentColor"
                                      stroke-width="1.8"
                                      stroke-linecap="round"/>
                                <path d="M9 18H14"
                                      stroke="currentColor"
                                      stroke-width="1.8"
                                      stroke-linecap="round"/>
                            </svg>
                        </span>
                        <span>Сохранить черновик</span>
                    </button>

                    <button
                            type="submit"
                            class="create-button create-button--primary"
                            formaction="/articles/drafts/${pageDraftId}/publish"
                            formmethod="post">
                        <span class="create-button__icon" aria-hidden="true">
                            <svg viewBox="0 0 24 24" fill="none">
                                <path d="M12 20V4"
                                      stroke="currentColor"
                                      stroke-width="1.9"
                                      stroke-linecap="round"/>
                                <path d="M6.5 9.5L12 4L17.5 9.5"
                                      stroke="currentColor"
                                      stroke-width="1.9"
                                      stroke-linecap="round"
                                      stroke-linejoin="round"/>
                                <path d="M5 20H19"
                                      stroke="currentColor"
                                      stroke-width="1.9"
                                      stroke-linecap="round"/>
                            </svg>
                        </span>
                        <span>Опубликовать статью</span>
                    </button>
                </div>
            </section>

            <aside class="create-sidebar">
                <section id="uploadedImagesBlock" class="create-side-card">
                    <div class="create-side-card__header">
                        <h2 class="create-side-card__title">Изображения</h2>
                    </div>

                    <div id="imageLimitInfo" class="create-limit-info">
                        Использовано <span id="imageCurrentSize">0 МБ</span> из <span id="imageMaxSize">0 МБ</span>
                    </div>

                    <div class="create-limit-progress" aria-hidden="true">
                        <div id="imageLimitProgress" class="create-limit-progress__bar"></div>
                    </div>

                    <p class="create-side-card__hint">
                        Изображения можно загрузить через редактор, вставить в редактор или перенести файл.
                    </p>

                    <div id="uploadedImagesEmpty" class="create-images-empty">
                        Изображений пока нет.
                    </div>

                    <div id="uploadedImagesList" class="create-images-list"></div>
                </section>

                <section class="create-side-card">
                    <div class="create-side-card__header">
                        <h2 class="create-side-card__title">Доступ</h2>
                    </div>

                    <fieldset class="create-visibility">
                        <legend class="create-visibility__legend">Доступ</legend>

                        <label class="create-visibility-option">
                            <input
                                    type="radio"
                                    name="visibility"
                                    value="PUBLIC"
                                    <#if ((form.visibility())!'PUBLIC')?string == 'PUBLIC'>checked</#if>
                            >
                            <span class="create-visibility-option__content">
                                <span class="create-visibility-option__icon" aria-hidden="true">
                                    <svg viewBox="0 0 24 24" fill="none">
                                        <path d="M2.5 12C4.6 7.9 8 5.75 12 5.75C16 5.75 19.4 7.9 21.5 12C19.4 16.1 16 18.25 12 18.25C8 18.25 4.6 16.1 2.5 12Z"
                                              stroke="currentColor"
                                              stroke-width="1.8"
                                              stroke-linejoin="round"/>
                                        <path d="M12 14.5C13.3807 14.5 14.5 13.3807 14.5 12C14.5 10.6193 13.3807 9.5 12 9.5C10.6193 9.5 9.5 10.6193 9.5 12C9.5 13.3807 10.6193 14.5 12 14.5Z"
                                              stroke="currentColor"
                                              stroke-width="1.8"/>
                                    </svg>
                                </span>
                                <span>PUBLIC</span>
                            </span>
                        </label>

                        <label class="create-visibility-option">
                            <input
                                    type="radio"
                                    name="visibility"
                                    value="PRIVATE"
                                    <#if ((form.visibility())!'PUBLIC')?string == 'PRIVATE'>checked</#if>
                            >
                            <span class="create-visibility-option__content">
                                <span class="create-visibility-option__icon" aria-hidden="true">
                                    <svg viewBox="0 0 24 24" fill="none">
                                        <path d="M7 10V8C7 5.24 9.24 3 12 3C14.76 3 17 5.24 17 8V10"
                                              stroke="currentColor"
                                              stroke-width="1.8"
                                              stroke-linecap="round"/>
                                        <path d="M6.5 10H17.5C18.6 10 19.5 10.9 19.5 12V19C19.5 20.1 18.6 21 17.5 21H6.5C5.4 21 4.5 20.1 4.5 19V12C4.5 10.9 5.4 10 6.5 10Z"
                                              stroke="currentColor"
                                              stroke-width="1.8"
                                              stroke-linejoin="round"/>
                                        <path d="M12 15V17"
                                              stroke="currentColor"
                                              stroke-width="1.8"
                                              stroke-linecap="round"/>
                                    </svg>
                                </span>
                                <span>PRIVATE</span>
                            </span>
                        </label>
                    </fieldset>

                    <p class="create-side-card__hint create-side-card__hint--compact">
                        Публичные статьи доступны всем пользователям.
                    </p>

                    <@spring.bind "form.visibility"/>
                    <#if spring.status.error>
                        <div class="field-error">
                            <#list spring.status.errorMessages as validationError>
                                <p>${validationError}</p>
                            </#list>
                        </div>
                    </#if>
                </section>
            </aside>
        </form>
    </div>
</main>

<#include "/fragments/footer.ftlh">
</body>
</html>