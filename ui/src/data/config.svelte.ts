import type { CustomWindow } from "$types/type";

interface Theme {
    primary: string;
    secondary: string;
    color1: string;
    color2: string;
    color3: string;
    color4: string;
    background: string;
    background2: string;
    text: string;
    text2: string;
}

export const themes: Record<string, Theme> = {
    dark: {
        primary: "#89b4fa",
        secondary: "#cba6f7",
        color1: "#f5c2e7",
        color2: "#a6e3a1",
        color3: "#fab387",
        color4: "#f38ba8",
        background: "#1e1e2e",
        background2: "#313244",
        text: "#cdd6f4",
        text2: "#a6adc8",
    },
    light: {
        primary: "#7287fd",
        secondary: "#8839ef",
        color1: "#ea76cb",
        color2: "#40a02b",
        color3: "#fe640b",
        color4: "#d20f39",
        background: "#eff1f5",
        background2: "#ccd0da",
        text: "#4c4f69",
        text2: "#6c6f85",
    },
}

function setTheme(theme: Theme) {
    document.documentElement.style.setProperty("--primary-color", theme.primary);
    document.documentElement.style.setProperty("--secondary-color", theme.secondary);
    document.documentElement.style.setProperty("--color1", theme.color1);
    document.documentElement.style.setProperty("--color2", theme.color2);
    document.documentElement.style.setProperty("--color3", theme.color3);
    document.documentElement.style.setProperty("--color4", theme.color4);
    document.documentElement.style.setProperty("--background-color", theme.background);
    document.documentElement.style.setProperty("--text-color", theme.text);
    document.documentElement.style.setProperty("--text2-color", theme.text2);
    document.documentElement.style.setProperty("--background2-color", theme.background2);
    document.documentElement.style.setProperty("--primary-color-transparent", `${theme.primary}33`);
    document.documentElement.style.setProperty("--background-color-transparent", `${theme.background}dd`);
}

export declare let window: CustomWindow;

class Config {
    IS_BROWSER = !window.invokeNative;
    RESOURCE_NAME = window.GetParentResourceName ? window.GetParentResourceName() : "svelte_template";
    ESC_TO_EXIT = true;
    
    theme: string = $state(localStorage.getItem("theme") || "dark");
    
    constructor() {
        this.setTheme(this.theme);
    }
    
    setTheme(theme: string) {
        const selectedTheme = themes[theme];
        if (!selectedTheme) return;
        setTheme(selectedTheme);
        this.theme = theme;
        localStorage.setItem("theme", theme);
    }
}

export const CONFIG = new Config();
