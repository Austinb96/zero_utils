<script lang="ts">
    interface Props {
        children?: import("svelte").Snippet;
        width?: string;
        height?: string;
        aspect_ratio?: string;
        handleSelector?: string;
        defaultLeft?: number;
        defaultTop?: number;
        savePosition?: boolean;
        canDrag?: boolean;
        startCentered?: boolean;
    }

    let { 
        children, 
        width = "auto", 
        height = "auto", 
        aspect_ratio = "",
        handleSelector = ".drag-handle", 
        defaultLeft = 0, 
        defaultTop = 0,
        savePosition = true,
        canDrag = true,
        startCentered = false
    }: Props = $props();

    function getValidPosition(key: string, defaultValue: number): number {
        if (!savePosition) return defaultValue;
        
        const stored = localStorage.getItem(key);
        if (!stored) return defaultValue;
        
        const parsed = Number.parseFloat(stored);
        if (isNaN(parsed) || !isFinite(parsed) || parsed < -50 || parsed > 145) {
            localStorage.removeItem(key);
            return defaultValue;
        }
        
        return parsed;
    }

    let left: number = $state(getValidPosition("left", defaultLeft));
    let top: number = $state(getValidPosition("top", defaultTop));

    let moving = false;
    let startX = 0;
    let startY = 0;
    let initialLeft: number;
    let initialTop: number;
    let animationFrame: number | null = null;
    let saveTimeout: number | null = null;

    let containerWidth = window.innerWidth;
    let containerHeight = window.innerHeight;
    let containerRef: HTMLElement;

    let dragHandle: HTMLElement | null = null;

    function isDragTarget(target: HTMLElement): boolean {
        if(!canDrag) return false;
        
        if (!dragHandle) {
            dragHandle = containerRef?.querySelector(handleSelector) as HTMLElement;
        }
        
        return dragHandle ? dragHandle.contains(target) : false;
    }

    function updatePosition(clientX: number, clientY: number) {
        if (!moving) return;
        
        const deltaX = ((clientX - startX) / containerWidth) * 100;
        const deltaY = ((clientY - startY) / containerHeight) * 100;
        const newLeft = initialLeft + deltaX;
        const newTop = initialTop + deltaY;
        
        left = newLeft;
        top = newTop;
    }

    function onMouseDown(e: MouseEvent) {
        if (!isDragTarget(e.target as HTMLElement)) return;

        moving = true;
        startX = e.clientX;
        startY = e.clientY;
        initialLeft = left;
        initialTop = top;
        e.preventDefault();
        
        document.body.style.cursor = 'grabbing';
    }

    function onMouseMove(e: MouseEvent) {
        if (!moving) return;
        
        if (animationFrame) return;
        
        animationFrame = requestAnimationFrame(() => {
            updatePosition(e.clientX, e.clientY);
            animationFrame = null;
        });
    }

    function onMouseUp() {
        if (!moving) return;
        
        moving = false;
        document.body.style.cursor = '';
        
        if (animationFrame) {
            cancelAnimationFrame(animationFrame);
            animationFrame = null;
        }
        
        if (savePosition) {
            if (saveTimeout) clearTimeout(saveTimeout);
            saveTimeout = setTimeout(() => {
                try {
                    localStorage.setItem("left", left.toString());
                    localStorage.setItem("top", top.toString());
                } catch (e) {
                    console.warn('Failed to save position to localStorage:', e);
                }
            }, 100);
        }
    }

    function onDoubleClick(e: MouseEvent) {
        if (!isDragTarget(e.target as HTMLElement)) return;

        left = defaultLeft;
        top = defaultTop;

        dragHandle = null;

        if (savePosition) {
            if (saveTimeout) clearTimeout(saveTimeout);
            saveTimeout = setTimeout(() => {
                try {
                    localStorage.setItem("left", left.toString());
                    localStorage.setItem("top", top.toString());
                } catch (e) {
                    console.warn('Failed to save position to localStorage:', e);
                }
            }, 100);
        }
    }

    let resizeTimeout: number | null = null;
    function onResize() {
        if (resizeTimeout) clearTimeout(resizeTimeout);
        resizeTimeout = setTimeout(() => {
            containerWidth = window.innerWidth;
            containerHeight = window.innerHeight;
        }, 100);
    }

    $effect(() => {
        window.addEventListener("resize", onResize, { passive: true });
        if (startCentered && containerRef && !savePosition) {
            const rect = containerRef.getBoundingClientRect();
            const centerLeft = ((containerWidth - rect.width) / 2 / containerWidth) * 100;
            const centerTop = ((containerHeight - rect.height) / 2 / containerHeight) * 100;
            left = centerLeft;
            top = centerTop;
        }
        
        return () => {
            window.removeEventListener("resize", onResize);
            if (animationFrame) cancelAnimationFrame(animationFrame);
            if (saveTimeout) clearTimeout(saveTimeout);
            if (resizeTimeout) clearTimeout(resizeTimeout);
        };
    });
</script>

<!-- svelte-ignore a11y_no_static_element_interactions -->
<div 
    bind:this={containerRef} 
    style="left: {left}vw; top: {top}vh; {width ? `width: ${width};` : ""} {height ? `height: ${height};` : ""} {aspect_ratio ? `aspect-ratio: ${aspect_ratio};` : ""}" 
    class="draggable-container"
    onmousedown={onMouseDown} 
    ondblclick={onDoubleClick}
>
    <div class="draggable-content">
        {@render children?.()}
    </div>
</div>

<svelte:window on:mouseup={onMouseUp} on:mousemove={onMouseMove} />

<style>
    .draggable-container {
        position: fixed;
        user-select: none;
        will-change: transform;
    }

    .draggable-content {
        width: 100%;
        height: 100%;
        position: relative;
    }
</style>
