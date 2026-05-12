<h1>${profile.username()}</h1>

<img src="${profile.avatarUrl()}" alt="Аватар пользователя ${profile.username()}">

<#if profile.isOwner()>
    <a href="/profile/settings">Настройки</a>
</#if>