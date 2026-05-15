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
        <div id="uploadedImagesBlock" style="margin-top: 24px; padding: 16px; border: 1px solid #e5e7eb; border-radius: 12px;">
            <h3 style="margin-top: 0;">Загруженные изображения</h3>

            <div id="uploadedImagesEmpty" style="color: #6b7280;">
                Изображений пока нет.
            </div>

            <div id="uploadedImagesList" style="display: grid; gap: 10px;"></div>
        </div>

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
                    addImageToList(image);

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

    const uploadedImagesList = document.getElementById("uploadedImagesList");
    const uploadedImagesEmpty = document.getElementById("uploadedImagesEmpty");

    function formatBytes(bytes) {
        if (bytes < 1024) {
            return bytes + " Б";
        }

        if (bytes < 1024 * 1024) {
            return (bytes / 1024).toFixed(1) + " КБ";
        }

        return (bytes / (1024 * 1024)).toFixed(1) + " МБ";
    }

    function escapeHtml(value) {
        return value
            .replaceAll("&", "&amp;")
            .replaceAll("<", "&lt;")
            .replaceAll(">", "&gt;")
            .replaceAll("\"", "&quot;")
            .replaceAll("'", "&#039;");
    }

    function refreshEmptyState() {
        uploadedImagesEmpty.style.display =
            uploadedImagesList.children.length === 0 ? "block" : "none";
    }

    function addImageToList(image) {
        const existing = document.getElementById("uploaded-image-" + image.publicId);

        if (existing) {
            return;
        }

        const item = document.createElement("div");

        item.id = "uploaded-image-" + image.publicId;
        item.style.padding = "12px";
        item.style.border = "1px solid #e5e7eb";
        item.style.borderRadius = "10px";
        item.style.background = "#ffffff";

        const wrapper = document.createElement("div");
        wrapper.style.display = "flex";
        wrapper.style.justifyContent = "space-between";
        wrapper.style.gap = "12px";
        wrapper.style.alignItems = "flex-start";

        const info = document.createElement("div");

        const name = document.createElement("div");
        const strong = document.createElement("strong");
        strong.textContent = image.originalName || "image";
        name.appendChild(strong);

        const size = document.createElement("div");
        size.style.color = "#6b7280";
        size.style.fontSize = "14px";
        size.textContent = formatBytes(image.size || 0);

        const linkWrapper = document.createElement("div");
        linkWrapper.style.fontSize = "14px";
        linkWrapper.style.marginTop = "4px";

        const link = document.createElement("a");
        link.href = image.url;
        link.target = "_blank";
        link.rel = "noopener noreferrer";
        link.textContent = image.url;

        linkWrapper.appendChild(link);

        info.appendChild(name);
        info.appendChild(size);
        info.appendChild(linkWrapper);

        const deleteButton = document.createElement("button");
        deleteButton.type = "button";
        deleteButton.className = "delete-uploaded-image-button";
        deleteButton.dataset.publicId = image.publicId;
        deleteButton.dataset.url = image.url;
        deleteButton.textContent = "Удалить";
        deleteButton.style.border = "1px solid #fecaca";
        deleteButton.style.background = "#fef2f2";
        deleteButton.style.color = "#dc2626";
        deleteButton.style.borderRadius = "8px";
        deleteButton.style.padding = "7px 10px";
        deleteButton.style.cursor = "pointer";

        wrapper.appendChild(info);
        wrapper.appendChild(deleteButton);

        item.appendChild(wrapper);

        uploadedImagesList.prepend(item);
        refreshEmptyState();
    }

    async function loadUploadedImages() {
        const response = await fetch("/api/content-items/${draftId}/images");

        if (!response.ok) {
            return;
        }

        const images = await response.json();

        uploadedImagesList.innerHTML = "";

        images.forEach(addImageToList);
        refreshEmptyState();
    }

    function removeImageReferencesFromEditor(editor, imageUrl) {
        const markdown = editor.getMarkdown();

        const escapedUrl = imageUrl.replace(/[.*+?^$()|[\]\\{}]/g, "\\$&");
        const imageMarkdownRegex = new RegExp("!\\[[^\\]]*\\]\\(" + escapedUrl + "\\)\\s*", "g");

        const updatedMarkdown = markdown.replace(imageMarkdownRegex, "");

        if (updatedMarkdown !== markdown) {
            editor.setMarkdown(updatedMarkdown);
        }
    }

    document.addEventListener("click", async function (event) {
        const button = event.target.closest(".delete-uploaded-image-button");

        if (!button) {
            return;
        }

        const publicId = button.dataset.publicId;
        const imageUrl = button.dataset.url;

        if (!publicId) {
            return;
        }

        const confirmed = confirm("Удалить изображение? Ссылка на него будет удалена из текста.");

        if (!confirmed) {
            return;
        }

        button.disabled = true;

        const headers = {};

        if (csrfHeaderName && csrfToken) {
            headers[csrfHeaderName] = csrfToken;
        }

        try {
            const response = await fetch("/api/content-items/${draftId}/images/" + publicId, {
                method: "DELETE",
                headers: headers
            });

            if (!response.ok) {
                alert("Не удалось удалить изображение");
                button.disabled = false;
                return;
            }

            removeImageReferencesFromEditor(editor, imageUrl);

            const item = document.getElementById("uploaded-image-" + publicId);

            if (item) {
                item.remove();
            }

            refreshEmptyState();
        } catch (e) {
            console.error(e);
            alert("Не удалось удалить изображение");
            button.disabled = false;
        }
    });

    loadUploadedImages();
</script>

</body>
</html>

