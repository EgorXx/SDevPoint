(() => {
    document.addEventListener("DOMContentLoaded", () => {
        const passwordInput = document.getElementById("password");
        const passwordToggle = document.getElementById("passwordToggle");

        if (!passwordInput || !passwordToggle) {
            return;
        }

        passwordToggle.addEventListener("click", () => {
            const passwordVisible = passwordInput.type === "text";

            passwordInput.type = passwordVisible ? "password" : "text";
            passwordToggle.classList.toggle("auth-login-password-toggle--active", !passwordVisible);
            passwordToggle.setAttribute(
                "aria-label",
                passwordVisible ? "Показать пароль" : "Скрыть пароль"
            );
        });
    });
})();