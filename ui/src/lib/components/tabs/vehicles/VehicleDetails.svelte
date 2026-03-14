<script lang="ts">
    import type { VehicleData } from "./vehicles.svelte";
    import { vehicles, VehicleState, get_state_text } from "./vehicles.svelte";
    import Popup from "../../Popup.svelte";
    import Icon from "@iconify/svelte";
    import TextInput from "../../input/TextInput.svelte";

    let { vehicle, onClose }: { vehicle: VehicleData; onClose: () => void } = $props();

    let show = $state(true);
    let isEditing = $state(false);
    let isSaving = $state(false);

    // Edit form state
    let editCitizenid = $state(vehicle.citizenid);
    let editState = $state<VehicleState>(vehicle.state);
    let editGarage = $state(vehicle.garage || "");

    $effect(() => {
        if (!show) {
            onClose();
        }
    });

    const fullName = $derived(vehicles.getFullCharacterName(vehicle));

    function toggleEdit() {
        if (isEditing) {
            editCitizenid = vehicle.citizenid;
            editState = vehicle.state;
            editGarage = vehicle.garage || "";
        }
        isEditing = !isEditing;
    }

    async function saveChanges() {
        isSaving = true;

        const updates: any = {};
        if (editCitizenid !== vehicle.citizenid) updates.citizenid = editCitizenid;
        if (editState !== vehicle.state) updates.state = editState;
        if (editGarage !== (vehicle.garage || "")) updates.garage = editGarage;

        const result = await vehicles.updateVehicle(vehicle.id, updates);

        if (result.success) {
            vehicle = { ...vehicle, ...updates };
            isEditing = false;
        } else {
            alert(result.error || "Failed to save changes");
        }

        isSaving = false;
    }
</script>

<Popup bind:show header={`${vehicle.vehicle} - ${vehicle.plate}`} width="50%">
    <div class="vehicle-details">
        <div class="header-actions">
            {#if !isEditing}
                <button class="btn btn-edit" onclick={toggleEdit}>
                    <Icon icon="mdi:pencil" />
                    Edit
                </button>
            {:else}
                <button class="btn btn-save" onclick={saveChanges} disabled={isSaving}>
                    {#if isSaving}
                        <Icon icon="mdi:loading" class="spin" />
                    {:else}
                        <Icon icon="mdi:content-save" />
                    {/if}
                    Save
                </button>
                <button class="btn btn-cancel" onclick={toggleEdit} disabled={isSaving}>
                    <Icon icon="mdi:close" />
                    Cancel
                </button>
            {/if}
        </div>

        <div class="info-grid">
            <div class="info-card">
                <div class="card-header">
                    <Icon icon="mdi:account" width="18" />
                    <span>Owner</span>
                </div>
                <div class="card-content">
                    <div class="info-row">
                        <span class="label">Name:</span>
                        <span class="value">{fullName}</span>
                    </div>
                    <div class="info-row">
                        <span class="label">FSR ID:</span>
                        {#if isEditing}
                            <TextInput bind:value={editCitizenid} placeholder="FSR00000" />
                        {:else}
                            <span class="value">{vehicle.citizenid}</span>
                        {/if}
                    </div>
                </div>
            </div>

            <div class="info-card">
                <div class="card-header">
                    <Icon icon="mdi:car" width="18" />
                    <span>Vehicle</span>
                </div>
                <div class="card-content">
                    <div class="info-row">
                        <span class="label">Model:</span>
                        <span class="value">{vehicle.vehicle}</span>
                    </div>
                    <div class="info-row">
                        <span class="label">Plate:</span>
                        <span class="value-plate">{vehicle.plate}</span>
                    </div>
                </div>
            </div>

            <div class="info-card">
                <div class="card-header">
                    <Icon icon="mdi:information" width="18" />
                    <span>Status</span>
                </div>
                <div class="card-content">
                    <div class="info-row">
                        <span class="label">State:</span>
                        {#if isEditing}
                            <select bind:value={editState} class="select-input">
                                <option value={VehicleState.IMPOUND}>Impounded</option>
                                <option value={VehicleState.OUT}>Out</option>
                                <option value={VehicleState.GARAGED}>Garaged</option>
                            </select>
                        {:else}
                            <span class="value-status status-{vehicle.state}">{get_state_text(vehicle.state)}</span>
                        {/if}
                    </div>
                    <div class="info-row">
                        <span class="label">Garage:</span>
                        {#if isEditing}
                            <TextInput bind:value={editGarage} placeholder="Location" />
                        {:else}
                            <span class="value">{vehicle.garage || "None"}</span>
                        {/if}
                    </div>
                </div>
            </div>

            <div class="info-card">
                <div class="card-header">
                    <Icon icon="mdi:wrench" width="18" />
                    <span>Condition</span>
                </div>
                <div class="card-content">
                    <div class="condition-bar">
                        <span class="condition-label">Fuel: {vehicle.fuel}%</span>
                        <div class="bar"><div class="bar-fill" style="width: {vehicle.fuel}%"></div></div>
                    </div>
                    <div class="condition-bar">
                        <span class="condition-label">Engine: {Math.round((vehicle.engine / 1000) * 100)}%</span>
                        <div class="bar"><div class="bar-fill" style="width: {(vehicle.engine / 1000) * 100}%"></div></div>
                    </div>
                    <div class="condition-bar">
                        <span class="condition-label">Body: {Math.round((vehicle.body / 1000) * 100)}%</span>
                        <div class="bar"><div class="bar-fill" style="width: {(vehicle.body / 1000) * 100}%"></div></div>
                    </div>
                </div>
            </div>

            {#if vehicle.vinscratched || vehicle.bolo || vehicle.depotprice > 0}
                <div class="info-card alert-card">
                    <div class="card-header">
                        <Icon icon="mdi:alert" width="18" />
                        <span>Alerts</span>
                    </div>
                    <div class="card-content">
                        {#if vehicle.vinscratched}
                            <div class="alert-item">
                                <Icon icon="mdi:alert" width="16" />
                                VIN Scratched
                            </div>
                        {/if}
                        {#if vehicle.bolo}
                            <div class="alert-item">
                                <Icon icon="mdi:alert-circle" width="16" />
                                BOLO Active
                            </div>
                        {/if}
                        {#if vehicle.depotprice > 0}
                            <div class="alert-item">
                                <Icon icon="mdi:cash" width="16" />
                                Impound Fee: ${vehicle.depotprice.toLocaleString()}
                            </div>
                        {/if}
                    </div>
                </div>
            {/if}

            {#if vehicle.paymentsleft > 0}
                <div class="info-card">
                    <div class="card-header">
                        <Icon icon="mdi:currency-usd" width="18" />
                        <span>Financing</span>
                    </div>
                    <div class="card-content">
                        <div class="info-row">
                            <span class="label">Balance:</span>
                            <span class="value">${vehicle.balance.toLocaleString()}</span>
                        </div>
                        <div class="info-row">
                            <span class="label">Payments:</span>
                            <span class="value">${vehicle.paymentamount} × {vehicle.paymentsleft}</span>
                        </div>
                    </div>
                </div>
            {/if}
        </div>
    </div>
</Popup>

<style>
    .vehicle-details {
        display: flex;
        flex-direction: column;
        gap: 1rem;
        height: 100%;
    }

    .header-actions {
        display: flex;
        gap: 0.5rem;
        justify-content: flex-end;
    }

    .btn {
        display: flex;
        align-items: center;
        gap: 0.35rem;
        padding: 0.5rem 1rem;
        border: none;
        border-radius: 0.25rem;
        cursor: pointer;
        font-size: 0.9rem;
        transition: all 0.2s;
    }

    .btn-edit {
        background: var(--primary-color);
        color: white;
    }

    .btn-save {
        background: var(--color2);
        color: white;
    }

    .btn-cancel {
        background: var(--background2-color);
        color: var(--text-color);
        border: 1px solid var(--color4);
    }

    .btn:hover:not(:disabled) {
        opacity: 0.9;
    }

    .btn:disabled {
        opacity: 0.6;
        cursor: not-allowed;
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

    .info-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
        gap: 0.75rem;
        overflow-y: auto;
        max-height: calc(100% - 60px);
        padding-right: 4px;
    }

    /* Custom scrollbar */
    .info-grid::-webkit-scrollbar {
        width: 6px;
    }

    .info-grid::-webkit-scrollbar-track {
        background: var(--background2-color);
        border-radius: 3px;
    }

    .info-grid::-webkit-scrollbar-thumb {
        background: var(--primary-color);
        border-radius: 3px;
    }

    .info-card {
        background: var(--background2-color);
        border: 1px solid var(--primary-color);
        border-radius: 0.5rem;
        overflow: hidden;
    }

    .alert-card {
        border-color: var(--color3);
    }

    .card-header {
        display: flex;
        align-items: center;
        gap: 0.5rem;
        padding: 0.75rem;
        background: var(--background-color);
        border-bottom: 1px solid var(--primary-color);
        color: var(--primary-color);
        font-weight: 600;
        font-size: 0.9rem;
    }

    .alert-card .card-header {
        border-color: var(--color3);
        color: var(--color3);
    }

    .card-content {
        padding: 0.75rem;
        display: flex;
        flex-direction: column;
        gap: 0.5rem;
    }

    .info-row {
        display: flex;
        justify-content: space-between;
        align-items: center;
        gap: 0.5rem;
        font-size: 0.85rem;
    }

    .label {
        color: var(--text2-color);
        font-weight: 500;
    }

    .value {
        color: var(--text-color);
        text-align: right;
    }

    .value-plate {
        background: var(--background-color);
        padding: 0.2rem 0.5rem;
        border-radius: 0.25rem;
        font-family: monospace;
        font-weight: bold;
        color: var(--primary-color);
        font-size: 0.85rem;
    }

    .value-status {
        font-weight: 600;
        padding: 0.2rem 0.5rem;
        border-radius: 0.25rem;
    }

    .value-status.status-0 {
        background: var(--color4);
        color: white;
    }

    .value-status.status-1 {
        background: var(--color2);
        color: white;
    }

    .value-status.status-2 {
        background: var(--primary-color);
        color: white;
    }

    .select-input {
        padding: 0.4rem;
        background: var(--background-color);
        color: var(--text-color);
        border: 1px solid var(--primary-color);
        border-radius: 0.25rem;
        font-size: 0.85rem;
        max-width: 150px;
    }

    .condition-bar {
        display: flex;
        flex-direction: column;
        gap: 0.25rem;
    }

    .condition-label {
        font-size: 0.8rem;
        color: var(--text2-color);
    }

    .bar {
        height: 6px;
        background: var(--background-color);
        border-radius: 3px;
        overflow: hidden;
    }

    .bar-fill {
        height: 100%;
        background: linear-gradient(90deg, var(--color2), var(--primary-color));
        transition: width 0.3s ease;
    }

    .alert-item {
        display: flex;
        align-items: center;
        gap: 0.5rem;
        color: var(--color3);
        font-size: 0.85rem;
        font-weight: 500;
    }
</style>
