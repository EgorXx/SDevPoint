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

        const caseEditForm = document.getElementById("caseEditForm");

        const descriptionTextArea = document.getElementById("description");
        const solutionTextArea = document.getElementById("solution");

        const hasSolutionSelect = document.getElementById("hasSolution");
        const solutionBlock = document.getElementById("solutionBlock");

        const descriptionEditorElement = document.getElementById("descriptionEditor");
        const solutionEditorElement = document.getElementById("solutionEditor");

        if (!caseEditForm
            || !descriptionTextArea
            || !solutionTextArea
            || !hasSolutionSelect
            || !solutionBlock
            || !descriptionEditorElement
            || !solutionEditorElement) {
            console.error("Case edit form elements not found");
            return;
        }

        <#if _csrf??>
        const csrfHeaderName = "${_csrf.headerName}";
        const csrfToken = "${_csrf.token}";
        <#else>
        const csrfHeaderName = null;
        const csrfToken = null;
        </#if>

        async function uploadImage(blob, callback) {
            const formData = new FormData();

            formData.append("file", blob);
            formData.append("contentItemId", "${contentItemId}");

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
                console.error(e);
                alert("Не удалось загрузить изображение");
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

        caseEditForm.addEventListener("submit", function () {
            descriptionTextArea.value = descriptionEditor.getMarkdown();

            if (hasSolutionSelect.value === "true") {
                solutionTextArea.value = solutionEditor.getMarkdown();
            } else {
                solutionTextArea.value = "";
            }
        });
    });
</script>

</body>
</html>