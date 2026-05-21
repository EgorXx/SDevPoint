<#-- templates/profile/settings.ftlh -->
<#import "/spring.ftl" as spring>

<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Настройки профиля</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet" href="/css/styles.css">
</head>

<body class="app-body profile-settings-page">
<#include "/fragments/header.ftlh">

<main class="profile-settings">
    <div class="profile-settings__container">
        <header class="profile-settings__header">
            <h1 class="profile-settings__title">Настройки профиля</h1>
            <p class="profile-settings__description">
                Изменение основных данных пользователя
            </p>
        </header>

        <#if success?? && success?has_content>
            <div class="profile-settings-message profile-settings-message--success success-message">
                ${success}
            </div>
        </#if>

        <section class="profile-settings-card settings-card">
            <div class="profile-settings-card__visual" aria-hidden="true">
                <div class="profile-settings-card__dots"></div>
                <div class="profile-settings-card__wave"></div>
                <div class="profile-settings-card__wave-secondary"></div>
            </div>

            <div class="profile-settings-card__content">
                <h2 class="profile-settings-section-title section-title">
                    Имя пользователя
                </h2>

                <form method="post" action="/profile/settings/name">
                    <#if _csrf??>
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                    </#if>

                    <div class="profile-settings-field form-group">
                        <label class="profile-settings-label form-label" for="username">
                            Новое имя
                        </label>

                        <input
                                class="profile-settings-input form-input"
                                id="username"
                                type="text"
                                name="username"
                                value="${(nameForm.username())!''}"
                                autocomplete="username"
                                placeholder="Введите новое имя"
                        >

                        <@spring.bind "nameForm.username"/>
                        <#if spring.status.error>
                            <div class="profile-settings-field-error field-error">
                                <#list spring.status.errorMessages as error>
                                    <p>${error}</p>
                                </#list>
                            </div>
                        </#if>
                    </div>

                    <div class="profile-settings-actions actions">
                        <button class="profile-settings-button profile-settings-button--primary submit-button" type="submit">
                            Сохранить
                        </button>

                        <a class="profile-settings-button profile-settings-button--secondary back-link" href="/profile">
                            <span class="profile-settings-button__icon" aria-hidden="true">
                                <svg viewBox="0 0 24 24" fill="none">
                                    <path d="M15 6L9 12L15 18"
                                          stroke="currentColor"
                                          stroke-width="1.9"
                                          stroke-linecap="round"
                                          stroke-linejoin="round"/>
                                    <path d="M10 12H21"
                                          stroke="currentColor"
                                          stroke-width="1.9"
                                          stroke-linecap="round"/>
                                </svg>
                            </span>
                            <span>Назад в профиль</span>
                        </a>
                    </div>
                </form>
            </div>
        </section>
    </div>
</main>

<#include "/fragments/footer.ftlh">
</body>
</html>