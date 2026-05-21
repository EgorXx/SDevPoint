(() => {
    const csrfHeaderMeta = document.querySelector('meta[name="csrf-header"]');
    const csrfTokenMeta = document.querySelector('meta[name="csrf-token"]');

    const csrfHeaderName = csrfHeaderMeta ? csrfHeaderMeta.content : null;
    const csrfToken = csrfTokenMeta ? csrfTokenMeta.content : null;

    function showPageError(message) {
        const errorBlock = document.getElementById("pageError");

        if (!errorBlock) {
            return;
        }

        errorBlock.textContent = message;
        errorBlock.classList.add("page-error--visible");

        setTimeout(() => {
            errorBlock.classList.remove("page-error--visible");
            errorBlock.textContent = "";
        }, 7000);
    }

    document.addEventListener("click", async (event) => {
        const button = event.target.closest(".favorite-button");

        if (!button) {
            return;
        }

        event.preventDefault();
        event.stopPropagation();

        const contentId = button.dataset.contentId;

        if (!contentId) {
            return;
        }

        button.disabled = true;

        const headers = {};

        if (csrfHeaderName && csrfToken) {
            headers[csrfHeaderName] = csrfToken;
        }

        try {
            const response = await fetch("/api/favorites/content/" + contentId, {
                method: "POST",
                headers: headers
            });

            if (response.status === 401) {
                showPageError("Необходимо авторизоваться, чтобы добавить контент в избранное.");
                button.disabled = false;
                return;
            }

            if (response.status === 403) {
                showPageError("Недостаточно прав для изменения избранного.");
                button.disabled = false;
                return;
            }

            if (!response.ok) {
                showPageError("Не удалось изменить избранное.");
                button.disabled = false;
                return;
            }

            const isFavoriteNow = button.classList.toggle("active");

            const title = isFavoriteNow
                ? "Убрать из избранного"
                : "Добавить в избранное";

            button.title = title;
            button.setAttribute("aria-label", title);

            button.disabled = false;
        } catch (e) {
            console.error(e);
            showPageError("Не удалось изменить избранное.");
            button.disabled = false;
        }
    });
})();