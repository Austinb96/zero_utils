export interface CustomWindow extends Window {
    GetParentResourceName: () => string;
    invokeNative?: () => void;
}

export interface Vector4 {
    x: number;
    y: number;
    z: number;
    w: number;
}

export type Entity = {
    id: string;
    model: string;
    position: Vector4;
    type: "vehicle" | "object" | "ped";
    script: string | null;
    isNetworked: boolean;
};
