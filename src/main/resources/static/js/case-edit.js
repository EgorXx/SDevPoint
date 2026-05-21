(() => {
    document.addEventListener("DOMContentLoaded", () => {
        const Editor = toastui.Editor;

        const caseEditForm = document.getElementById("caseEditForm");

        const descriptionTextArea = document.getElementById("description");
        const solutionTextArea = document.getElementById("solution");

        const descriptionEditorElement = document.getElementById("descriptionEditor");
        const solutionEditorElement = document.getElementById("solutionEditor");

        const solutionBlock = document.getElementById("solutionBlock");
        const hasSolutionInputs = document.querySelectorAll('input[name="hasSolution"]');

        const uploadError = document.getElementById("uploadError");

        const uploadedImagesList = document.getElementById("uploadedImagesList");
        const uploadedImagesEmpty = document.getElementById("uploadedImagesEmpty");

        const imageCurrentSize = document.getElementById("imageCurrentSize");
        const imageMaxSize = document.getElementById("imageMaxSize");
        const imageLimitProgress = document.getElementById("imageLimitProgress");

        const errorMessage = document.getElementById("errorMessage");

        if (errorMessage) {
            setTimeout(() => {
                errorMessage.classList.remove("create-alert--visible");
                errorMessage.textContent = "";
            }, 10000);
        }

        if (!caseEditForm
            || !descriptionTextArea
            || !solutionTextArea
            || !descriptionEditorElement
            || !solutionEditorElement
            || !solutionBlock
            || hasSolutionInputs.length === 0
            || !uploadError
            || !uploadedImagesList
            || !uploadedImagesEmpty
            || !imageCurrentSize
            || !imageMaxSize
            || !imageLimitProgress) {
            console.error("Case edit form elements not found");
            return;
        }

        const contentItemId = caseEditForm.dataset.contentItemId;

        const csrfTokenMeta = document.querySelector("meta[name='_csrf']");
        const csrfHeaderMeta = document.querySelector("meta[name='_csrf_header']");

        const csrfToken = csrfTokenMeta ? csrfTokenMeta.getAttribute("content") : null;
        const csrfHeaderName = csrfHeaderMeta ? csrfHeaderMeta.getAttribute("content") : null;

        const descriptionEditor = new Editor({
            el: descriptionEditorElement,
            height: "520px",
            initialEditType: "markdown",
            previewStyle: "vertical",
            initialValue: descriptionTextArea.value,
            usageStatistics: false,
            placeholder: "Введите описание кейса в Markdown...",

            hooks: {
                async addImageBlobHook(blob, callback) {
                    await uploadImage(blob, callback);
                }
            }
        });

        let solutionEditor = null;

        function ensureSolutionEditor() {
            if (solutionEditor) {
                return solutionEditor;
            }

            solutionEditor = new Editor({
                el: solutionEditorElement,
                height: "430px",
                initialEditType: "markdown",
                previewStyle: "vertical",
                initialValue: solutionTextArea.value,
                usageStatistics: false,
                placeholder: "Введите решение кейса в Markdown...",

                hooks: {
                    async addImageBlobHook(blob, callback) {
                        await uploadImage(blob, callback);
                    }
                }
            });

            return solutionEditor;
        }

        function isSolutionEnabled() {
            const checked = document.querySelector('input[name="hasSolution"]:checked');

            return checked && checked.value === "true";
        }

        function syncSolutionVisibility() {
            const enabled = isSolutionEnabled();

            solutionBlock.classList.toggle("create-solution-block--visible", enabled);

            if (enabled) {
                requestAnimationFrame(() => {
                    ensureSolutionEditor();
                });
            }
        }

        hasSolutionInputs.forEach((input) => {
            input.addEventListener("change", syncSolutionVisibility);
        });

        syncSolutionVisibility();

        caseEditForm.addEventListener("submit", () => {
            descriptionTextArea.value = descriptionEditor.getMarkdown();

            if (isSolutionEnabled()) {
                solutionTextArea.value = ensureSolutionEditor().getMarkdown();
            } else {
                solutionTextArea.value = "";
            }
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
            uploadError.classList.add("create-alert--visible");

            setTimeout(() => {
                uploadError.classList.remove("create-alert--visible");
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

        function getProgressColor(percent) {
            const ratio = Math.max(0, Math.min(percent, 100)) / 100;
            const start = 226;
            const end = 9;
            const channel = Math.round(start - ((start - end) * ratio));

            return `rgb(${channel}, ${channel}, ${channel})`;
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
            imageLimitProgress.style.backgroundColor = getProgressColor(percent);
        }

        function refreshEmptyState() {
            uploadedImagesEmpty.style.display =
                uploadedImagesList.children.length === 0 ? "block" : "none";
        }

        function createImageIcon() {
            const icon = document.createElement("span");
            icon.className = "create-image-item__icon";
            icon.innerHTML = `
                <svg viewBox="0 0 24 24" fill="none">
                    <path d="M5.5 3.5H18.5C19.6 3.5 20.5 4.4 20.5 5.5V18.5C20.5 19.6 19.6 20.5 18.5 20.5H5.5C4.4 20.5 3.5 19.6 3.5 18.5V5.5C3.5 4.4 4.4 3.5 5.5 3.5Z"
                          stroke="currentColor"
                          stroke-width="1.8"
                          stroke-linejoin="round"/>
                    <path d="M7 17L10.5 13.5L13 16L15 14L18 17"
                          stroke="currentColor"
                          stroke-width="1.8"
                          stroke-linecap="round"
                          stroke-linejoin="round"/>
                    <path d="M8.5 8.75H8.51"
                          stroke="currentColor"
                          stroke-width="2.6"
                          stroke-linecap="round"/>
                </svg>
            `;

            return icon;
        }

        function createTrashIcon() {
            const icon = document.createElement("span");
            icon.className = "create-image-delete__icon";
            icon.innerHTML = `
                <svg viewBox="0 0 24 24" fill="none">
                    <path d="M5 7H19"
                          stroke="currentColor"
                          stroke-width="1.8"
                          stroke-linecap="round"/>
                    <path d="M9 7V5.5C9 4.67 9.67 4 10.5 4H13.5C14.33 4 15 4.67 15 5.5V7"
                          stroke="currentColor"
                          stroke-width="1.8"
                          stroke-linecap="round"
                          stroke-linejoin="round"/>
                    <path d="M8 10V18"
                          stroke="currentColor"
                          stroke-width="1.8"
                          stroke-linecap="round"/>
                    <path d="M12 10V18"
                          stroke="currentColor"
                          stroke-width="1.8"
                          stroke-linecap="round"/>
                    <path d="M16 10V18"
                          stroke="currentColor"
                          stroke-width="1.8"
                          stroke-linecap="round"/>
                    <path d="M6.5 7L7.25 19C7.32 20.12 8.25 21 9.37 21H14.63C15.75 21 16.68 20.12 16.75 19L17.5 7"
                          stroke="currentColor"
                          stroke-width="1.8"
                          stroke-linejoin="round"/>
                </svg>
            `;

            return icon;
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
            item.className = "create-image-item";

            const info = document.createElement("div");
            info.className = "create-image-item__info";

            const icon = createImageIcon();

            const text = document.createElement("div");
            text.className = "create-image-item__text";

            const name = document.createElement("div");
            name.className = "create-image-item__name";
            name.textContent = image.originalName || "image";

            text.appendChild(name);

            info.appendChild(icon);
            info.appendChild(text);

            const meta = document.createElement("div");
            meta.className = "create-image-item__meta";

            const size = document.createElement("span");
            size.className = "create-image-item__size";
            size.textContent = formatImageSize(image.size || 0);

            const deleteButton = document.createElement("button");
            deleteButton.type = "button";
            deleteButton.className = "create-image-delete";
            deleteButton.dataset.publicId = image.publicId;
            deleteButton.dataset.url = image.url || "";
            deleteButton.setAttribute("aria-label", "Удалить изображение");
            deleteButton.appendChild(createTrashIcon());

            meta.appendChild(size);
            meta.appendChild(deleteButton);

            item.appendChild(info);
            item.appendChild(meta);

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

        function removeImageReferencesFromMarkdown(markdown, imageUrl) {
            if (!imageUrl) {
                return markdown;
            }

            const escapedUrl = escapeRegExp(imageUrl);
            const imageMarkdownRegex = new RegExp("!\\[[^\\]]*\\]\\(" + escapedUrl + "\\)\\s*", "g");

            return markdown.replace(imageMarkdownRegex, "");
        }

        function removeImageReferencesFromEditor(editorInstance, imageUrl) {
            if (!editorInstance || !imageUrl) {
                return;
            }

            const markdown = editorInstance.getMarkdown();
            const updatedMarkdown = removeImageReferencesFromMarkdown(markdown, imageUrl);

            if (updatedMarkdown !== markdown) {
                editorInstance.setMarkdown(updatedMarkdown);
            }
        }

        function removeImageReferencesFromTextarea(textarea, imageUrl) {
            if (!textarea || !imageUrl) {
                return;
            }

            const markdown = textarea.value;
            const updatedMarkdown = removeImageReferencesFromMarkdown(markdown, imageUrl);

            if (updatedMarkdown !== markdown) {
                textarea.value = updatedMarkdown;
            }
        }

        document.addEventListener("click", async (event) => {
            const button = event.target.closest(".create-image-delete");

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
                    showUploadError(message || "Не удалось удалить изображение");
                    button.disabled = false;
                    return;
                }

                const deleteResponse = await readJsonOrNull(response);

                removeImageReferencesFromEditor(descriptionEditor, imageUrl);
                removeImageReferencesFromEditor(solutionEditor, imageUrl);
                removeImageReferencesFromTextarea(solutionTextArea, imageUrl);

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
                showUploadError("Не удалось удалить изображение");
                button.disabled = false;
            }
        });

        loadUploadedImages();
    });
})();