(() => {
    document.addEventListener("DOMContentLoaded", () => {
        const registerForm = document.getElementById("registerForm");
        const passwordInput = document.getElementById("password");
        const confirmPasswordInput = document.getElementById("confirmPassword");
        const confirmPasswordClientError = document.getElementById("confirmPasswordClientError");

        function validatePasswordMatch() {
            if (!passwordInput || !confirmPasswordInput || !confirmPasswordClientError) {
                return true;
            }

            const password = passwordInput.value;
            const confirmPassword = confirmPasswordInput.value;
            const isInvalid = confirmPassword.length > 0 && password !== confirmPassword;

            confirmPasswordClientError.hidden = !isInvalid;
            confirmPasswordInput.classList.toggle("is-invalid", isInvalid);

            return !isInvalid;
        }

        if (passwordInput) {
            passwordInput.addEventListener("input", validatePasswordMatch);
        }

        if (confirmPasswordInput) {
            confirmPasswordInput.addEventListener("input", validatePasswordMatch);
        }

        if (registerForm) {
            registerForm.addEventListener("submit", (event) => {
                if (!validatePasswordMatch()) {
                    event.preventDefault();
                    confirmPasswordInput.focus();
                }
            });
        }

        document.querySelectorAll("[data-password-toggle-for]").forEach((button) => {
            button.addEventListener("click", () => {
                const inputId = button.dataset.passwordToggleFor;
                const input = document.getElementById(inputId);

                if (!input) {
                    return;
                }

                const passwordVisible = input.type === "text";

                input.type = passwordVisible ? "password" : "text";
                button.classList.toggle("auth-login-password-toggle--active", !passwordVisible);
                button.setAttribute(
                    "aria-label",
                    passwordVisible ? "Показать пароль" : "Скрыть пароль"
                );
            });
        });
    });
})();