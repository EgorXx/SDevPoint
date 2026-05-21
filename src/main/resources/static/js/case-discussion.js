(() => {
    document.addEventListener("DOMContentLoaded", () => {
        const discussionRoot = document.querySelector(".case-discussion");
        const textareas = document.querySelectorAll(".discussion-comment-textarea");

        if (!discussionRoot) {
            return;
        }

        const caseId = discussionRoot.dataset.caseId;

        const csrfHeaderMeta = document.querySelector('meta[name="csrf-header"]');
        const csrfTokenMeta = document.querySelector('meta[name="csrf-token"]');

        const csrfHeaderName = csrfHeaderMeta ? csrfHeaderMeta.content : null;
        const csrfToken = csrfTokenMeta ? csrfTokenMeta.content : null;

        function buildHeaders() {
            const headers = {};

            if (csrfHeaderName && csrfToken) {
                headers[csrfHeaderName] = csrfToken;
            }

            return headers;
        }

        function showPageMessage(message) {
            const pageMessage = document.getElementById("pageMessage");

            if (!pageMessage) {
                return;
            }

            pageMessage.textContent = message || "Произошла ошибка";
            pageMessage.classList.add("discussion-message--error");

            setTimeout(() => {
                pageMessage.textContent = "";
                pageMessage.classList.remove("discussion-message--error");
            }, 7000);
        }

        function resizeTextarea(textarea) {
            textarea.style.height = "auto";
            textarea.style.height = textarea.scrollHeight + "px";
        }

        textareas.forEach((textarea) => {
            resizeTextarea(textarea);

            textarea.addEventListener("input", () => {
                resizeTextarea(textarea);
            });
        });

        document.addEventListener("click", async (event) => {
            const button = event.target.closest(".delete-comment-button");

            if (!button) {
                return;
            }

            const commentId = button.dataset.commentId;

            if (!commentId) {
                return;
            }

            const confirmed = confirm("Удалить комментарий?");

            if (!confirmed) {
                return;
            }

            button.disabled = true;

            try {
                const response = await fetch("/api/cases/" + caseId + "/comments/" + commentId, {
                    method: "DELETE",
                    headers: buildHeaders()
                });

                if (!response.ok) {
                    showPageMessage("Не удалось удалить комментарий.");
                    button.disabled = false;
                    return;
                }

                const commentElement = document.getElementById("comment-" + commentId);

                if (commentElement) {
                    commentElement.remove();
                }
            } catch (e) {
                console.error(e);
                showPageMessage("Не удалось удалить комментарий.");
                button.disabled = false;
            }
        });
    });
})();