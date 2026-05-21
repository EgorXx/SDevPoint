(() => {
    document.addEventListener("DOMContentLoaded", () => {
        const csrfHeaderMeta = document.querySelector("meta[name='_csrf_header']");
        const csrfTokenMeta = document.querySelector("meta[name='_csrf']");

        const csrfHeaderName = csrfHeaderMeta ? csrfHeaderMeta.getAttribute("content") : null;
        const csrfToken = csrfTokenMeta ? csrfTokenMeta.getAttribute("content") : null;

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

                    if (body.error) {
                        return body.error;
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

        async function deleteContent(button) {
            const deleteUrl = button.dataset.deleteUrl;
            const cardId = button.dataset.cardId;

            if (!deleteUrl || !cardId) {
                return;
            }

            const confirmed = confirm("Удалить этот контент?");

            if (!confirmed) {
                return;
            }

            button.disabled = true;

            try {
                const response = await fetch(deleteUrl, {
                    method: "DELETE",
                    headers: buildHeaders(false)
                });

                if (!response.ok) {
                    const message = await extractErrorMessage(response, "Не удалось удалить контент");
                    alert(message);
                    button.disabled = false;
                    return;
                }

                const card = document.getElementById(cardId);

                if (card) {
                    card.remove();
                }

                const contentList = document.getElementById("contentList");

                if (contentList && contentList.children.length === 0) {
                    location.reload();
                }
            } catch (e) {
                console.error(e);
                alert("Не удалось удалить контент");
                button.disabled = false;
            }
        }

        async function withdrawContent(button) {
            const contentId = button.dataset.contentId;

            if (!contentId) {
                return;
            }

            const confirmed = confirm("Отозвать контент с проверки?");

            if (!confirmed) {
                return;
            }

            button.disabled = true;

            try {
                const response = await fetch("/api/content/" + contentId + "/withdraw", {
                    method: "POST",
                    headers: buildHeaders(false)
                });

                if (!response.ok) {
                    const message = await extractErrorMessage(response, "Не удалось отозвать контент");
                    alert(message);
                    button.disabled = false;
                    return;
                }

                location.reload();
            } catch (e) {
                console.error(e);
                alert("Не удалось отозвать контент");
                button.disabled = false;
            }
        }

        async function toggleRejectionComment(button) {
            const contentId = button.dataset.contentId;

            if (!contentId) {
                return;
            }

            const commentBlock = document.getElementById("rejection-comment-" + contentId);

            if (!commentBlock) {
                return;
            }

            if (commentBlock.style.display === "block") {
                commentBlock.style.display = "none";
                button.textContent = "Показать комментарий";
                return;
            }

            button.disabled = true;

            try {
                const response = await fetch("/api/my-content/" + contentId + "/rejection-comment");

                if (!response.ok) {
                    const message = await extractErrorMessage(response, "Не удалось загрузить комментарий");
                    alert(message);
                    button.disabled = false;
                    return;
                }

                const body = await response.json();

                commentBlock.textContent = body.comment || "Комментарий отсутствует";
                commentBlock.style.display = "block";
                button.textContent = "Скрыть комментарий";
                button.disabled = false;
            } catch (e) {
                console.error(e);
                alert("Не удалось загрузить комментарий");
                button.disabled = false;
            }
        }

        document.addEventListener("click", async (event) => {
            const deleteButton = event.target.closest(".delete-button");

            if (deleteButton) {
                await deleteContent(deleteButton);
                return;
            }

            const withdrawButton = event.target.closest(".withdraw-button");

            if (withdrawButton) {
                await withdrawContent(withdrawButton);
                return;
            }

            const rejectionCommentButton = event.target.closest(".show-rejection-comment-button");

            if (rejectionCommentButton) {
                await toggleRejectionComment(rejectionCommentButton);
            }
        });
    });
})();