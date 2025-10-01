<script lang="ts">
    import { Tabs } from "$types/enums";
    import DropDown from "./input/DropDown.svelte";

    let {
        activeTab = $bindable(Tabs.HOME),
        isSticky = true,
    } = $props();
    
    let tabs = Object.values(Tabs);
</script>

<nav style={isSticky ? "position: sticky; top: 0; z-index: 1000;" : ""}>
        <DropDown
            value={activeTab}
            options={tabs.map(tab => ({ value: tab, label: tab }))}
            onChange={(value) => activeTab = value as Tabs}
            style="padding: 8px;"
        />
</nav>

<style>
    nav {
        width: 100%;
        background: var(--background2-color);
        padding: 8px;
        border-bottom: 2px solid var(--primary-color);
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
    }
</style>
