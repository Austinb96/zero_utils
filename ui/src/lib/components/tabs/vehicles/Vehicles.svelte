<script lang="ts">
    import TextInput from "../../input/TextInput.svelte";
    import Icon from "@iconify/svelte";
    import { vehicles, get_state_text } from "./vehicles.svelte";
    import VehicleDetails from "./VehicleDetails.svelte";

    function handleSearch() {
        vehicles.searchVehicles();
    }
</script>

<div id="vehicles-tab-container">
    <div class="search-section">
        <h2>Vehicle Search</h2>
        <div class="search-bar">
            <TextInput bind:value={vehicles.searchQuery} placeholder="Search by plate, citizenid, or license..." />
            <button class="btn-primary" onclick={handleSearch} disabled={vehicles.isSearching}>
                {#if vehicles.isSearching}
                    <Icon icon="mdi:loading" class="spin" />
                {:else}
                    <Icon icon="mdi:magnify" />
                {/if}
                Search
            </button>
            {#if vehicles.searchQuery}
                <button class="btn-secondary" onclick={() => vehicles.clearSearch()}>
                    <Icon icon="mdi:close" />
                    Clear
                </button>
            {/if}
        </div>
    </div>

    <div class="results-section">
        {#if vehicles.isSearching}
            <div class="loading-state">
                <Icon icon="mdi:loading" class="spin" width="48" />
                <p>Searching...</p>
            </div>
        {:else if vehicles.vehicles.length === 0 && vehicles.searchQuery}
            <div class="empty-state">
                <Icon icon="mdi:car-off" width="48" />
                <p>No vehicles found</p>
            </div>
        {:else if vehicles.vehicles.length > 0}
            <div class="vehicles-list">
                <div class="results-header">
                    <h3>Found {vehicles.vehicles.length} vehicle{vehicles.vehicles.length !== 1 ? "s" : ""}</h3>
                </div>
                {#each vehicles.vehicles as vehicle (vehicle.id)}
                    <div class="vehicle-card" onclick={() => vehicles.selectVehicle(vehicle)}>
                        <div class="vehicle-row">
                            <div class="vehicle-info">
                                <Icon icon="mdi:account" width="18" />
                                <span class="label">Owner:</span>
                                <span class="value">{vehicles.getFullCharacterName(vehicle)}</span>
                            </div>
                            <div class="vehicle-info">
                                <Icon icon="mdi:card-account-details" width="18" />
                                <span class="label">FSR:</span>
                                <span class="value">{vehicle.citizenid}</span>
                            </div>
                        </div>
                        <div class="vehicle-row">
                            <div class="vehicle-info">
                                <Icon icon="mdi:card" width="18" />
                                <span class="label">Plate:</span>
                                <span class="plate">{vehicle.plate}</span>
                            </div>
                            <div class="vehicle-info">
                                <Icon icon="mdi:information" width="18" />
                                <span class="label">Status:</span>
                                <span class="status status-{vehicle.state}">{get_state_text(vehicle.state)}</span>
                            </div>
                        </div>
                        <div class="vehicle-row">
                            <div class="vehicle-info">
                                <Icon icon="mdi:garage" width="18" />
                                <span class="label">Garage:</span>
                                <span class="value">{vehicle.garage || "None"}</span>
                            </div>
                        </div>
                    </div>
                {/each}
            </div>
        {/if}
    </div>
</div>

{#if vehicles.showDetailsDialog && vehicles.selectedVehicle}
    <VehicleDetails vehicle={vehicles.selectedVehicle} onClose={() => vehicles.closeDetailsDialog()} />
{/if}

<style>
    #vehicles-tab-container {
        display: flex;
        flex-direction: column;
        gap: 1rem;
        padding: 1rem;
    }

    .search-section h2 {
        margin: 0 0 1rem 0;
        color: var(--text-color);
    }

    .search-bar {
        display: flex;
        gap: 0.5rem;
        align-items: center;
    }

    .btn-primary,
    .btn-secondary {
        display: flex;
        align-items: center;
        gap: 0.5rem;
        padding: 0.5rem 1rem;
        border: none;
        border-radius: 0.25rem;
        cursor: pointer;
        font-size: 0.9rem;
        transition: all 0.2s;
        white-space: nowrap;
    }

    .btn-primary {
        background: var(--primary-color);
        color: white;
    }

    .btn-primary:hover:not(:disabled) {
        opacity: 0.9;
    }

    .btn-primary:disabled {
        opacity: 0.6;
        cursor: not-allowed;
    }

    .btn-secondary {
        background: var(--background2-color);
        color: var(--text-color);
        border: 1px solid var(--primary-color);
    }

    .btn-secondary:hover {
        background: var(--primary-color);
        color: white;
    }

    :global(.spin) {
        animation: spin 1s linear infinite;
    }

    @keyframes spin {
        from {
            transform: rotate(0deg);
        }
        to {
            transform: rotate(360deg);
        }
    }

    .results-section {
        flex: 1;
        overflow-y: auto;
    }

    .loading-state,
    .empty-state {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        gap: 1rem;
        padding: 3rem;
        color: var(--text2-color);
    }

    .results-header {
        margin-bottom: 1rem;
    }

    .results-header h3 {
        margin: 0;
        color: var(--text-color);
        font-size: 1rem;
    }

    .vehicles-list {
        display: flex;
        flex-direction: column;
        gap: 0.75rem;
    }

    .vehicle-card {
        background: var(--background2-color);
        border: 1px solid var(--primary-color);
        border-radius: 0.5rem;
        padding: 1rem;
        cursor: pointer;
        transition: all 0.2s;
        display: flex;
        flex-direction: column;
        gap: 0.5rem;
    }

    .vehicle-card:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        border-color: var(--secondary-color);
    }

    .vehicle-row {
        display: flex;
        gap: 1rem;
        flex-wrap: wrap;
    }

    .vehicle-info {
        display: flex;
        align-items: center;
        gap: 0.5rem;
        font-size: 0.85rem;
        color: var(--text2-color);
        flex: 1;
        min-width: 200px;
    }

    .label {
        font-weight: 500;
    }

    .value {
        color: var(--text-color);
    }

    .plate {
        background: var(--background-color);
        padding: 0.15rem 0.4rem;
        border-radius: 0.25rem;
        font-family: monospace;
        font-size: 0.85rem;
        font-weight: bold;
        color: var(--primary-color);
    }

    .status {
        font-weight: 600;
    }

    .status-0 {
        color: var(--color4);
    }

    .status-1 {
        color: var(--color2);
    }

    .status-2 {
        color: var(--primary-color);
    }
</style>
