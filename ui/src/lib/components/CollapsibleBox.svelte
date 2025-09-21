<script lang="ts">
    import type { Snippet } from 'svelte';
    
    interface Props {
        title: string;
        isOpen?: boolean;
        variant?: 'default' | 'primary' | 'success' | 'warning' | 'danger';
        size?: 'sm' | 'md' | 'lg';
        showCount?: number;
        children: Snippet;
        headerContent?: Snippet;
    }
    
    let { 
        title, 
        isOpen = true, 
        variant = 'default',
        size = 'md',
        showCount,
        children,
        headerContent
    }: Props = $props();
    
    let collapsed = $state(!isOpen);
    
    function toggle() {
        collapsed = !collapsed;
    }
    
    const variantClasses = {
        default: 'collapsible-default',
        primary: 'collapsible-primary', 
        success: 'collapsible-success',
        warning: 'collapsible-warning',
        danger: 'collapsible-danger'
    };
    
    const sizeClasses = {
        sm: 'collapsible-sm',
        md: 'collapsible-md', 
        lg: 'collapsible-lg'
    };
</script>

<div class="collapsible-box {variantClasses[variant]} {sizeClasses[size]}">
    <button class="collapsible-header" onclick={toggle} type="button">
        <div class="header-left">
            <span class="collapse-icon" class:collapsed>
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <polyline points="6,9 12,15 18,9"></polyline>
                </svg>
            </span>
            <span class="title">{title}</span>
            {#if showCount !== undefined}
                <span class="count-badge">{showCount}</span>
            {/if}
        </div>
        
        <div class="header-right">
            {#if headerContent}
                {@render headerContent()}
            {/if}
        </div>
    </button>
    
    <div class="collapsible-content" class:collapsed>
        <div class="content-inner">
            {@render children()}
        </div>
    </div>
</div>

<style>
    .collapsible-box {
        border-radius: 0.75rem;
        border: 1px solid var(--primary-color-transparent);
        background: var(--background2-color);
        overflow: hidden;
        transition: all 0.2s ease;
    }
    
    .collapsible-header {
        width: 100%;
        display: flex;
        justify-content: space-between;
        align-items: center;
        background: none;
        border: none;
        color: inherit;
        cursor: pointer;
        transition: all 0.2s ease;
    }
    
    .collapsible-header:hover {
        background: var(--primary-color-transparent);
    }
    
    .header-left {
        display: flex;
        align-items: center;
        gap: 12px;
        flex: 1;
    }
    
    .header-right {
        display: flex;
        align-items: center;
        gap: 8px;
    }
    
    .collapse-icon {
        display: flex;
        align-items: center;
        transition: transform 0.2s ease;
        color: var(--primary-color);
    }
    
    .collapse-icon.collapsed {
        transform: rotate(-90deg);
    }
    
    .title {
        font-weight: 700;
        color: var(--primary-color);
    }
    
    .count-badge {
        padding: 4px 8px;
        border-radius: 0.25rem;
        font-size: 0.75rem;
        font-weight: 600;
        background: var(--primary-color);
        color: var(--background-color);
    }
    
    .collapsible-content {
        overflow: hidden;
        transition: all 0.3s ease;
        max-height: 2000px;
        opacity: 1;
    }
    
    .collapsible-content.collapsed {
        max-height: 0;
        opacity: 0;
    }
    
    .content-inner {
        transition: all 0.2s ease;
    }
    
    /* Size variants */
    .collapsible-sm .collapsible-header {
        padding: 8px 12px;
    }
    
    .collapsible-sm .title {
        font-size: 0.9rem;
    }
    
    .collapsible-sm .content-inner {
        padding: 8px 12px;
    }
    
    .collapsible-md .collapsible-header {
        padding: 12px 16px;
    }
    
    .collapsible-md .title {
        font-size: 1rem;
    }
    
    .collapsible-md .content-inner {
        padding: 12px 16px;
    }
    
    .collapsible-lg .collapsible-header {
        padding: 16px 20px;
    }
    
    .collapsible-lg .title {
        font-size: 1.1rem;
    }
    
    .collapsible-lg .content-inner {
        padding: 16px 20px;
    }
    
    /* Color variants */
    .collapsible-primary {
        border-color: var(--primary-color);
    }
    
    .collapsible-primary .title,
    .collapsible-primary .collapse-icon {
        color: var(--primary-color);
    }
    
    .collapsible-primary .count-badge {
        background: var(--primary-color);
    }
    
    .collapsible-success {
        border-color: var(--color2);
    }
    
    .collapsible-success .title,
    .collapsible-success .collapse-icon {
        color: var(--color2);
    }
    
    .collapsible-success .count-badge {
        background: var(--color2);
    }
    
    .collapsible-warning {
        border-color: var(--color3);
    }
    
    .collapsible-warning .title,
    .collapsible-warning .collapse-icon {
        color: var(--color3);
    }
    
    .collapsible-warning .count-badge {
        background: var(--color3);
    }
    
    .collapsible-danger {
        border-color: var(--color4);
    }
    
    .collapsible-danger .title,
    .collapsible-danger .collapse-icon {
        color: var(--color4);
    }
    
    .collapsible-danger .count-badge {
        background: var(--color4);
    }
    
    .collapsible-default .title,
    .collapsible-default .collapse-icon {
        color: var(--primary-color);
    }
    
    .collapsible-default .count-badge {
        background: var(--primary-color);
    }
</style>