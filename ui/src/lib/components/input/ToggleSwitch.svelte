<script lang="ts">
    interface Props {
        checked?: boolean;
        label?: string;
        disabled?: boolean;
        onChange?: (isChecked: boolean) => void;
    }
    
    let {
        checked = $bindable(false),
        label = "",
        disabled = false,
        onChange = () => {},
    }: Props = $props();
    
</script>

<label class="toggle">
    <input
        type="checkbox"
        bind:checked
        onchange={(_) => onChange(checked)}
        {disabled}
    />
    <span class="slider"></span>
    {#if label}
        <span class="label">{label}</span>
    {/if}
</label>

<style>
    .toggle {
        position: relative;
        display: inline-flex;
        align-items: center;
        gap: 0.5rem;
        cursor: pointer;
    }

    input {
        opacity: 0;
        width: 0;
        height: 0;
    }

    .slider {
        position: relative;
        display: inline-block;
        width: 48px;
        height: 24px;
        background-color: var(--background2-color);
        border-radius: 24px;
        transition: all 0.2s ease;
    }

    .slider::before {
        content: "";
        position: absolute;
        width: 20px;
        height: 20px;
        left: 2px;
        bottom: 2px;
        background-color: var(--text-color);
        border-radius: 50%;
        transition: all 0.2s ease;
    }

    input:checked + .slider {
        background-color: var(--primary-color);
    }

    input:checked + .slider::before {
        transform: translateX(24px);
        background-color: var(--background-color);
    }

    .label {
        color: var(--text-color);
        font-size: 1rem;
    }
</style>
