/* ==========================================================================
   PLATTER MODAL SYSTEM — JavaScript
   Handles: open, close, outside-click, tab-switch, form validation
   ========================================================================== */

(function() {
    "use strict";

    /* ------------------------------------------------------------------ */
    /*  Overlay & Card references                                           */
    /* ------------------------------------------------------------------ */
    const loginOverlay = document.getElementById("login-modal");
    const signupOverlay = document.getElementById("signup-modal");

    if (!loginOverlay || !signupOverlay) return;   // not on landing page

    /* ------------------------------------------------------------------ */
    /*  Open / Close helpers                                                */
    /* ------------------------------------------------------------------ */

    function openModal(overlay) {
        overlay.classList.add("modal-active");
        document.body.style.overflow = "hidden";
        // Focus first input after animation
        setTimeout(() => {
            const firstInput = overlay.querySelector("input");
            if (firstInput) firstInput.focus();
        }, 420);
    }

    function closeModal(overlay) {
        overlay.classList.remove("modal-active");
        document.body.style.overflow = "";
    }

    function closeAll() {
        closeModal(loginOverlay);
        closeModal(signupOverlay);
    }

    /* ------------------------------------------------------------------ */
    /*  Trigger buttons (navbar + mobile menu)                             */
    /* ------------------------------------------------------------------ */

    document.querySelectorAll("[data-modal='login']").forEach(btn => {
        btn.addEventListener("click", e => {
            e.preventDefault();
            closeModal(signupOverlay);
            openModal(loginOverlay);
        });
    });

    document.querySelectorAll("[data-modal='signup']").forEach(btn => {
        btn.addEventListener("click", e => {
            e.preventDefault();
            closeModal(loginOverlay);
            openModal(signupOverlay);
        });
    });

    /* ------------------------------------------------------------------ */
    /*  Close buttons (× inside card)                                      */
    /* ------------------------------------------------------------------ */

    loginOverlay.querySelector(".modal-close-btn")
        .addEventListener("click", () => closeModal(loginOverlay));

    signupOverlay.querySelector(".modal-close-btn")
        .addEventListener("click", () => closeModal(signupOverlay));

    /* ------------------------------------------------------------------ */
    /*  Click OUTSIDE the card → close                                     */
    /* ------------------------------------------------------------------ */

    [loginOverlay, signupOverlay].forEach(overlay => {
        overlay.addEventListener("click", e => {
            if (e.target === overlay) closeModal(overlay);
        });
    });

    /* ------------------------------------------------------------------ */
    /*  Escape key → close                                                  */
    /* ------------------------------------------------------------------ */

    document.addEventListener("keydown", e => {
        if (e.key === "Escape") closeAll();
    });

    /* ------------------------------------------------------------------ */
    /*  Switch links (Login ↔ Signup inside modals)                        */
    /* ------------------------------------------------------------------ */

    document.getElementById("switch-to-signup")
        .addEventListener("click", e => {
            e.preventDefault();
            closeModal(loginOverlay);
            openModal(signupOverlay);
        });

    document.getElementById("switch-to-login")
        .addEventListener("click", e => {
            e.preventDefault();
            closeModal(signupOverlay);
            openModal(loginOverlay);
        });

    /* ================================================================== */
    /*  LOGIN FORM LOGIC                                                    */
    /* ================================================================== */

    const loginForm = document.getElementById("modal-login-form");
    const loginEmail = document.getElementById("modal-login-email");
    const loginPassword = document.getElementById("modal-login-password");
    const loginToggleBtn = document.getElementById("modal-login-toggle-pwd");
    const loginAlertBox = document.getElementById("modal-login-alert");

    // Toggle password visibility
    if (loginToggleBtn && loginPassword) {
        loginToggleBtn.addEventListener("click", () => {
            const isHidden = loginPassword.type === "password";
            loginPassword.type = isHidden ? "text" : "password";
            const icon = loginToggleBtn.querySelector("i");
            if (icon) {
                icon.classList.toggle("fa-eye", !isHidden);
                icon.classList.toggle("fa-eye-slash", isHidden);
            }
        });
    }

    function showLoginAlert(msg, type = "error") {
        if (!loginAlertBox) return;
        loginAlertBox.textContent = msg;
        loginAlertBox.className = `modal-alert-box ${type}`;
        loginAlertBox.classList.remove("modal-hidden");
    }

    function hideLoginAlert() {
        if (!loginAlertBox) return;
        loginAlertBox.classList.add("modal-hidden");
        loginAlertBox.textContent = "";
    }
    if (loginEmail) {

        loginEmail.addEventListener(
            "input",

            hideLoginAlert
        );

    }

    if (loginPassword) {

        loginPassword.addEventListener(
            "input",

            hideLoginAlert
        );

    }

    function isValidEmail(email) {
        return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
    }

    if (loginForm) {

        loginForm.addEventListener(

            "submit",

            e => {

                hideLoginAlert();

                const email =

                    loginEmail.value.trim();

                const pwd =

                    loginPassword.value;

                if (!email) {

                    e.preventDefault();

                    showLoginAlert(

                        "Please enter your email address."

                    );

                    loginEmail.focus();

                    return;

                }

                if (!isValidEmail(email)) {

                    e.preventDefault();

                    showLoginAlert(

                        "Please enter a valid email address."

                    );

                    loginEmail.focus();

                    return;

                }

                if (!pwd) {

                    e.preventDefault();

                    showLoginAlert(

                        "Please enter your password."

                    );

                    loginPassword.focus();

                    return;

                }

                if (pwd.length < 6) {

                    e.preventDefault();

                    showLoginAlert(

                        "Password must be at least 6 characters long."

                    );

                    loginPassword.focus();

                    return;

                }

            });

    }

    // Google login
    const loginGoogleBtn = loginForm ? loginForm.querySelector(".modal-google-btn") : null;
    if (loginGoogleBtn) {
        loginGoogleBtn
            .addEventListener(

                "click",

                () => {

                    showLoginAlert(

                        "Google Login Coming Soon",

                        "error"

                    );

                });
    }

    /* ================================================================== */
    /*  SIGNUP FORM LOGIC  (Simple: name + email + terms)                  */
    /* ================================================================== */

    const signupForm = document.getElementById("modal-signup-form");
    const signupName = document.getElementById("modal-signup-name");
    const signupEmail = document.getElementById("modal-signup-email");
    const signupPassword = document.getElementById("modal-signup-password");
    const signupToggleBtn = document.getElementById("modal-signup-toggle-pwd");
    const signupAlertBox = document.getElementById("modal-signup-alert");
    const signupTermsChk = document.getElementById("modal-agree-terms");
    const signupCreateBtn = document.getElementById("signup-create-btn");

    // Toggle signup password visibility
    if (signupToggleBtn && signupPassword) {
        signupToggleBtn.addEventListener("click", () => {
            const isHidden = signupPassword.type === "password";
            signupPassword.type = isHidden ? "text" : "password";
            const icon = signupToggleBtn.querySelector("i");
            if (icon) {
                icon.classList.toggle("fa-eye", !isHidden);
                icon.classList.toggle("fa-eye-slash", isHidden);
            }
        });
    }

    // Enable/disable "Create account" button based on terms checkbox
    if (signupTermsChk && signupCreateBtn) {
        signupTermsChk.addEventListener("change", () => {
            signupCreateBtn.disabled = !signupTermsChk.checked;
        });
    }



    function hideSignupAlert() {
        if (!signupAlertBox) return;
        signupAlertBox.classList.add("modal-hidden");
        signupAlertBox.textContent = "";
    }

    if (signupForm) {

        signupForm.addEventListener(

            "submit",

            e => {

                hideSignupAlert();

                const name =

                    signupName.value.trim();

                const email =

                    signupEmail.value.trim();

                if (!name) {

                    showSignupAlert(

                        "Enter name"

                    );

                    e.preventDefault();

                    return;

                }

                if (name.length < 2) {

                    showSignupAlert(

                        "Name too short"

                    );

                    e.preventDefault();

                    return;

                }

                if (!email) {

                    showSignupAlert(

                        "Enter email"

                    );

                    e.preventDefault();

                    return;

                }

                if (!isValidEmail(email)) {

                    showSignupAlert(

                        "Invalid email"

                    );

                    e.preventDefault();

                    return;

                }

            });
    }

    // Google signup
    const signupGoogleBtn = signupForm ? signupForm.querySelector(".signup-google-btn") : null;
    if (signupGoogleBtn) {
        signupGoogleBtn.addEventListener("click", () => {
            showSignupAlert("Registering with Google…", "success");
            setTimeout(() => { window.location.href = "home.html"; }, 1200);
        });
    }

    /* ==========================================
       URL PARAMETER HANDLING
    ========================================== */

    const params = new URLSearchParams(
        window.location.search
    );

    // Wrong login credentials

    if (params.get("error") === "invalid") {

        openModal(loginOverlay);

        showLoginAlert(

            "Invalid email or password."

        );

        window.history.replaceState(

            {},

            document.title,

            window.location.pathname

        );

    }

    // Home clicked without login
    if (params.get("showLogin") === "true") {

        openModal(loginOverlay);

        window.history.replaceState(

            {},

            document.title,

            window.location.pathname

        );

    }

})();
