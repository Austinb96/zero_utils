<script lang="ts">
    import Navigation from "$lib/components/Navigation.svelte";
    import { Tabs } from "$types/enums";
    import Settings from "$components/Settings.svelte";
    import EntityChecker from "$components/EntityChecker.svelte";

    let activeTab = $state(Tabs.HOME);
</script>

<div id="side-panel-container">
    <Navigation bind:activeTab/>
    <div id="display-content">
        <div class="content-wrapper">
            {#if activeTab === Tabs.HOME}
                <div>Home Content</div>
            {/if}
            {#if activeTab === Tabs.ENTITY}
                <EntityChecker/>
            {/if}
            {#if activeTab === Tabs.SETTINGS}
                <Settings/>
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
