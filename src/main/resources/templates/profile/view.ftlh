<#-- templates/profile/view.ftlh -->
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Профиль — ${profile.username()}</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet" href="/css/styles.css">
</head>

<body class="app-body profile-page">
<#include "/fragments/header.ftlh">

<main class="profile-page-main">
    <div class="profile-page-main__container">
        <section class="profile-hero-card">
            <div class="profile-hero-card__visual" aria-hidden="true">
                <div class="profile-hero-card__dots"></div>
                <div class="profile-hero-card__wave"></div>
                <div class="profile-hero-card__wave-secondary"></div>
                <div class="profile-hero-card__circle"></div>
            </div>

            <div class="profile-hero-card__content">
                <div class="profile-avatar-wrap">
                    <#if profile.avatarUrl()?has_content>
                        <img
                                class="profile-avatar"
                                src="${profile.avatarUrl()}"
                                alt="Аватар пользователя ${profile.username()}"
                                loading="lazy"
                        >
                    <#else>
                        <div class="profile-avatar profile-avatar--fallback" aria-hidden="true">
                            <#if profile.username()?has_content>
                                ${profile.username()?substring(0, 1)?upper_case}
                            <#else>
                                U
                            </#if>
                        </div>
                    </#if>
                </div>

                <div class="profile-info">
                    <h1 class="profile-name">${profile.username()}</h1>
                    <p class="profile-subtitle">Профиль пользователя</p>

                    <#if profile.isOwner()>
                        <a class="profile-settings-link" href="/profile/settings">
                            <span class="profile-settings-link__icon" aria-hidden="true">
                                <svg viewBox="0 0 24 24" fill="none">
                                    <path d="M12.22 2H11.78C10.68 2 9.78 2.9 9.78 4V4.18C9.78 4.9 9.39 5.56 8.76 5.92L8.33 6.17C7.71 6.53 6.94 6.53 6.32 6.17L6.17 6.08C5.22 5.53 4 5.86 3.45 6.81L3.23 7.19C2.68 8.14 3.01 9.36 3.96 9.91L4.11 10C4.73 10.36 5.12 11.02 5.12 11.74V12.25C5.12 12.97 4.73 13.64 4.11 14L3.96 14.09C3.01 14.64 2.68 15.86 3.23 16.81L3.45 17.19C4 18.14 5.22 18.47 6.17 17.92L6.32 17.83C6.94 17.47 7.71 17.47 8.33 17.83L8.76 18.08C9.39 18.44 9.78 19.1 9.78 19.82V20C9.78 21.1 10.68 22 11.78 22H12.22C13.32 22 14.22 21.1 14.22 20V19.82C14.22 19.1 14.61 18.44 15.24 18.08L15.67 17.83C16.29 17.47 17.06 17.47 17.68 17.83L17.83 17.92C18.78 18.47 20 18.14 20.55 17.19L20.77 16.81C21.32 15.86 20.99 14.64 20.04 14.09L19.89 14C19.27 13.64 18.88 12.97 18.88 12.25V11.75C18.88 11.03 19.27 10.36 19.89 10L20.04 9.91C20.99 9.36 21.32 8.14 20.77 7.19L20.55 6.81C20 5.86 18.78 5.53 17.83 6.08L17.68 6.17C17.06 6.53 16.29 6.53 15.67 6.17L15.24 5.92C14.61 5.56 14.22 4.9 14.22 4.18V4C14.22 2.9 13.32 2 12.22 2Z"
                                          stroke="currentColor"
                                          stroke-width="1.75"
                                          stroke-linecap="round"
                                          stroke-linejoin="round"/>
                                    <circle cx="12" cy="12" r="3.25"
                                            stroke="currentColor"
                                            stroke-width="1.75"/>
                                </svg>
                            </span>
                            <span>Настройки</span>
                        </a>
                    </#if>
                </div>
            </div>
        </section>
    </div>
</main>

<#include "/fragments/footer.ftlh">
</body>
</html>