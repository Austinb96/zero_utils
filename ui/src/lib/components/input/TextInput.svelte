<script lang="ts">
    interface Props {
        placeholder?: string;
        value?: string;
        disableEdit?: boolean;
        header?: string;
        color?: string;
        debounceMs?: number;
        onValueChange?: (value: string) => void;
        class?: string;
    }
    
    let {
        placeholder = "",
        value = $bindable(""),
        disableEdit = false,
        header = "",
        color = "",
        debounceMs = 0,
        onValueChange,
        class: className = "",
        ...restProps
    }: Props = $props();

    let debounceTimeout: number;
    let internalValue = $state(value);

    function handleInput(event: Event) {
        const target = event.target as HTMLInputElement;
        internalValue = target.value;
        
        if (debounceMs === 0) {
            value = target.value; 
            onValueChange?.(target.value);
            return;
        }
        
        clearTimeout(debounceTimeout);
        debounceTimeout = setTimeout(() => {
            value = target.value;
            onValueChange?.(target.value);
        }, debounceMs);
    }
</script>

<div id="text-input-container" class={className}>
    {#if header}
        <h5 id="header">{header}</h5>
    {/if}
    <input 
        class="text-input"
        value={internalValue} 
        {placeholder} 
        disabled={disableEdit} 
        style={color ? `color: ${color};` : ""}
        oninput={handleInput}
        {...restProps}
    />
</div>

<style>
    #text-input-container {
        display: flex;
        flex-direction: column;
        align-items: start;
        width: 100%;
        gap: 4px;
    }
    
    #header {
        font-size: 0.7rem;
        margin: 0;
    }

    .text-input {
        flex: 1;
        width: 100%;
        padding: 10px 16px;
        border: 1px solid var(--primary-color);
        border-radius: 0.5rem;
        background: var(--background-color);
        color: var(--text-color);
        font-size: 0.95rem;
        transition: all 0.2s ease;
    }

    .text-input:focus {
        outline: none;
        border-color: var(--secondary-color);
        box-shadow: 0 0 0 2px var(--primary-color-transparent);
    }

    .text-input:disabled {
        opacity: 0.6;
        cursor: not-allowed;
    }
</style>
