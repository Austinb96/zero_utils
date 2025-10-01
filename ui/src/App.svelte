<script lang="ts">
    import { CONFIG } from "$data/config.svelte";
    import SidePanel from "$lib/SidePanel.svelte";
    import VisibilityProvider from "$providers/VisibilityProvider.svelte";
    import { InitializeDebugSenders } from "$_browser/senders";
    import { InitializeDebugReceivers } from "$_browser/receivers";

    if (CONFIG.IS_BROWSER) {
        InitializeDebugReceivers();
        InitializeDebugSenders();
    }
</script>

<VisibilityProvider>
    <SidePanel />
</VisibilityProvider>
