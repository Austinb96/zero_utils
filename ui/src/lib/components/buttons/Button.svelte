<script lang="ts">
    import type { Snippet } from "svelte";

    interface Props {
        fullWidth?: boolean;
        disabled?: boolean;
        selected?: boolean;
        onClick?: () => void;
        children: Snippet;
    }
    
    const {
        children,
        fullWidth = false,
        disabled = false,
        selected = false,
        onClick = () => {},
    }: Props = $props();
</script>

<button
    class={`btn ${fullWidth ? 'full-width' : ''} ${selected ? 'selected' : ''}`}
    onclick={onClick}
    {disabled}
>
    {@render children()}
</button>

<style>
    .btn {
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
        min-width: 100px;
        padding: 10px 16px;
        background-color: var(--background2-color);
        color: var(--text-color);
        font-size: 0.9rem;
        font-weight: 500;
        border: 1px solid var(--primary-color);
        border-radius: 6px;
        cursor: pointer;
        transition: all 0.2s ease;
    }

    .full-width {
        width: 100%;
    }

    .btn:hover {
        background-color: var(--primary-color);
        color: var(--background-color);
        opacity: 1;
    }

    .btn:active {
        transform: scale(0.98);
    }

    .btn:disabled {
        opacity: 0.5;
        cursor: not-allowed;
        border-color: var(--text2-color);
        background-color: var(--background2-color);
    }
    
    .selected {
        background-color: var(--primary-color);
        color: var(--background-color);
        border-color: var(--primary-color);
    }
</style>
