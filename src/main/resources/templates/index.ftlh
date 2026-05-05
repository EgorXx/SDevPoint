<#-- templates/index.ftlh -->

<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Главная</title>
</head>
<body>

<h1>Личная база знаний</h1>

<p>
    Здесь можно создавать и хранить статьи в формате Markdown.
</p>

<form method="post" action="/articles/drafts">
    <#if _csrf??>
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
    </#if>

    <button type="submit">Создать статью</button>
</form>

</body>
</html>