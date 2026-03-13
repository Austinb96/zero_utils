class Providers {
    isVisible:boolean = $state(false);
    cameraActive: boolean = $state(false);
    tab: string = $state("all")
}

export const providers = new Providers();
