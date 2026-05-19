<#-- templates/header.ftlh — общий header для всех страниц -->
<header class="site-header">
    <div class="header-inner">
        <a href="/" class="header-logo">SDevPoint</a>

        <nav class="header-nav">
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
                <a href="/auth/login" class="header-link">Войти</a>
            </#if>
        </nav>
    </div>
</header>

<style>
    .site-header {
        background: #ffffff;
        border-bottom: 1px solid #e5e7eb;
        padding: 0;
        position: sticky;
        top: 0;
        z-index: 100;
    }

    .header-inner {
        max-width: 1100px;
        margin: 0 auto;
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 16px;
        padding: 12px 20px;
    }

    .header-logo {
        font-size: 22px;
        font-weight: 750;
        color: #111827;
        text-decoration: none;
        letter-spacing: -0.03em;
        white-space: nowrap;
    }

    .header-logo:hover {
        color: #2563eb;
    }

    .header-nav {
        display: flex;
        align-items: center;
        gap: 8px;
        flex-wrap: wrap;
    }

    .header-link {
        color: #4b5563;
        text-decoration: none;
        font-size: 15px;
        font-weight: 500;
        padding: 8px 12px;
        border-radius: 8px;
        transition: color 0.12s, background 0.12s;
        white-space: nowrap;
    }

    .header-link:hover {
        color: #111827;
        background: #f3f4f6;
    }

    .header-logout-form {
        display: inline-flex;
        margin: 0;
    }

    .header-logout-button {
        background: none;
        border: none;
        cursor: pointer;
        font: inherit;
        font-size: 15px;
        font-weight: 500;
        color: #9ca3af;
        padding: 8px 12px;
        border-radius: 8px;
        transition: color 0.12s, background 0.12s;
    }

    .header-logout-button:hover {
        color: #dc2626;
        background: #fef2f2;
    }

    @media (max-width: 640px) {
        .header-inner {
            flex-direction: column;
            gap: 10px;
            padding: 10px 14px;
        }

        .header-nav {
            justify-content: center;
        }

        .header-link {
            font-size: 14px;
            padding: 6px 10px;
        }
    }
</style>
