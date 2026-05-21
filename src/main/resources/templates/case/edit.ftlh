<#import "/spring.ftl" as spring>

<#assign pageContentItemId = contentItemId>
<#assign hasCaseSolution = ((form.hasSolution())!false)>

<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Редактирование кейса</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <#if _csrf??>
        <meta name="_csrf" content="${_csrf.token}">
        <meta name="_csrf_header" content="${_csrf.headerName}">
    </#if>

    <link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css">
    <link rel="stylesheet" href="/css/styles.css">

    <script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>
    <script src="/js/case-edit.js" defer></script>
</head>

<body class="app-body case-edit-page">
<#include "/fragments/header.ftlh">

<main class="create-page" data-page-type="case-edit">
    <div class="create-page__visual" aria-hidden="true">
        <div class="create-page__dots"></div>
        <div class="create-page__wave"></div>
        <div class="create-page__wave-secondary"></div>
    </div>

    <div class="create-page__container">
        <header class="create-page__header">
            <h1 class="create-page__title">Редактирование кейса</h1>
            <p class="create-page__description">
                Обновите описание кейса, решение, изображения и настройки доступа.
            </p>
        </header>

        <#if error?? && error?has_content>
            <div id="errorMessage" class="create-alert create-alert--error create-alert--visible">
                ${error}
            </div>
        </#if>

        <div id="uploadError" class="create-alert create-alert--error"></div>

        <form
                id="caseEditForm"
                class="create-layout"
                method="post"
                action="/cases/${pageContentItemId}"
                data-content-item-id="${pageContentItemId}"
                data-initial-has-solution="${hasCaseSolution?c}"
        >
            <#if _csrf??>
                <input type="hidden"
                       name="${_csrf.parameterName}"
                       value="${_csrf.token}">
            </#if>

            <section class="create-main">
                <div class="create-field">
                    <label class="create-label" for="title">Название кейса</label>

                    <input
                            id="title"
                            class="create-input"
                            type="text"
                            name="title"
                            value="${(form.title())!''}"
                            placeholder="Например: Оптимизация загрузки изображений в веб-приложении"
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
                    <label class="create-label" for="descriptionEditor">Описание кейса</label>

                    <textarea
                            id="description"
                            class="create-hidden-textarea"
                            name="description">${(form.description())!''}</textarea>

                    <div id="descriptionEditor" class="create-editor"></div>

                    <@spring.bind "form.description"/>
                    <#if spring.status.error>
                        <div class="field-error">
                            <#list spring.status.errorMessages as validationError>
                                <p>${validationError}</p>
                            </#list>
                        </div>
                    </#if>
                </div>

                <div class="create-field create-field--solution-choice">
                    <span class="create-label">Наличие решения</span>

                    <fieldset class="create-solution-options">
                        <legend class="create-solution-options__legend">Наличие решения</legend>

                        <label class="create-solution-option">
                            <input
                                    type="radio"
                                    name="hasSolution"
                                    value="true"
                                    <#if hasCaseSolution>checked</#if>
                            >
                            <span class="create-solution-option__content">
                                <span class="create-solution-option__icon" aria-hidden="true">
                                    <svg viewBox="0 0 24 24" fill="none">
                                        <path d="M20 6L9 17L4 12"
                                              stroke="currentColor"
                                              stroke-width="2"
                                              stroke-linecap="round"
                                              stroke-linejoin="round"/>
                                    </svg>
                                </span>
                                <span>Есть решение</span>
                            </span>
                        </label>

                        <label class="create-solution-option">
                            <input
                                    type="radio"
                                    name="hasSolution"
                                    value="false"
                                    <#if !hasCaseSolution>checked</#if>
                            >
                            <span class="create-solution-option__content">
                                <span class="create-solution-option__icon" aria-hidden="true">
                                    <svg viewBox="0 0 24 24" fill="none">
                                        <path d="M12 21C16.9706 21 21 16.9706 21 12C21 7.02944 16.9706 3 12 3C7.02944 3 3 7.02944 3 12C3 16.9706 7.02944 21 12 21Z"
                                              stroke="currentColor"
                                              stroke-width="1.8"/>
                                        <path d="M8 12H16"
                                              stroke="currentColor"
                                              stroke-width="1.8"
                                              stroke-linecap="round"/>
                                    </svg>
                                </span>
                                <span>Нет решения</span>
                            </span>
                        </label>
                    </fieldset>

                    <p class="create-solution-hint">
                        Укажите, есть ли готовое решение в рамках кейса.
                    </p>

                    <@spring.bind "form.hasSolution"/>
                    <#if spring.status.error>
                        <div class="field-error">
                            <#list spring.status.errorMessages as validationError>
                                <p>${validationError}</p>
                            </#list>
                        </div>
                    </#if>
                </div>

                <div id="solutionBlock"
                     class="create-field create-field--editor create-solution-block <#if hasCaseSolution>create-solution-block--visible</#if>">
                    <label class="create-label" for="solutionEditor">Решение кейса</label>

                    <textarea
                            id="solution"
                            class="create-hidden-textarea"
                            name="solution">${(form.solution())!''}</textarea>

                    <div id="solutionEditor" class="create-editor"></div>

                    <@spring.bind "form.solution"/>
                    <#if spring.status.error>
                        <div class="field-error">
                            <#list spring.status.errorMessages as validationError>
                                <p>${validationError}</p>
                            </#list>
                        </div>
                    </#if>
                </div>

                <div class="create-actions">
                    <button type="submit" class="create-button create-button--primary">
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
                        <span>Сохранить изменения</span>
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
                        Публичные кейсы доступны всем пользователям.
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