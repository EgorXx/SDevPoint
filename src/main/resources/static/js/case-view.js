(() => {
    document.addEventListener("DOMContentLoaded", () => {
        const page = document.querySelector(".content-view-page");
        const contentItemId = page ? page.dataset.contentId : null;

        const csrfHeaderMeta = document.querySelector('meta[name="csrf-header"]');
        const csrfTokenMeta = document.querySelector('meta[name="csrf-token"]');

        const csrfHeaderName = csrfHeaderMeta ? csrfHeaderMeta.content : null;
        const csrfToken = csrfTokenMeta ? csrfTokenMeta.content : null;

        const favoriteButton = document.getElementById("favoriteButton");
        const favoriteText = document.getElementById("favoriteText");

        const caseAiContent = document.getElementById("caseAiContent");

        const likeButton = document.getElementById("likeButton");
        const dislikeButton = document.getElementById("dislikeButton");
        const likesCount = document.getElementById("likesCount");
        const dislikesCount = document.getElementById("dislikesCount");

        const aiSummaryButton = document.getElementById("aiSummaryButton");
        const aiExplainButton = document.getElementById("aiExplainButton");
        const aiSelectedTerm = document.getElementById("aiSelectedTerm");
        const aiSelectedTermText = document.getElementById("aiSelectedTermText");
        const aiMessage = document.getElementById("aiMessage");

        const aiSummaryResult = document.getElementById("aiSummaryResult");
        const aiSummaryResultContent = document.getElementById("aiSummaryResultContent");
        const aiTermResult = document.getElementById("aiTermResult");
        const aiTermResultTitle = document.getElementById("aiTermResultTitle");
        const aiTermResultContent = document.getElementById("aiTermResultContent");

        let aiRequestInProgress = false;

        function buildHeaders(jsonBody) {
            const headers = {
                "Accept": "application/json",
                "X-Requested-With": "XMLHttpRequest"
            };

            if (csrfHeaderName && csrfToken) {
                headers[csrfHeaderName] = csrfToken;
            }

            if (jsonBody) {
                headers["Content-Type"] = "application/json";
            }

            return headers;
        }

        function showPageMessage(message, type) {
            const pageMessage = document.getElementById("pageMessage");

            if (!pageMessage) {
                return;
            }

            pageMessage.textContent = message || "Произошла ошибка";
            pageMessage.className = "content-message content-message--" + type;

            setTimeout(() => {
                pageMessage.textContent = "";
                pageMessage.className = "content-message";
            }, 7000);
        }

        async function extractErrorMessage(response) {
            const defaultMessage = "Не удалось выполнить запрос";
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

                if (text && text.trim().length > 0 && !text.includes("<!DOCTYPE html")) {
                    return text;
                }

                return defaultMessage;
            } catch (e) {
                return defaultMessage;
            }
        }

        function initSolutionToggle() {
            const solution = document.getElementById("caseSolution");
            const toggleSolutionButton = document.getElementById("toggleSolutionButton");

            if (!solution || !toggleSolutionButton) {
                return;
            }

            toggleSolutionButton.addEventListener("click", () => {
                const opened = solution.dataset.opened === "true";
                const nextOpened = !opened;

                solution.dataset.opened = String(nextOpened);
                solution.classList.toggle("case-solution--opened", nextOpened);

                toggleSolutionButton.setAttribute("aria-expanded", String(nextOpened));
                toggleSolutionButton.textContent = nextOpened
                    ? "Скрыть решение"
                    : "Показать решение";
            });
        }

        function initFavourite() {
            if (!favoriteButton || !favoriteText || !contentItemId) {
                return;
            }

            function isAuthenticated() {
                return favoriteButton.dataset.authenticated === "true";
            }

            function isFavourite() {
                return favoriteButton.dataset.favourite === "true";
            }

            function updateFavouriteView(favourite) {
                favoriteButton.dataset.favourite = String(favourite);

                if (favourite) {
                    favoriteButton.classList.add("active");
                    favoriteText.textContent = "В избранном";
                } else {
                    favoriteButton.classList.remove("active");
                    favoriteText.textContent = "В избранное";
                }
            }

            async function readFavouriteState(response) {
                const contentType = response.headers.get("content-type");

                if (!contentType || !contentType.includes("application/json")) {
                    return !isFavourite();
                }

                const body = await response.json();

                if (typeof body.isFavourite === "boolean") {
                    return body.isFavourite;
                }

                if (typeof body.favourite === "boolean") {
                    return body.favourite;
                }

                if (typeof body.favorite === "boolean") {
                    return body.favorite;
                }

                return !isFavourite();
            }

            favoriteButton.addEventListener("click", async () => {
                if (!isAuthenticated()) {
                    showPageMessage("Чтобы добавить кейс в избранное, нужно войти в аккаунт.", "warning");
                    return;
                }

                favoriteButton.disabled = true;

                try {
                    const response = await fetch("/api/favorites/content/" + contentItemId, {
                        method: "POST",
                        headers: buildHeaders(false),
                        credentials: "same-origin"
                    });

                    if (response.status === 401 || (response.redirected && response.url.includes("/auth/login"))) {
                        showPageMessage("Чтобы добавить кейс в избранное, нужно войти в аккаунт.", "warning");
                        favoriteButton.disabled = false;
                        return;
                    }

                    if (response.status === 403) {
                        showPageMessage("Недостаточно прав для выполнения действия.", "error");
                        favoriteButton.disabled = false;
                        return;
                    }

                    if (!response.ok) {
                        const message = await extractErrorMessage(response);
                        showPageMessage(message || "Не удалось обновить избранное.", "error");
                        favoriteButton.disabled = false;
                        return;
                    }

                    const favourite = await readFavouriteState(response);

                    updateFavouriteView(favourite);

                    favoriteButton.disabled = false;
                } catch (e) {
                    console.error(e);
                    showPageMessage("Не удалось обновить избранное.", "error");
                    favoriteButton.disabled = false;
                }
            });
        }

        function initReactions() {
            if (!likeButton || !dislikeButton || !likesCount || !dislikesCount || !contentItemId) {
                return;
            }

            function setReactionButtonsDisabled(disabled) {
                likeButton.disabled = disabled;
                dislikeButton.disabled = disabled;
            }

            function updateReactionView(reaction) {
                likesCount.textContent = reaction.likesCount;
                dislikesCount.textContent = reaction.dislikesCount;

                likeButton.classList.remove("active-like");
                dislikeButton.classList.remove("active-dislike");

                if (reaction.currentReaction === "LIKE") {
                    likeButton.classList.add("active-like");
                }

                if (reaction.currentReaction === "DISLIKE") {
                    dislikeButton.classList.add("active-dislike");
                }
            }

            async function sendReaction(type) {
                const url = "/api/content-items/" + contentItemId + "/reactions/" + type;

                setReactionButtonsDisabled(true);

                try {
                    const response = await fetch(url, {
                        method: "POST",
                        headers: buildHeaders(false),
                        credentials: "same-origin"
                    });

                    if (response.status === 401 || (response.redirected && response.url.includes("/auth/login"))) {
                        showPageMessage("Для реакции необходимо войти в аккаунт.", "warning");
                        setReactionButtonsDisabled(false);
                        return;
                    }

                    if (response.status === 403) {
                        showPageMessage("Недостаточно прав для выполнения действия.", "error");
                        setReactionButtonsDisabled(false);
                        return;
                    }

                    if (!response.ok) {
                        showPageMessage("Не удалось обновить реакцию.", "error");
                        setReactionButtonsDisabled(false);
                        return;
                    }

                    const reaction = await response.json();

                    updateReactionView(reaction);
                    setReactionButtonsDisabled(false);
                } catch (e) {
                    console.error(e);
                    showPageMessage("Не удалось обновить реакцию.", "error");
                    setReactionButtonsDisabled(false);
                }
            }

            likeButton.addEventListener("click", () => {
                sendReaction("like");
            });

            dislikeButton.addEventListener("click", () => {
                sendReaction("dislike");
            });
        }

        function showAiMessage(message, type) {
            if (!aiMessage) {
                return;
            }

            aiMessage.textContent = message || "Произошла ошибка";
            aiMessage.className = "ai-message ai-message--" + type;
        }

        function clearAiMessage() {
            if (!aiMessage) {
                return;
            }

            aiMessage.textContent = "";
            aiMessage.className = "ai-message";
        }

        function setAiLoading(loading) {
            aiRequestInProgress = loading;

            if (aiSummaryButton) {
                aiSummaryButton.disabled = loading;
            }

            if (aiExplainButton) {
                aiExplainButton.disabled = loading;
            }

            if (loading) {
                showAiMessage("AI формирует ответ, подождите...", "warning");
            }
        }

        function isUnauthorizedResponse(response) {
            return response.status === 401
                || response.status === 403
                || (response.redirected && response.url.includes("/auth/login"));
        }

        async function readJsonResponse(response) {
            const contentType = response.headers.get("content-type");

            if (!contentType || !contentType.includes("application/json")) {
                throw new Error("Response is not json");
            }

            return await response.json();
        }

        function getSelectedTextInsideCase() {
            const selection = window.getSelection();

            if (!selection || selection.rangeCount === 0) {
                return "";
            }

            const selectedText = selection.toString().trim();

            if (!selectedText) {
                return "";
            }

            const range = selection.getRangeAt(0);
            let container = range.commonAncestorContainer;

            if (container.nodeType === Node.TEXT_NODE) {
                container = container.parentNode;
            }

            if (!caseAiContent || !caseAiContent.contains(container)) {
                return "";
            }

            const lockedSolution = container.closest
                ? container.closest(".case-solution:not(.case-solution--opened)")
                : null;

            if (lockedSolution) {
                return "";
            }

            return selectedText;
        }

        function updateSelectedTermView() {
            if (!aiSelectedTerm || !aiSelectedTermText) {
                return;
            }

            const selectedText = getSelectedTextInsideCase();

            if (!selectedText) {
                aiSelectedTerm.classList.remove("ai-selected-term--visible");
                aiSelectedTermText.textContent = "";
                return;
            }

            aiSelectedTermText.textContent = selectedText;
            aiSelectedTerm.classList.add("ai-selected-term--visible");
        }

        function showSummaryResult(content) {
            if (!aiSummaryResult || !aiSummaryResultContent) {
                return;
            }

            aiSummaryResultContent.textContent = content;
            aiSummaryResult.classList.add("content-ai-result--filled");
        }

        function showTermResult(title, content) {
            if (!aiTermResult || !aiTermResultTitle || !aiTermResultContent) {
                return;
            }

            aiTermResultTitle.textContent = title;
            aiTermResultContent.textContent = content;
            aiTermResult.classList.add("content-ai-result--filled");
        }

        async function sendAiSummaryRequest() {
            if (aiRequestInProgress || !contentItemId) {
                return;
            }

            clearAiMessage();
            setAiLoading(true);

            try {
                const response = await fetch("/api/content/" + contentItemId + "/ai/summary", {
                    method: "POST",
                    headers: buildHeaders(false),
                    credentials: "same-origin"
                });

                if (isUnauthorizedResponse(response)) {
                    showAiMessage("Для использования AI-функций необходимо войти в аккаунт.", "warning");
                    return;
                }

                if (!response.ok) {
                    const message = await extractErrorMessage(response);
                    showAiMessage(message || "Не удалось выполнить AI-запрос", "error");
                    return;
                }

                const body = await readJsonResponse(response);

                clearAiMessage();
                showSummaryResult(body.summary || "AI вернул пустой ответ");
            } catch (e) {
                console.error(e);
                showAiMessage("Не удалось получить краткое содержание кейса", "error");
            } finally {
                setAiLoading(false);
            }
        }

        async function sendAiExplainRequest() {
            if (aiRequestInProgress || !contentItemId) {
                return;
            }

            const selectedText = getSelectedTextInsideCase();

            if (!selectedText) {
                showAiMessage("Выделите термин в описании или открытом решении кейса.", "warning");
                return;
            }

            clearAiMessage();
            setAiLoading(true);

            try {
                const response = await fetch("/api/content/" + contentItemId + "/ai/explain", {
                    method: "POST",
                    headers: buildHeaders(true),
                    credentials: "same-origin",
                    body: JSON.stringify({
                        term: selectedText
                    })
                });

                if (isUnauthorizedResponse(response)) {
                    showAiMessage("Для использования AI-функций необходимо войти в аккаунт.", "warning");
                    return;
                }

                if (!response.ok) {
                    const message = await extractErrorMessage(response);
                    showAiMessage(message || "Не удалось выполнить AI-запрос", "error");
                    return;
                }

                const body = await readJsonResponse(response);

                clearAiMessage();
                showTermResult(
                    body.term || selectedText,
                    body.explanation || "AI вернул пустой ответ"
                );
            } catch (e) {
                console.error(e);
                showAiMessage("Не удалось получить объяснение термина", "error");
            } finally {
                setAiLoading(false);
            }
        }

        initSolutionToggle();
        initFavourite();
        initReactions();

        document.addEventListener("selectionchange", updateSelectedTermView);

        if (aiSummaryButton) {
            aiSummaryButton.addEventListener("click", sendAiSummaryRequest);
        }

        if (aiExplainButton) {
            aiExplainButton.addEventListener("click", sendAiExplainRequest);
        }
    });
})();