<script lang="ts">
    import Navigation from "$lib/components/Navigation.svelte";
    import { Tabs } from "$types/enums";
    import Settings from "$components/Settings.svelte";
    import EntityChecker from "$components/EntityChecker.svelte";
    import ItemsTab from "$components/ItemsTab.svelte";
    import Furniture from "$components/tabs/furniture/Furniture.svelte";
    import Vehicles from "$components/tabs/vehicles/Vehicles.svelte";
    import { providers } from "$data/providers.svelte";

    let activeTab = $state(Tabs.HOME);
    
    $effect(() => {
        if (allowedTabs.length > 0 && !allowedTabs.includes(activeTab)) {
            activeTab = allowedTabs[0];
        }
    });
    
    const tabComponents: Record<Tabs, any> = {
        [Tabs.HOME]: null,
        [Tabs.ITEMS]: ItemsTab,
        [Tabs.FURNITURE]: Furniture,
        [Tabs.ENTITY]: EntityChecker,
        [Tabs.SETTINGS]: Settings,
        [Tabs.VEHICLES]: Vehicles,
    };
    
    let allowedTabs = $derived.by(() => {
        if (providers.tab === "all") {
            return Object.values(Tabs);
        }
        
        const matchingTab = Object.values(Tabs).find(
            tab => tab.toLowerCase() === providers.tab.toLowerCase()
        );
        
        
        return matchingTab ? [matchingTab] : [];
    });
    
    const isTabAllowed = $derived(
        allowedTabs.includes(activeTab)
    );
</script>

<div id="side-panel-container">
    <Navigation bind:activeTab bind:tabs={allowedTabs}/>
    <div id="display-content">
        <div class="content-wrapper">
            {#if isTabAllowed}
                {#if activeTab === Tabs.HOME}
                    <div>Home Content</div>
                {:else}
                    {@const Component = tabComponents[activeTab]}
                    {#if Component}
                        <Component />
                    {/if}
                {/if}
            {/if}
        </div>
    </div>
</div>

<style>
    #side-panel-container {
        position: fixed;
        left: 0;
        display: flex;
        flex-direction: column;
        height: 90%;
        width: 25%;
        background-color: var(--background-color);
        border: 1px solid var(--background2-color);
        border-radius: 0 0.5rem 0.5rem 0;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.2);
        overflow: hidden;
    }

    #display-content {
        flex: 1;
        padding: 8px;
        color: var(--text-color);
        background-color: var(--background-color);
        overflow-y: scroll;
    }
    
    .content-wrapper {
        background: var(--background2-color);
        border-radius: 0.5rem;
        border: 1px solid var(--background2-color);
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        display: flex;
        flex-direction: column;
    }
</style>
