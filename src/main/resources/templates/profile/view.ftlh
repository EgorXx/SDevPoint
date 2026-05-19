<#-- templates/profile/view.ftlh -->
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Профиль — ${profile.username()}</title>

    <style>
        :root {
            --bg: #f6f7f9;
            --card-bg: #ffffff;
            --text-main: #1f2937;
            --text-muted: #6b7280;
            --border: #e5e7eb;
            --link: #2563eb;
            --link-hover: #1d4ed8;
        }

        *, *::before, *::after {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            background: var(--bg);
            color: var(--text-main);
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif;
            line-height: 1.65;
        }

        .page {
            flex: 1;
            max-width: 600px;
            margin: 0 auto;
            padding: 40px 20px 64px;
            width: 100%;
        }

        .profile-card {
            background: var(--card-bg);
            border: 1px solid var(--border);
            border-radius: 18px;
            padding: 36px 32px;
            text-align: center;
            box-shadow: 0 8px 24px rgba(15, 23, 42, 0.05);
        }

        .profile-avatar {
            width: 100px;
            height: 100px;
            border-radius: 999px;
            border: 3px solid var(--border);
            margin-bottom: 18px;
        }

        .profile-name {
            margin: 0 0 16px;
            font-size: 26px;
            font-weight: 700;
            color: #111827;
        }

        .profile-link {
            display: inline-block;
            padding: 9px 18px;
            border-radius: 10px;
            background: var(--link);
            color: #ffffff;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            transition: background 0.12s;
        }

        .profile-link:hover {
            background: var(--link-hover);
        }
    </style>
</head>
<body>

<#include "/fragments/header.ftlh">

<main class="page">
    <div class="profile-card">
        <img class="profile-avatar" src="${profile.avatarUrl()}" alt="Аватар пользователя ${profile.username()}">
        <h1 class="profile-name">${profile.username()}</h1>

        <#if profile.isOwner()>
            <a class="profile-link" href="/profile/settings">Настройки</a>
        </#if>
    </div>
</main>

<#include "/fragments/footer.ftlh">

</body>
</html>
