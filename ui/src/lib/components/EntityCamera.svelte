<script lang="ts">
    import { FetchNUI, ReceiveNUI } from "$utils/eventsHandlers";
    import type { Entity } from "$types/type";
    import { providers } from "$data/providers.svelte";

    interface Props {
        entityId: string;
        coords: { x: number; y: number; z: number };
        groupEntities?: Entity[];
        isOpen: boolean;
        onClose: () => void;
    }

    let { entityId, coords, groupEntities = [], isOpen, onClose }: Props = $props();
    let isLoading = $state(false);
    let error = $state<string | null>(null);

    async function openCamera() {
        if (!isOpen) return;
        
        isLoading = true;
        error = null;
        
        const entityIdStr = String(entityId);
        const id = parseInt(entityIdStr.split("(")[0]);
        
        if (isNaN(id)) {
            error = "Invalid entity ID format";
            isLoading = false;
            return;
        }
        
        try {
            const response = await FetchNUI<{ 
                entityId: number; 
                coords: { x: number; y: number; z: number };
                groupEntities: Entity[];
            }, boolean>(
                "createEntityCamera", 
                { entityId: id, coords, groupEntities }
            );
            
            console.log("Camera response:", response);
            if (response.err || !response.result) {
                error = response.err || "Failed to create camera";
            } else {
                providers.cameraActive = true;
            }
        } catch (err) {
            error = "Failed to create camera view";
            console.error("Camera error:", err);
        } finally {
            isLoading = false;
        }
    }

    async function closeCamera() {
        try {
            await FetchNUI("closeEntityCamera", {});
            providers.cameraActive = false;
        } catch (err) {
            console.error("Error closing camera:", err);
        }
        onClose();
    }
    
    ReceiveNUI("closeEntityCamera", () => {
        providers.cameraActive = false;
        onClose();
    });

    $effect(() => {
        if (isOpen) {
            openCamera();
        } else {
            closeCamera();
        }
    });
</script>

{#if isOpen && !providers.cameraActive}
    <div class="camera-overlay" onclick={closeCamera}>
        <div class="camera-container" onclick={(e) => e.stopPropagation()}>
            <div class="camera-header">
                <div class="camera-title">
                    <span class="camera-icon">📹</span>
                    Entity Camera View
                </div>
                <button class="close-button" onclick={closeCamera} type="button">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <line x1="18" y1="6" x2="6" y2="18"></line>
                        <line x1="6" y1="6" x2="18" y2="18"></line>
                    </svg>
                </button>
            </div>
            
            <div class="camera-content">
                {#if isLoading}
                    <div class="camera-loading">
                        <div class="loading-spinner"></div>
                        <p>Activating camera view...</p>
                        <p class="loading-hint">Camera will take over your screen</p>
                    </div>
                {:else if error}
                    <div class="camera-error">
                        <div class="error-icon">⚠️</div>
                        <p>{error}</p>
                        <button onclick={() => openCamera()} class="retry-button">Retry</button>
                    </div>
                {:else}
                    <p>something went wrong</p>
                {/if}
            </div>
        </div>
    </div>
{:else if providers.cameraActive}
    <!-- Camera is active - show persistent escape UI -->
    <div class="camera-escape-overlay">
        <div class="escape-panel">
            <div class="escape-header">
                <span class="camera-icon">📹</span>
                <span class="escape-title">Camera Mode</span>
            </div>
            
            <div class="escape-controls">
                <div class="control-section">
                    <div class="control-title">Camera Movement</div>
                    <div class="control-grid">
                        <div class="control-row">
                            <span class="control-keys">
                                <span class="key">W</span>
                                <span class="key">A</span>
                                <span class="key">S</span>
                                <span class="key">D</span>
                                <span class="key">Mouse</span>
                            </span>
                            <span class="control-desc">Move Camera</span>
                        </div>
                        <div class="control-row">
                            <span class="control-keys">
                                <span class="key">Q</span>
                                <span class="key">E</span>
                            </span>
                            <span class="control-desc">Up/Down</span>
                        </div>
                    </div>
                </div>
                
                <div class="control-section">
                    <div class="control-title">Exit Camera</div>
                    <div class="escape-options">
                        <button class="escape-button" onclick={closeCamera}>
                            <span class="key">ESC</span>
                            <span>or Click Here</span>
                        </button>
                    </div>
                </div>
            </div>
            
            <div class="entity-info">
                <div class="info-row">
                    <span class="info-label">Entity:</span>
                    <span class="info-value">{entityId}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Coords:</span>
                    <span class="info-value">{coords.x.toFixed(1)}, {coords.y.toFixed(1)}, {coords.z.toFixed(1)}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Group:</span>
                    <span class="info-value">{groupEntities.length} entities highlighted</span>
                </div>
            </div>
        </div>
    </div>
{/if}

<style>
    .camera-overlay {
        position: fixed;
        top: 0;
        left: 0;
        width: 100vw;
        height: 100vh;
        background: rgba(0, 0, 0, 0.8);
        display: flex;
        align-items: center;
        justify-content: center;
        z-index: 1000;
        backdrop-filter: blur(4px);
    }

    .camera-container {
        background: var(--background-color);
        border-radius: 0.75rem;
        border: 1px solid var(--primary-color);
        box-shadow: 0 20px 40px rgba(0, 0, 0, 0.5);
        width: 400px;
        max-width: 90vw;
        overflow: hidden;
    }

    .camera-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 12px 16px;
        background: var(--background2-color);
        border-bottom: 1px solid var(--primary-color-transparent);
    }

    .camera-title {
        display: flex;
        align-items: center;
        gap: 8px;
        font-weight: 600;
        color: var(--primary-color);
    }

    .camera-icon {
        font-size: 1.2rem;
    }

    .close-button {
        background: none;
        border: none;
        color: var(--text2-color);
        cursor: pointer;
        padding: 4px;
        border-radius: 0.25rem;
        transition: all 0.2s ease;
    }

    .close-button:hover {
        color: var(--color4);
        background: var(--background-color);
    }

    .camera-content {
        padding: 16px;
    }

    .camera-loading,
    .camera-error {
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 12px;
        padding: 32px;
        text-align: center;
    }

    .loading-spinner {
        width: 32px;
        height: 32px;
        border: 3px solid var(--background2-color);
        border-top: 3px solid var(--primary-color);
        border-radius: 50%;
        animation: spin 1s linear infinite;
    }

    .loading-hint {
        font-size: 0.8rem;
        color: var(--text2-color);
        font-style: italic;
    }

    @keyframes spin {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(360deg); }
    }

    .error-icon {
        font-size: 2rem;
    }

    .retry-button {
        padding: 8px 16px;
        background: var(--primary-color);
        color: var(--background-color);
        border: none;
        border-radius: 0.5rem;
        cursor: pointer;
        font-weight: 600;
        transition: all 0.2s ease;
    }

    .retry-button:hover {
        background: var(--secondary-color);
    }

    .camera-escape-overlay {
        position: fixed;
        top: 20px;
        right: 20px;
        z-index: 1000;
        pointer-events: auto;
    }

    .escape-panel {
        background: rgba(30, 30, 46, 0.95);
        border: 2px solid var(--primary-color);
        border-radius: 0.75rem;
        padding: 16px;
        backdrop-filter: blur(12px);
        min-width: 280px;
        box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
    }

    .escape-header {
        display: flex;
        align-items: center;
        gap: 8px;
        margin-bottom: 16px;
        padding-bottom: 8px;
        border-bottom: 1px solid var(--primary-color-transparent);
    }

    .escape-title {
        color: var(--primary-color);
        font-weight: 700;
        font-size: 1rem;
    }

    .escape-controls {
        display: flex;
        flex-direction: column;
        gap: 12px;
        margin-bottom: 16px;
    }

    .control-section {
        display: flex;
        flex-direction: column;
        gap: 6px;
    }

    .control-title {
        color: var(--text-color);
        font-weight: 600;
        font-size: 0.85rem;
    }

    .control-grid {
        display: flex;
        flex-direction: column;
        gap: 4px;
    }

    .control-row {
        display: flex;
        justify-content: space-between;
        align-items: center;
        gap: 8px;
    }

    .control-keys {
        display: flex;
        gap: 2px;
    }

    .control-desc {
        font-size: 0.7rem;
        color: var(--text2-color);
        text-align: right;
        flex: 1;
    }

    .escape-options {
        display: flex;
        flex-direction: column;
        gap: 4px;
    }

    .escape-button {
        background: var(--color4);
        color: var(--background-color);
        border: none;
        border-radius: 0.5rem;
        padding: 8px 12px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.2s ease;
        display: flex;
        align-items: center;
        gap: 8px;
        justify-content: center;
    }

    .escape-button:hover {
        background: var(--secondary-color);
        transform: translateY(-1px);
        box-shadow: 0 4px 12px rgba(137, 180, 250, 0.3);
    }

    .escape-button .key {
        background: var(--background-color);
        color: var(--color4);
        margin: 0;
    }

    .entity-info {
        display: flex;
        flex-direction: column;
        gap: 4px;
        padding-top: 12px;
        border-top: 1px solid var(--primary-color-transparent);
    }

    .info-row {
        display: flex;
        justify-content: space-between;
        align-items: center;
        font-size: 0.75rem;
    }

    .info-label {
        color: var(--text2-color);
        font-weight: 500;
    }

    .info-value {
        color: var(--color2);
        font-family: 'Fira Code', monospace;
        font-weight: 500;
    }

    .key {
        background: var(--background2-color);
        color: var(--text-color);
        padding: 4px 8px;
        border-radius: 0.25rem;
        font-family: 'Fira Code', monospace;
        font-size: 0.75rem;
        font-weight: 600;
        border: 1px solid var(--primary-color-transparent);
        min-width: 28px;
        text-align: center;
        white-space: nowrap;
    }
</style>