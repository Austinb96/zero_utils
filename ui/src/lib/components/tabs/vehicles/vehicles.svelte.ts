import { FetchNUI } from "$utils/eventsHandlers";

export enum VehicleState {
    OUT = 0,
    GARAGED = 1,
    IMPOUND = 2,
}

export interface VehicleData {
    id: number;
    license: string;
    citizenid: string;
    vehicle: string;
    hash: string;
    mods: string;
    plate: string;
    fakeplate: string | null;
    garage: string;
    fuel: number;
    engine: number;
    body: number;
    state: VehicleState;
    depotprice: number;
    drivingdistance: number;
    status: string | null;
    balance: number;
    paymentamount: number;
    paymentsleft: number;
    financetime: number;
    nosColour: string | null;
    traveldistance: number;
    noslevel: number;
    hasnitro: number;
    glovebox: string | null;
    trunk: string | null;
    evidence: string | null;
    bolo: number;
    damages: string | null;
    skippropcheck: number;
    vinscratched: number;
    charinfo: string;
    player_name: string;
}

export function get_state_text(state: VehicleState): string {
    switch (state) {
        case VehicleState.IMPOUND:
            return "Impounded";
        case VehicleState.OUT:
            return "Out";
        case VehicleState.GARAGED:
            return "Garaged";
        default:
            return "Unknown";
    }
}

class Vehicles {
    searchQuery = $state("");
    isSearching = $state(false);

    vehicles: VehicleData[] = $state([]);
    selectedVehicle: VehicleData | null = $state(null);

    showDetailsDialog = $state(false);

    async searchVehicles() {
        if (!this.searchQuery.trim()) {
            this.vehicles = [];
            return;
        }

        if (this.searchQuery.length < 3) {
            return;
        }

        this.isSearching = true;

        try {
            const response = await FetchNUI("getVehicles", this.searchQuery.trim());
            this.vehicles = response.result || [];
        } catch (error) {
            console.error("Failed to search vehicles:", error);
            this.vehicles = [];
        } finally {
            this.isSearching = false;
        }
    }

    async updateVehicle(vehicleId: number, updates: { citizenid?: string; state?: number; garage?: string }) {
        try {
            const response = await FetchNUI("updateVehicle", { vehicleId, updates });

            if (response.result) {
                const index = this.vehicles.findIndex((v) => v.id === vehicleId);
                if (index !== -1) {
                    this.vehicles[index] = { ...this.vehicles[index], ...updates };
                }

                if (this.selectedVehicle && this.selectedVehicle.id === vehicleId) {
                    this.selectedVehicle = { ...this.selectedVehicle, ...updates };
                }

                return { success: true };
            }

            return { success: false, error: response.err || "Update failed" };
        } catch (error) {
            console.error("Failed to update vehicle:", error);
            return { success: false, error: "Failed to update vehicle" };
        }
    }

    selectVehicle(vehicle: VehicleData) {
        this.selectedVehicle = vehicle;
        this.showDetailsDialog = true;
    }

    closeDetailsDialog() {
        this.showDetailsDialog = false;
        this.selectedVehicle = null;
    }

    getCharInfo(vehicle: VehicleData) {
        try {
            return JSON.parse(vehicle.charinfo || "{}");
        } catch {
            return {};
        }
    }

    getFullCharacterName(vehicle: VehicleData): string {
        const charinfo = this.getCharInfo(vehicle);
        return charinfo.firstname && charinfo.lastname ? `${charinfo.firstname} ${charinfo.lastname}` : vehicle.player_name || "Unknown";
    }

    clearSearch() {
        this.searchQuery = "";
        this.vehicles = [];
    }
}

export const vehicles = new Vehicles();
