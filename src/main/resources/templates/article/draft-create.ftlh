<#--<#import "/spring.ftl" as spring>-->

<#--<!DOCTYPE html>-->
<#--<html lang="ru">-->
<#--<head>-->
<#--    <meta charset="UTF-8">-->
<#--    <title>Создание статьи</title>-->
<#--</head>-->
<#--<body>-->

<#--<h1>Создание статьи</h1>-->

<#--<form method="post" action="/articles/drafts/${draftId}/publish">-->

<#--    &lt;#&ndash; Если включен Spring Security CSRF &ndash;&gt;-->
<#--    <#if _csrf??>-->
<#--        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">-->
<#--    </#if>-->

<#--    <div>-->
<#--        <label for="title">Название</label>-->
<#--        <br>-->

<#--        <input-->
<#--                id="title"-->
<#--                type="text"-->
<#--                name="title"-->
<#--                value="${(form.title())!''}"-->
<#--        >-->

<#--        <@spring.bind "form.title"/>-->
<#--        <#if spring.status.error>-->
<#--            <div style="color: red;">-->
<#--                <#list spring.status.errorMessages as error>-->
<#--                    <p>${error}</p>-->
<#--                </#list>-->
<#--            </div>-->
<#--        </#if>-->
<#--    </div>-->

<#--    <br>-->

<#--    <div>-->
<#--        <label for="text">Текст статьи</label>-->
<#--        <br>-->

<#--        <textarea-->
<#--                id="text"-->
<#--                name="text"-->
<#--                rows="12"-->
<#--                cols="80">${(form.text())!''}</textarea>-->

<#--        <@spring.bind "form.text"/>-->
<#--        <#if spring.status.error>-->
<#--            <div style="color: red;">-->
<#--                <#list spring.status.errorMessages as error>-->
<#--                    <p>${error}</p>-->
<#--                </#list>-->
<#--            </div>-->
<#--        </#if>-->
<#--    </div>-->

<#--    <br>-->

<#--    <div>-->
<#--        <label for="visibility">Доступ</label>-->
<#--        <br>-->

<#--        <select id="visibility" name="visibility">-->
<#--            <option value="PUBLIC"-->
<#--                    <#if ((form.visibility())!'PUBLIC')?string == 'PUBLIC'>selected</#if>>-->
<#--                PUBLIC-->
<#--            </option>-->

<#--            <option value="PRIVATE"-->
<#--                    <#if ((form.visibility())!'PUBLIC')?string == 'PRIVATE'>selected</#if>>-->
<#--                PRIVATE-->
<#--            </option>-->
<#--        </select>-->

<#--        <@spring.bind "form.visibility"/>-->
<#--        <#if spring.status.error>-->
<#--            <div style="color: red;">-->
<#--                <#list spring.status.errorMessages as error>-->
<#--                    <p>${error}</p>-->
<#--                </#list>-->
<#--            </div>-->
<#--        </#if>-->
<#--    </div>-->

<#--    <br>-->

<#--    <button type="submit">Опубликовать статью</button>-->

<#--</form>-->

<#--</body>-->
<#--</html>-->

<#import "/spring.ftl" as spring>

<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Создание статьи</title>

    <link
            rel="stylesheet"
            href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css"
    />
</head>
<body>

<h1>Создание статьи</h1>

<form id="articleForm" method="post" action="/articles/drafts/${draftId}/publish">

    <#if _csrf??>
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
    </#if>

    <div>
        <label for="title">Название</label>
        <br>

        <input
                id="title"
                type="text"
                name="title"
                value="${(form.title())!''}"
        >

        <@spring.bind "form.title"/>
        <#if spring.status.error>
            <div style="color: red;">
                <#list spring.status.errorMessages as error>
                    <p>${error}</p>
                </#list>
            </div>
        </#if>
    </div>

    <br>

    <div>
        <label for="editor">Текст статьи</label>
        <br>

        <textarea
                id="text"
                name="text"
                style="display: none;">${(form.text())!''}</textarea>

        <div id="editor"></div>

        <@spring.bind "form.text"/>
        <#if spring.status.error>
            <div style="color: red;">
                <#list spring.status.errorMessages as error>
                    <p>${error}</p>
                </#list>
            </div>
        </#if>
    </div>

    <br>

    <div>
        <label for="visibility">Доступ</label>
        <br>

        <select id="visibility" name="visibility">
            <option value="PUBLIC"
                    <#if ((form.visibility())!'PUBLIC')?string == 'PUBLIC'>selected</#if>>
                PUBLIC
            </option>

            <option value="PRIVATE"
                    <#if ((form.visibility())!'PUBLIC')?string == 'PRIVATE'>selected</#if>>
                PRIVATE
            </option>
        </select>

        <@spring.bind "form.visibility"/>
        <#if spring.status.error>
            <div style="color: red;">
                <#list spring.status.errorMessages as error>
                    <p>${error}</p>
                </#list>
            </div>
        </#if>
    </div>

    <br>

    <button type="submit">Опубликовать статью</button>

</form>

<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>

<script>
    const Editor = toastui.Editor;

    const articleForm = document.getElementById("articleForm");
    const textArea = document.getElementById("text");

    <#if _csrf??>
    const csrfHeaderName = "${_csrf.headerName}";
    const csrfToken = "${_csrf.token}";
    <#else>
    const csrfHeaderName = null;
    const csrfToken = null;
    </#if>

    const editor = new Editor({
        el: document.querySelector("#editor"),
        height: "500px",
        initialEditType: "markdown",
        previewStyle: "vertical",
        initialValue: textArea.value,
        usageStatistics: false,

        hooks: {
            async addImageBlobHook(blob, callback) {
                const formData = new FormData();

                formData.append("file", blob);
                formData.append("contentItemId", "${draftId}");

                const headers = {};

                if (csrfHeaderName && csrfToken) {
                    headers[csrfHeaderName] = csrfToken;
                }

                try {
                    const response = await fetch("/api/upload/image", {
                        method: "POST",
                        headers: headers,
                        body: formData
                    });

                    if (!response.ok) {
                        let message = "Ошибка загрузки изображения";

                        try {
                            const errorBody = await response.json();
                            if (errorBody.message) {
                                message = errorBody.message;
                            }
                        } catch (e) {
                            // response body is not json
                        }

                        alert(message);
                        return;
                    }

                    const image = await response.json();

                    callback(image.url, image.originalName);

                } catch (e) {
                    alert("Не удалось загрузить изображение");
                }
            }
        }
    });

    articleForm.addEventListener("submit", function () {
        textArea.value = editor.getMarkdown();
    });
</script>

</body>
</html>

