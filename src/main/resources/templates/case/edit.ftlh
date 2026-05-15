<#import "/spring.ftl" as spring>

<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Редактирование кейса</title>

    <link
            rel="stylesheet"
            href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css"
    />
</head>
<body>

<h1>Редактирование кейса</h1>

<div
        id="uploadError"
        style="display: none; color: #b91c1c; background: #fef2f2; border: 1px solid #fecaca; padding: 12px; border-radius: 8px; margin-bottom: 16px;">
</div>

<#if error?? && error?has_content>
    <div id="error-message"
         style="color: red; margin-bottom: 16px; border: 1px solid red; padding: 12px;">
        ${error}
    </div>

    <script>
        setTimeout(function () {
            const errorBlock = document.getElementById("error-message");

            if (errorBlock) {
                errorBlock.style.display = "none";
            }
        }, 10000);
    </script>
</#if>

<form id="caseEditForm" method="post" action="/cases/${contentItemId}">

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
                <#list spring.status.errorMessages as validationError>
                    <p>${validationError}</p>
                </#list>
            </div>
        </#if>
    </div>

    <br>

    <div>
        <label for="descriptionEditor">Описание кейса</label>
        <br>

        <textarea
                id="description"
                name="description"
                style="display: none;">${(form.description())!''}</textarea>

        <div id="descriptionEditor"></div>

        <@spring.bind "form.description"/>
        <#if spring.status.error>
            <div style="color: red;">
                <#list spring.status.errorMessages as validationError>
                    <p>${validationError}</p>
                </#list>
            </div>
        </#if>
    </div>

    <br>

    <div>
        <label for="hasSolution">Наличие решения</label>
        <br>

        <select id="hasSolution" name="hasSolution">
            <option value="false"
                    <#if !((form.hasSolution())!false)>selected</#if>>
                Решения пока нет
            </option>

            <option value="true"
                    <#if ((form.hasSolution())!false)>selected</#if>>
                Решение есть
            </option>
        </select>

        <@spring.bind "form.hasSolution"/>
        <#if spring.status.error>
            <div style="color: red;">
                <#list spring.status.errorMessages as validationError>
                    <p>${validationError}</p>
                </#list>
            </div>
        </#if>
    </div>

    <br>

    <div id="solutionBlock">
        <label for="solutionEditor">Решение кейса</label>
        <br>

        <textarea
                id="solution"
                name="solution"
                style="display: none;">${(form.solution())!''}</textarea>

        <div id="solutionEditor"></div>

        <@spring.bind "form.solution"/>
        <#if spring.status.error>
            <div style="color: red;">
                <#list spring.status.errorMessages as validationError>
                    <p>${validationError}</p>
                </#list>
            </div>
        </#if>
    </div>

    <br>

    <div id="uploadedImagesBlock"
         style="margin-top: 24px; padding: 16px; border: 1px solid #e5e7eb; border-radius: 12px;">
        <h3 style="margin-top: 0;">Загруженные изображения</h3>

        <div id="uploadedImagesEmpty" style="color: #6b7280;">
            Изображений пока нет.
        </div>

        <div id="uploadedImagesList" style="display: grid; gap: 10px;"></div>
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
                <#list spring.status.errorMessages as validationError>
                    <p>${validationError}</p>
                </#list>
            </div>
        </#if>
    </div>

    <br>

    <button type="submit">Сохранить</button>

</form>

<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const Editor = toastui.Editor;

        const contentItemId = "${contentItemId}";

        const caseEditForm = document.getElementById("caseEditForm");

        const descriptionTextArea = document.getElementById("description");
        const solutionTextArea = document.getElementById("solution");

        const hasSolutionSelect = document.getElementById("hasSolution");
        const solutionBlock = document.getElementById("solutionBlock");

        const descriptionEditorElement = document.getElementById("descriptionEditor");
        const solutionEditorElement = document.getElementById("solutionEditor");

        const uploadError = document.getElementById("uploadError");
        const uploadedImagesList = document.getElementById("uploadedImagesList");
        const uploadedImagesEmpty = document.getElementById("uploadedImagesEmpty");

        if (!caseEditForm
            || !descriptionTextArea
            || !solutionTextArea
            || !hasSolutionSelect
            || !solutionBlock
            || !descriptionEditorElement
            || !solutionEditorElement
            || !uploadError
            || !uploadedImagesList
            || !uploadedImagesEmpty) {
            console.error("Case edit form elements not found");
            return;
        }

        const csrfHeaderName = <#if _csrf??>"${_csrf.headerName}"<#else>null</#if>;
        const csrfToken = <#if _csrf??>"${_csrf.token}"<#else>null</#if>;

        function showUploadError(message) {
            uploadError.textContent = message;
            uploadError.style.display = "block";

            setTimeout(function () {
                uploadError.style.display = "none";
                uploadError.textContent = "";
            }, 7000);
        }

        async function extractErrorMessage(response) {
            const defaultMessage = "Не удалось выполнить операцию с изображением";
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

        function formatBytes(bytes) {
            if (bytes < 1024) {
                return bytes + " Б";
            }

            if (bytes < 1024 * 1024) {
                return (bytes / 1024).toFixed(1) + " КБ";
            }

            return (bytes / (1024 * 1024)).toFixed(1) + " МБ";
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

            const meta = document.createElement("div");
            meta.style.color = "#6b7280";
            meta.style.fontSize = "14px";
            meta.textContent = formatBytes(image.size || 0);

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
            info.appendChild(meta);
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
            try {
                const response = await fetch("/api/content-items/" + contentItemId + "/images");

                if (!response.ok) {
                    return;
                }

                const images = await response.json();

                uploadedImagesList.innerHTML = "";

                images.forEach(addImageToList);
                refreshEmptyState();
            } catch (e) {
                console.error(e);
            }
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

        async function uploadImage(blob, callback) {
            const formData = new FormData();

            formData.append("file", blob);
            formData.append("contentItemId", contentItemId);

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

        const descriptionEditor = new Editor({
            el: descriptionEditorElement,
            height: "450px",
            initialEditType: "markdown",
            previewStyle: "vertical",
            initialValue: descriptionTextArea.value,
            usageStatistics: false,

            hooks: {
                async addImageBlobHook(blob, callback) {
                    await uploadImage(blob, callback);
                }
            }
        });

        const solutionEditor = new Editor({
            el: solutionEditorElement,
            height: "450px",
            initialEditType: "markdown",
            previewStyle: "vertical",
            initialValue: solutionTextArea.value,
            usageStatistics: false,

            hooks: {
                async addImageBlobHook(blob, callback) {
                    await uploadImage(blob, callback);
                }
            }
        });

        function syncSolutionVisibility() {
            if (hasSolutionSelect.value === "true") {
                solutionBlock.style.display = "block";
            } else {
                solutionBlock.style.display = "none";
            }
        }

        hasSolutionSelect.addEventListener("change", syncSolutionVisibility);
        syncSolutionVisibility();

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

            const confirmed = confirm("Удалить изображение? Ссылка на него будет удалена из описания и решения.");

            if (!confirmed) {
                return;
            }

            button.disabled = true;

            const headers = {};

            if (csrfHeaderName && csrfToken) {
                headers[csrfHeaderName] = csrfToken;
            }

            try {
                const response = await fetch("/api/content-items/" + contentItemId + "/images/" + publicId, {
                    method: "DELETE",
                    headers: headers
                });

                if (!response.ok) {
                    const message = await extractErrorMessage(response);
                    showUploadError(message);
                    button.disabled = false;
                    return;
                }

                removeImageReferencesFromEditor(descriptionEditor, imageUrl);
                removeImageReferencesFromEditor(solutionEditor, imageUrl);

                const item = document.getElementById("uploaded-image-" + publicId);

                if (item) {
                    item.remove();
                }

                refreshEmptyState();
            } catch (e) {
                console.error(e);
                showUploadError("Не удалось удалить изображение");
                button.disabled = false;
            }
        });

        caseEditForm.addEventListener("submit", function () {
            descriptionTextArea.value = descriptionEditor.getMarkdown();

            if (hasSolutionSelect.value === "true") {
                solutionTextArea.value = solutionEditor.getMarkdown();
            } else {
                solutionTextArea.value = "";
            }
        });

        loadUploadedImages();
    });
</script>

</body>
</html>