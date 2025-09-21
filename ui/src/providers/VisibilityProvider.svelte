<script lang="ts">
    import { onMount } from "svelte";
    import { ReceiveNUI, SendNUI } from "$utils/eventsHandlers";
    import { CONFIG } from "$data/config.svelte";
    import { providers } from "$data/providers.svelte";
    
    interface Props {
        children?: import("svelte").Snippet;
    }

    const { children }: Props = $props();

    ReceiveNUI<boolean>("enableUI", (visible) => {
        console.log("enableUI", visible);
        providers.isVisible = visible || !providers.isVisible;
    });

    onMount(() => {
        if (!CONFIG.ESC_TO_EXIT) return;

        const keyHandler = (e: KeyboardEvent) => {
            if (providers.isVisible && ["Escape"].includes(e.code)) {
                if (providers.cameraActive) {
                    return;
                }
                SendNUI("closeUI");
                providers.isVisible = false;
            }
        };

        window.addEventListener("keydown", keyHandler);

        return () => window.removeEventListener("keydown", keyHandler);
    });
</script>

<main>
    {#if providers.isVisible}
        {@render children?.()}
    {/if}
</main>
