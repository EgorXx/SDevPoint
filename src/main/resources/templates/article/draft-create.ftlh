<#import "/spring.ftl" as spring>

<#assign pageDraftId = draftId>
<#assign pageContentItemId = contentItemId!draftId>

<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Создание статьи</title>

    <#if _csrf??>
        <meta name="_csrf" content="${_csrf.token}">
        <meta name="_csrf_header" content="${_csrf.headerName}">
    </#if>

    <link
            rel="stylesheet"
            href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css"
    />

    <style>
        body {
            max-width: 980px;
            margin: 32px auto;
            padding: 0 20px;
            font-family: Arial, sans-serif;
            color: #111827;
            background: #ffffff;
        }

        h1 {
            margin-bottom: 24px;
        }

        label {
            font-weight: 600;
        }

        input,
        select {
            box-sizing: border-box;
            width: 100%;
            max-width: 520px;
            margin-top: 6px;
            padding: 9px 10px;
            border: 1px solid #d1d5db;
            border-radius: 8px;
            font-size: 15px;
        }

        button {
            border: none;
            border-radius: 8px;
            padding: 9px 14px;
            font-size: 15px;
            cursor: pointer;
        }

        .primary-button {
            background: #2563eb;
            color: #ffffff;
        }

        .secondary-button {
            background: #f3f4f6;
            color: #111827;
            border: 1px solid #d1d5db;
        }

        .field-error {
            color: #dc2626;
            margin-top: 6px;
            font-size: 14px;
        }

        .field-error p {
            margin: 4px 0;
        }

        .alert-error {
            display: none;
            color: #991b1b;
            background: #fef2f2;
            border: 1px solid #fecaca;
            padding: 12px;
            border-radius: 10px;
            margin-bottom: 16px;
        }

        .server-error {
            color: #991b1b;
            background: #fef2f2;
            border: 1px solid #fecaca;
            padding: 12px;
            border-radius: 10px;
            margin-bottom: 16px;
        }

        .images-block {
            margin-top: 24px;
            margin-bottom: 24px;
            padding: 18px;
            border: 1px solid #e5e7eb;
            border-radius: 14px;
            background: #fafafa;
        }

        .images-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            margin-bottom: 12px;
        }

        .images-header h3 {
            margin: 0;
        }

        .limit-info {
            color: #4b5563;
            font-size: 14px;
            white-space: nowrap;
        }

        .limit-progress-wrapper {
            height: 9px;
            background: #e5e7eb;
            border-radius: 999px;
            overflow: hidden;
            margin-bottom: 14px;
        }

        .limit-progress {
            height: 100%;
            width: 0;
            background: #2563eb;
            border-radius: 999px;
            transition: width 0.2s ease, background 0.2s ease;
        }

        .uploaded-images-empty {
            color: #6b7280;
        }

        .uploaded-images-list {
            display: grid;
            gap: 10px;
        }

        .uploaded-image-item {
            padding: 12px;
            border: 1px solid #e5e7eb;
            border-radius: 10px;
            background: #ffffff;
        }

        .uploaded-image-row {
            display: flex;
            justify-content: space-between;
            gap: 12px;
            align-items: flex-start;
        }

        .uploaded-image-name {
            font-weight: 600;
            word-break: break-word;
        }

        .uploaded-image-size {
            color: #6b7280;
            font-size: 14px;
            margin-top: 4px;
        }

        .uploaded-image-link {
            font-size: 14px;
            margin-top: 4px;
            word-break: break-all;
        }

        .uploaded-image-link a {
            color: #2563eb;
        }

        .delete-uploaded-image-button {
            flex-shrink: 0;
            border: 1px solid #fecaca;
            background: #fef2f2;
            color: #dc2626;
            border-radius: 8px;
            padding: 7px 10px;
            cursor: pointer;
        }

        .delete-uploaded-image-button:disabled {
            opacity: 0.6;
            cursor: default;
        }

        .actions {
            display: flex;
            gap: 10px;
            margin-top: 20px;
        }
    </style>
</head>
<body>

<h1>Создание статьи</h1>

<#if error?? && error?has_content>
    <div class="server-error">
        ${error}
    </div>
</#if>

<div id="uploadError" class="alert-error"></div>

<form
        id="articleForm"
        method="post"
        action="/articles/drafts/${pageDraftId}/publish"
        data-draft-id="${pageDraftId}"
        data-content-item-id="${pageContentItemId}"
>

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
            <div class="field-error">
                <#list spring.status.errorMessages as validationError>
                    <p>${validationError}</p>
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
            <div class="field-error">
                <#list spring.status.errorMessages as validationError>
                    <p>${validationError}</p>
                </#list>
            </div>
        </#if>
    </div>

    <div id="uploadedImagesBlock" class="images-block">
        <div class="images-header">
            <h3>Загруженные изображения</h3>

            <div id="imageLimitInfo" class="limit-info">
                Использовано:
                <strong id="imageCurrentSize">0 МБ</strong>
                из
                <strong id="imageMaxSize">0 МБ</strong>
            </div>
        </div>

        <div class="limit-progress-wrapper">
            <div id="imageLimitProgress" class="limit-progress"></div>
        </div>

        <div id="uploadedImagesEmpty" class="uploaded-images-empty">
            Изображений пока нет.
        </div>

        <div id="uploadedImagesList" class="uploaded-images-list"></div>
    </div>

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
            <div class="field-error">
                <#list spring.status.errorMessages as validationError>
                    <p>${validationError}</p>
                </#list>
            </div>
        </#if>
    </div>

    <div class="actions">
        <button
                type="submit"
                class="secondary-button"
                formaction="/articles/drafts/${pageDraftId}"
                formmethod="post">
            Сохранить черновик
        </button>

        <button
                type="submit"
                class="primary-button"
                formaction="/articles/drafts/${pageDraftId}/publish"
                formmethod="post">
            Опубликовать статью
        </button>
    </div>

</form>

<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const Editor = toastui.Editor;

        const articleForm = document.getElementById("articleForm");
        const textArea = document.getElementById("text");
        const editorElement = document.getElementById("editor");

        const uploadError = document.getElementById("uploadError");

        const uploadedImagesList = document.getElementById("uploadedImagesList");
        const uploadedImagesEmpty = document.getElementById("uploadedImagesEmpty");

        const imageCurrentSize = document.getElementById("imageCurrentSize");
        const imageMaxSize = document.getElementById("imageMaxSize");
        const imageLimitProgress = document.getElementById("imageLimitProgress");

        if (!articleForm
            || !textArea
            || !editorElement
            || !uploadError
            || !uploadedImagesList
            || !uploadedImagesEmpty
            || !imageCurrentSize
            || !imageMaxSize
            || !imageLimitProgress) {
            console.error("Article form elements not found");
            return;
        }

        const draftId = articleForm.dataset.draftId;
        const contentItemId = articleForm.dataset.contentItemId;

        const csrfTokenMeta = document.querySelector("meta[name='_csrf']");
        const csrfHeaderMeta = document.querySelector("meta[name='_csrf_header']");

        const csrfToken = csrfTokenMeta ? csrfTokenMeta.getAttribute("content") : null;
        const csrfHeaderName = csrfHeaderMeta ? csrfHeaderMeta.getAttribute("content") : null;

        const editor = new Editor({
            el: editorElement,
            height: "500px",
            initialEditType: "markdown",
            previewStyle: "vertical",
            initialValue: textArea.value,
            usageStatistics: false,

            hooks: {
                async addImageBlobHook(blob, callback) {
                    await uploadImage(blob, callback);
                }
            }
        });

        articleForm.addEventListener("submit", function () {
            textArea.value = editor.getMarkdown();
        });

        function buildCsrfHeaders() {
            const headers = {};

            if (csrfHeaderName && csrfToken) {
                headers[csrfHeaderName] = csrfToken;
            }

            return headers;
        }

        function showUploadError(message) {
            uploadError.textContent = message || "Произошла ошибка";
            uploadError.style.display = "block";

            setTimeout(function () {
                uploadError.style.display = "none";
                uploadError.textContent = "";
            }, 7000);
        }

        async function extractErrorMessage(response) {
            const defaultMessage = "Не удалось выполнить запрос";

            const contentType = response.headers.get("content-type");

            if (contentType && contentType.includes("application/json")) {
                try {
                    const errorBody = await response.json();

                    if (errorBody.message) {
                        return errorBody.message;
                    }

                    if (errorBody.error) {
                        return errorBody.error;
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

        async function readJsonOrNull(response) {
            const contentType = response.headers.get("content-type");

            if (!contentType || !contentType.includes("application/json")) {
                return null;
            }

            try {
                return await response.json();
            } catch (e) {
                return null;
            }
        }

        async function uploadImage(blob, callback) {
            const formData = new FormData();

            formData.append("file", blob);
            formData.append("contentItemId", contentItemId);

            try {
                const response = await fetch("/api/upload/image", {
                    method: "POST",
                    headers: buildCsrfHeaders(),
                    body: formData
                });

                if (!response.ok) {
                    const message = await extractErrorMessage(response);
                    showUploadError(message || "Не удалось загрузить изображение");
                    return;
                }

                const image = await response.json();

                if (!image || !image.url) {
                    showUploadError("Сервер не вернул ссылку на изображение");
                    return;
                }

                callback(image.url, image.originalName || "image");

                addImageToList(image);

                if (image.limit) {
                    updateImageLimit(image.limit);
                } else {
                    await loadUploadedImages();
                }
            } catch (e) {
                console.error(e);
                showUploadError("Не удалось загрузить изображение");
            }
        }

        function normalizeLimit(limit) {
            if (!limit) {
                return null;
            }

            return {
                currentSize: Number(limit.currentSize ?? limit.currentSizeBytes ?? 0),
                maxSize: Number(limit.maxSize ?? limit.maxSizeBytes ?? 0)
            };
        }

        function getSizeUnit(maxSize) {
            if (maxSize >= 1024 * 1024) {
                return {
                    divisor: 1024 * 1024,
                    suffix: "МБ"
                };
            }

            if (maxSize >= 1024) {
                return {
                    divisor: 1024,
                    suffix: "КБ"
                };
            }

            return {
                divisor: 1,
                suffix: "Б"
            };
        }

        function formatBytesInUnit(bytes, unit) {
            const value = bytes / unit.divisor;

            if (unit.suffix === "Б") {
                return Math.round(value) + " " + unit.suffix;
            }

            return value.toFixed(1) + " " + unit.suffix;
        }

        function formatImageSize(bytes) {
            const safeBytes = Number(bytes || 0);

            if (safeBytes < 1024) {
                return safeBytes + " Б";
            }

            if (safeBytes < 1024 * 1024) {
                return (safeBytes / 1024).toFixed(1) + " КБ";
            }

            return (safeBytes / (1024 * 1024)).toFixed(1) + " МБ";
        }

        function updateImageLimit(rawLimit) {
            const limit = normalizeLimit(rawLimit);

            if (!limit) {
                return;
            }

            const currentSize = Math.max(limit.currentSize, 0);
            const maxSize = Math.max(limit.maxSize, 0);

            const unit = getSizeUnit(maxSize);

            imageCurrentSize.textContent = formatBytesInUnit(currentSize, unit);
            imageMaxSize.textContent = formatBytesInUnit(maxSize, unit);

            const percent = maxSize === 0
                ? 0
                : Math.min((currentSize / maxSize) * 100, 100);

            imageLimitProgress.style.width = percent + "%";

            if (percent >= 90) {
                imageLimitProgress.style.background = "#dc2626";
            } else if (percent >= 70) {
                imageLimitProgress.style.background = "#f59e0b";
            } else {
                imageLimitProgress.style.background = "#2563eb";
            }
        }

        function refreshEmptyState() {
            uploadedImagesEmpty.style.display =
                uploadedImagesList.children.length === 0 ? "block" : "none";
        }

        function addImageToList(image) {
            if (!image || !image.publicId) {
                return;
            }

            const existing = document.getElementById("uploaded-image-" + image.publicId);

            if (existing) {
                return;
            }

            const item = document.createElement("div");
            item.id = "uploaded-image-" + image.publicId;
            item.className = "uploaded-image-item";

            const row = document.createElement("div");
            row.className = "uploaded-image-row";

            const info = document.createElement("div");

            const name = document.createElement("div");
            name.className = "uploaded-image-name";
            name.textContent = image.originalName || "image";

            const size = document.createElement("div");
            size.className = "uploaded-image-size";
            size.textContent = formatImageSize(image.size || 0);

            const linkWrapper = document.createElement("div");
            linkWrapper.className = "uploaded-image-link";

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
            deleteButton.dataset.url = image.url || "";
            deleteButton.textContent = "Удалить";

            row.appendChild(info);
            row.appendChild(deleteButton);

            item.appendChild(row);

            uploadedImagesList.prepend(item);
            refreshEmptyState();
        }

        async function loadUploadedImages() {
            try {
                const response = await fetch(
                    "/api/content-items/" + encodeURIComponent(contentItemId) + "/images"
                );

                if (!response.ok) {
                    return;
                }

                const imagesView = await response.json();

                uploadedImagesList.innerHTML = "";

                if (imagesView.images) {
                    imagesView.images.forEach(addImageToList);
                }

                updateImageLimit(imagesView.limit);
                refreshEmptyState();
            } catch (e) {
                console.error(e);
            }
        }

        function escapeRegExp(value) {
            return value.replace(/[.*+?^$()|[\]\\{}]/g, "\\$&");
        }

        function removeImageReferencesFromEditor(editor, imageUrl) {
            if (!imageUrl) {
                return;
            }

            const markdown = editor.getMarkdown();

            const escapedUrl = escapeRegExp(imageUrl);
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

            try {
                const response = await fetch(
                    "/api/content-items/"
                    + encodeURIComponent(contentItemId)
                    + "/images/"
                    + encodeURIComponent(publicId),
                    {
                        method: "DELETE",
                        headers: buildCsrfHeaders()
                    }
                );

                if (!response.ok) {
                    const message = await extractErrorMessage(response);
                    alert(message || "Не удалось удалить изображение");
                    button.disabled = false;
                    return;
                }

                const deleteResponse = await readJsonOrNull(response);

                removeImageReferencesFromEditor(editor, imageUrl);

                const item = document.getElementById("uploaded-image-" + publicId);

                if (item) {
                    item.remove();
                }

                if (deleteResponse && deleteResponse.limit) {
                    updateImageLimit(deleteResponse.limit);
                } else if (deleteResponse) {
                    updateImageLimit(deleteResponse);
                } else {
                    await loadUploadedImages();
                }

                refreshEmptyState();
            } catch (e) {
                console.error(e);
                alert("Не удалось удалить изображение");
                button.disabled = false;
            }
        });

        loadUploadedImages();
    });
</script>

</body>
</html>
