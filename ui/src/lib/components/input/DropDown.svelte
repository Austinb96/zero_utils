<script lang="ts">
    interface Props {
        value: string;
        options: { value: string; label: string }[];
        label?: string;
        width?: string;
        style?: string;
        onChange?: (value: string) => void;
    }
    
    let {
        value = $bindable(""),
        options = [],
        label = "",
        width = "100%",
        style = "",
        onChange = () => {},
    }: Props = $props();

    function handleChange(event: Event) {
        const target = event.target as HTMLSelectElement;
        value = target.value;
        onChange(target.value);
    }
</script>

<div class="dropdown-container" style={style}>
    {#if label}
        <label class="dropdown-label" for="dropdown">{label}</label>
    {/if}
    <select id="dropdown" {value} onchange={handleChange} class="dropdown" style="width: {width}">
        {#each options as option}
            <option value={option.value}>{option.label}</option>
        {/each}
    </select>
</div>

<style>
    .dropdown-container {
        display: flex;
        flex-direction: column;
        gap: 0.5rem;
    }

    .dropdown-label {
        color: var(--text-color);
        font-size: 0.875rem;
        font-weight: 500;
    }

    .dropdown {
        background-color: var(--background-color);
        color: var(--text-color);
        border: 1px solid var(--background2-color);
        border-radius: 6px;
        padding: 0.75rem 1rem; 
        font-size: 1rem;      
        min-width: 200px;
        cursor: pointer;
        transition: all 0.2s ease;
    }

    .dropdown:hover {
        border-color: var(--primary-color);
    }

    .dropdown:focus {
        outline: none;
        border-color: var(--primary-color);
        box-shadow: 0 0 0 2px var(--primary-color-transparent);
    }

    .dropdown option {
        background-color: var(--background-color);
        color: var(--text-color);
        padding: 0.75rem;       /* Match dropdown padding */
        font-size: 1rem;        /* Match dropdown font size */
    }
</style>
