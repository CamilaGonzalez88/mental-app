/**
 * ==========================================================
 * AbrazaMente
 * Theme Manager
 * ==========================================================
 */

class ThemeManager {

    constructor() {

        this.html = document.documentElement;

        this.button = document.getElementById("theme-toggle");

        this.storageKey = "theme";

        this.defaultTheme = "light";

    }

    /**
     * Inicializa el gestor de tema
     */
    init() {

        if (!this.button) {

            console.warn("Theme Toggle no encontrado.");

            return;

        }

        this.loadTheme();

        this.button.addEventListener(
            "click",
            () => this.toggleTheme()
        );

    }

    /**
     * Obtiene el tema almacenado
     */
    getSavedTheme() {

        return localStorage.getItem(this.storageKey);

    }

    /**
     * Guarda el tema
     */
    saveTheme(theme) {

        localStorage.setItem(
            this.storageKey,
            theme
        );

    }

    /**
     * Detecta el tema del sistema
     */
    getSystemTheme() {

        return window.matchMedia(
            "(prefers-color-scheme: dark)"
        ).matches
            ? "dark"
            : "light";

    }

    /**
     * Aplica el tema al documento
     */
    applyTheme(theme) {

        this.html.setAttribute(
            "data-theme",
            theme
        );

    }

    /**
     * Carga el tema
     */
    loadTheme() {

        const theme =
            this.getSavedTheme()
            ??
            this.getSystemTheme()
            ??
            this.defaultTheme;

        this.applyTheme(theme);

    }

    /**
     * Cambia el tema
     */
    toggleTheme() {

        const current =
            this.html.getAttribute("data-theme");

        const next =
            current === "dark"
                ? "light"
                : "dark";

        this.applyTheme(next);

        this.saveTheme(next);

    }

}

/* ==========================================================
   INIT
========================================================== */

document.addEventListener(
    "DOMContentLoaded",
    () => {

        const theme = new ThemeManager();

        theme.init();

    }
);