<script lang="ts">
    import Draggable from "$components/Draggable.svelte";

    interface Props {
        onClose?: () => void;
        show?: boolean;
        width?: string;
        aspect_ratio?: string;
        header?: string;
        draggable?: boolean;
        children?: import("svelte").Snippet;
    }

    let { onClose = () => {}, show = $bindable(false), width = "60%", aspect_ratio = "16/9", header = "", draggable = true, children }: Props = $props();

    function handle_close() {
        show = false;
        onClose();
    }
</script>

{#if show}
    <Draggable canDrag={draggable} savePosition={false} {width} {aspect_ratio} startCentered={true}>
        <div id="popup-container">
            <div id="popup-header" class="drag-handle">
                <h3>{header}</h3>
                <button id="popup-close" onclick={() => handle_close()}>×</button>
            </div>

            <div id="popup-content">
                {@render children?.()}
            </div>
        </div>
    </Draggable>
{/if}

<style>
    #popup-container {
        display: flex;
        width: 100%;
        height: 100%;
        flex-direction: column;
        position: relative;
        border: 2px solid var(--primary-color);
        border-radius: 1rem;
        overflow: hidden;
        z-index: 9999;
        box-shadow: 0 8px 32px rgba(0, 0, 0, 0.4);
    }

    #popup-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        position: relative;
        width: 100%;
        padding: 20px;
        background-color: var(--background2-color);
        border-bottom: 1px solid var(--primary-color-transparent);
    }

    #popup-header h3 {
        margin: 0;
        font-size: 1.3rem;
        color: var(--color2);
    }

    #popup-close {
        background: none;
        border: none;
        font-size: 2rem;
        color: var(--text-color);
        cursor: pointer;
        line-height: 1;
        padding: 0;
        width: 32px;
        height: 32px;
        display: flex;
        align-items: center;
        justify-content: center;
        border-radius: 0.3rem;
        transition: all 0.2s ease;
    }

    #popup-close:hover {
        background: var(--background-color);
        color: var(--secondary-color);
    }

    #popup-content {
        flex: 1;
        width: 100%;
        padding: 16px;
        background-color: var(--background-color);
        overflow: auto;
    }
</style>
