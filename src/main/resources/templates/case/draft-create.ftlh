<#import "/spring.ftl" as spring>

<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Создание кейса</title>

    <link
            rel="stylesheet"
            href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css"
    />
</head>
<body>

<h1>Создание кейса</h1>

<form id="caseForm" method="post" action="/cases/drafts/${draftId}/publish">

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
                <#list spring.status.errorMessages as error>
                    <p>${error}</p>
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
                <#list spring.status.errorMessages as error>
                    <p>${error}</p>
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
                formaction="/cases/drafts/${draftId}"
                formmethod="post">
            Сохранить черновик
        </button>

        <button
                type="submit"
                formaction="/cases/drafts/${draftId}/publish"
                formmethod="post">
            Опубликовать кейс
        </button>
    </div>

</form>

<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>

<script>
    const Editor = toastui.Editor;

    const caseForm = document.getElementById("caseForm");

    const descriptionTextArea = document.getElementById("description");
    const solutionTextArea = document.getElementById("solution");

    const hasSolutionSelect = document.getElementById("hasSolution");
    const solutionBlock = document.getElementById("solutionBlock");

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

    const descriptionEditor = new Editor({
        el: document.querySelector("#descriptionEditor"),
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
        el: document.querySelector("#solutionEditor"),
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

    caseForm.addEventListener("submit", function () {
        descriptionTextArea.value = descriptionEditor.getMarkdown();

        if (hasSolutionSelect.value === "true") {
            solutionTextArea.value = solutionEditor.getMarkdown();
        } else {
            solutionTextArea.value = "";
        }
    });
</script>

</body>
</html>