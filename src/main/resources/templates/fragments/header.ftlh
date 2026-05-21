<#-- templates/header.ftlh — общий header для всех страниц -->
<header class="site-header">
    <div class="header-inner">
        <a href="/" class="header-logo" aria-label="SDevPoint — главная">
            <span class="header-logo__mark" aria-hidden="true">
                <svg viewBox="0 0 32 32" fill="none">
                    <path d="M11.6 11.2L7.2 16L11.6 20.8" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"/>
                    <path d="M20.4 11.2L24.8 16L20.4 20.8" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"/>
                    <path d="M17.8 9.6L14.2 22.4" stroke="currentColor" stroke-width="2.2" stroke-linecap="round"/>
                </svg>
            </span>
            <span class="header-logo__text">SDevPoint</span>
        </a>

        <nav class="header-nav" aria-label="Основная навигация">
            <a href="/articles/public" class="header-link">Статьи</a>
            <a href="/cases/public" class="header-link">Кейсы</a>

            <#if isAuthenticated!false>
                <a href="/my-content" class="header-link">Мой контент</a>
                <a href="/favorites" class="header-link">Избранное</a>
                <a href="/profile" class="header-link">Профиль</a>
                <form method="post" action="/auth/logout" class="header-logout-form">
                    <#if _csrf??>
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                    </#if>
                    <button type="submit" class="header-link header-logout-button">Выйти</button>
                </form>
            <#else>
                <a href="/auth/login" class="header-link header-link--button">Войти</a>
            </#if>
        </nav>
    </div>
</header>