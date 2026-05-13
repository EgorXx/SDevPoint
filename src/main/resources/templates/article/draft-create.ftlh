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

<div
        id="uploadError"
        style="display: none; color: #b91c1c; background: #fef2f2; border: 1px solid #fecaca; padding: 12px; border-radius: 8px; margin-bottom: 16px;">
</div>

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

    <div>
        <button
                type="submit"
                formaction="/articles/drafts/${draftId}"
                formmethod="post">
            Сохранить черновик
        </button>

        <button
                type="submit"
                formaction="/articles/drafts/${draftId}/publish"
                formmethod="post">
            Опубликовать статью
        </button>
    </div>

</form>

<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>

<script>
    const Editor = toastui.Editor;

    const articleForm = document.getElementById("articleForm");
    const textArea = document.getElementById("text");
    const uploadError = document.getElementById("uploadError");

    <#if _csrf??>
    const csrfHeaderName = "${_csrf.headerName}";
    const csrfToken = "${_csrf.token}";
    <#else>
    const csrfHeaderName = null;
    const csrfToken = null;
    </#if>

    function showUploadError(message) {
        uploadError.textContent = message;
        uploadError.style.display = "block";

        setTimeout(function () {
            uploadError.style.display = "none";
            uploadError.textContent = "";
        }, 7000);
    }

    async function extractErrorMessage(response) {
        const defaultMessage = "Не удалось загрузить изображение";

        const contentType = response.headers.get("content-type");

        if (contentType && contentType.includes("application/json")) {
            try {
                const errorBody = await response.json();

                if (errorBody.message) {
                    return errorBody.message;
                }

                return defaultMessage;
            } catch (e) {
                return defaultMessage;
            }
        }

        try {
            const text = await response.text();

            if (text && text.trim().length > 0) {
                return text;
            }

            return defaultMessage;
        } catch (e) {
            return defaultMessage;
        }
    }

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
                        const message = await extractErrorMessage(response);
                        showUploadError(message);
                        return;
                    }

                    const image = await response.json();

                    if (!image.url) {
                        showUploadError("Сервер не вернул ссылку на изображение");
                        return;
                    }

                    callback(image.url, image.originalName || "image");

                } catch (e) {
                    console.error(e);
                    showUploadError("Не удалось загрузить изображение");
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

