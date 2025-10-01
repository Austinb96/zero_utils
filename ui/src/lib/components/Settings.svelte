<script lang="ts">
    import { CONFIG, themes } from "$data/config.svelte";
    import DropDown from "./input/DropDown.svelte";
</script>

<div class="settings-container">
    <div class="setting-row">
        <span class="setting-label">Theme</span>
        <DropDown
            value={CONFIG.theme}
            options={
                Object.keys(themes).map((theme) => ({
                    value: theme,
                    label: theme.charAt(0).toUpperCase() + theme.slice(1),
                }))
            }
            onChange={(value) => CONFIG.setTheme(value)}
            style="width: 80%;"
        />
    </div>
</div>

<style>
    .settings-container {
        background-color: var(--background-color);
        border-radius: 8px;
        border: 1px solid var(--background2-color);
        box-shadow: 0 2px 4px -1px rgba(0, 0, 0, 0.1);
    }

    .setting-row {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 8px;
        background-color: var(--background2-color);
        border-radius: 6px;
    }

    .setting-label {
        color: var(--text-color);
        font-size: 0.875rem;
        font-weight: 500;
    }
</style>
