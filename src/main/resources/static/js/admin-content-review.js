(() => {
    const csrfHeaderMeta = document.querySelector('meta[name="csrf-header"]');
    const csrfTokenMeta = document.querySelector('meta[name="csrf-token"]');

    const csrfHeaderName = csrfHeaderMeta ? csrfHeaderMeta.content : null;
    const csrfToken = csrfTokenMeta ? csrfTokenMeta.content : null;

    function buildHeaders(jsonBody) {
        const headers = {};

        if (csrfHeaderName && csrfToken) {
            headers[csrfHeaderName] = csrfToken;
        }

        if (jsonBody) {
            headers["Content-Type"] = "application/json";
        }

        return headers;
    }

    async function extractErrorMessage(response, defaultMessage) {
        const contentType = response.headers.get("content-type");

        if (contentType && contentType.includes("application/json")) {
            try {
                const body = await response.json();

                if (body.message) {
                    return body.message;
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

    function removeCard(cardId) {
        const card = document.getElementById(cardId);

        if (card) {
            card.remove();
        }

        const contentList = document.getElementById("contentList");

        if (contentList && contentList.children.length === 0) {
            location.reload();
        }
    }

    function resizeTextarea(textarea) {
        if (!textarea) {
            return;
        }

        textarea.style.height = "auto";
        textarea.style.height = textarea.scrollHeight + "px";
    }

    async function approveContent(button) {
        const contentId = button.dataset.contentId;
        const cardId = button.dataset.cardId;

        if (!contentId || !cardId) {
            return;
        }

        const confirmed = confirm("Одобрить публикацию контента?");

        if (!confirmed) {
            return;
        }

        button.disabled = true;

        try {
            const response = await fetch("/api/admin/content/" + contentId + "/approve", {
                method: "POST",
                headers: buildHeaders(false)
            });

            if (!response.ok) {
                const message = await extractErrorMessage(response, "Не удалось одобрить контент");
                alert(message);
                button.disabled = false;
                return;
            }

            removeCard(cardId);
        } catch (e) {
            console.error(e);
            alert("Не удалось одобрить контент");
            button.disabled = false;
        }
    }

    function showRejectForm(button) {
        const formId = button.dataset.formId;

        if (!formId) {
            return;
        }

        const form = document.getElementById(formId);

        if (!form) {
            return;
        }

        form.classList.add("moderation-reject-form--visible");

        const textarea = form.querySelector(".moderation-reject-textarea");

        if (textarea) {
            resizeTextarea(textarea);
            textarea.focus();
        }
    }

    function hideRejectForm(button) {
        const formId = button.dataset.formId;

        if (!formId) {
            return;
        }

        const form = document.getElementById(formId);

        if (form) {
            form.classList.remove("moderation-reject-form--visible");
        }
    }

    async function rejectContent(button) {
        const contentId = button.dataset.contentId;
        const cardId = button.dataset.cardId;
        const commentId = button.dataset.commentId;
        const errorId = button.dataset.errorId;

        if (!contentId || !cardId || !commentId || !errorId) {
            return;
        }

        const commentInput = document.getElementById(commentId);
        const errorBlock = document.getElementById(errorId);

        if (!commentInput || !errorBlock) {
            return;
        }

        const comment = commentInput.value.trim();

        if (!comment) {
            errorBlock.textContent = "Укажите причину отклонения";
            errorBlock.classList.add("moderation-reject-error--visible");
            resizeTextarea(commentInput);
            return;
        }

        errorBlock.classList.remove("moderation-reject-error--visible");
        errorBlock.textContent = "";
        button.disabled = true;

        try {
            const response = await fetch("/api/admin/content/" + contentId + "/reject", {
                method: "POST",
                headers: buildHeaders(true),
                body: JSON.stringify({
                    comment: comment
                })
            });

            if (!response.ok) {
                const message = await extractErrorMessage(response, "Не удалось отклонить контент");
                errorBlock.textContent = message;
                errorBlock.classList.add("moderation-reject-error--visible");
                button.disabled = false;
                return;
            }

            removeCard(cardId);
        } catch (e) {
            console.error(e);
            errorBlock.textContent = "Не удалось отклонить контент";
            errorBlock.classList.add("moderation-reject-error--visible");
            button.disabled = false;
        }
    }

    document.addEventListener("input", (event) => {
        const textarea = event.target.closest(".moderation-reject-textarea");

        if (textarea) {
            resizeTextarea(textarea);
        }
    });

    document.addEventListener("click", async (event) => {
        const approveButton = event.target.closest(".approve-button");

        if (approveButton) {
            await approveContent(approveButton);
            return;
        }

        const rejectButton = event.target.closest(".reject-button:not(.confirm-reject-button)");

        if (rejectButton) {
            showRejectForm(rejectButton);
            return;
        }

        const confirmRejectButton = event.target.closest(".confirm-reject-button");

        if (confirmRejectButton) {
            await rejectContent(confirmRejectButton);
            return;
        }

        const cancelRejectButton = event.target.closest(".cancel-reject-button");

        if (cancelRejectButton) {
            hideRejectForm(cancelRejectButton);
        }
    });

    document.querySelectorAll(".moderation-reject-textarea").forEach(resizeTextarea);
})();