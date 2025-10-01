<script lang="ts">
    import type { Entity } from "$types/type";
    import { FetchNUI } from "$utils/eventsHandlers";
    import Button from "$components/buttons/Button.svelte";
    import CollapsibleBox from "$components/CollapsibleBox.svelte";
    import EntityCamera from "$components/EntityCamera.svelte";

    let entities: Entity[] = $state([]);
    let groupingMode: "distance" | "model" | "model-distance" = $state("model-distance");
    let maxDistance: number = $state(5.0);
    let networked_only: boolean = $state(false);
    let allGroups: { [key: string]: Entity[] } = $state({});
    let scriptFilter: string = $state("all");
    let sortBy: "distance" | "count" = $state("count");
    
    // New filters
    let entityFilter: string = $state("");
    let maxPlayerDistance: number = $state(100.0);
    let enablePlayerDistanceFilter: boolean = $state(false);

    let cameraEntity = $state<Entity | null>(null);
    let cameraGroup = $state<Entity[]>([]);
    let showCamera = $state(false);

    let playerPosition: { x: number; y: number; z: number } = $state({ x: 0, y: 0, z: 0 });

    const groupedEntities = $derived.by(() => {
        console.log('groupedEntities recalculating, sortBy:', sortBy, 'allGroups length:', Object.keys(allGroups).length);
        if (Object.keys(allGroups).length === 0) return {};
        
        const filtered: { [key: string]: Entity[] } = {};
        
        for (const [groupName, group] of Object.entries(allGroups)) {
            const filteredGroup = filterGroup(group);
            if (filteredGroup.length > 0) {
                filtered[groupName] = filteredGroup;
            }
        }
        
        console.log('Before sorting:', Object.keys(filtered));
        const sorted = sortGroups(filtered);
        console.log('After sorting:', Object.keys(sorted));
        return sorted;
    });

    const uniqueScripts = $derived.by(() => {
        const allGroupedEntities = Object.values(allGroups).flat();
        const scripts = [...new Set(allGroupedEntities.map(e => e.script).filter(Boolean))];
        return scripts.sort();
    });
    
    $effect(() => {
        if (entities.length > 0) {
            buildGroups();
        }
    });

    function calculateDistance(pos1: { x: number; y: number; z: number }, pos2: { x: number; y: number; z: number }): number {
        const dx = pos1.x - pos2.x;
        const dy = pos1.y - pos2.y;
        const dz = pos1.z - pos2.z;
        return Math.sqrt(dx * dx + dy * dy + dz * dz);
    }

    function groupEntitiesByDistance(entities: Entity[], maxDist: number): { [key: string]: Entity[] } {
        const groups: { [key: string]: Entity[] } = {};
        const processed = new Set<string>();

        for (const entity of entities) {
            if (processed.has(entity.id)) continue;

            const group: Entity[] = [entity];
            
            processed.add(entity.id);
            
            for (const otherEntity of entities) {
                if (processed.has(otherEntity.id)) continue;

                const isNearGroup = group.some((groupEntity) => calculateDistance(groupEntity.position, otherEntity.position) <= maxDist);

                if (isNearGroup) {
                    group.push(otherEntity);
                    processed.add(otherEntity.id);
                }
            }

            if (group.length > 1) {
                groups[`${group.length} entities`] = group;
            }
        }

        return groups;
    }

    function groupEntitiesByModel(entities: Entity[]): { [key: string]: Entity[] } {
        const groups: { [key: string]: Entity[] } = {};

        for (const entity of entities) {
            if (!groups[entity.model]) {
                groups[entity.model] = [];
            }
            groups[entity.model].push(entity);
        }

        return groups;
    }

    function groupEntitiesByModelAndDistance(entities: Entity[], maxDist: number): { [key: string]: Entity[] } {
        const groups: { [key: string]: Entity[] } = {};

        const modelGroups: { [key: string]: Entity[] } = {};
        for (const entity of entities) {
            if (!modelGroups[entity.model]) {
                modelGroups[entity.model] = [];
            }
            modelGroups[entity.model].push(entity);
        }

        for (const [model, modelEntities] of Object.entries(modelGroups)) {
            if (modelEntities.length === 1) {
                groups[model] = modelEntities;
            } else {
                const distanceGroups = groupEntitiesByDistance(modelEntities, maxDist);
                
                if (Object.keys(distanceGroups).length === 0) {
                    groups[model] = modelEntities;
                } else {
                    for (const [distanceGroupName, group] of Object.entries(distanceGroups)) {
                        groups[`${model} (${group.length} entities)`] = group;
                    }
                }
            }
        }

        return groups;
    }

    function filterGroupByScript(group: Entity[]): Entity[] {
        if (scriptFilter === "all") return group;
        if (scriptFilter === "none") return group.filter(e => !e.script);
        return group.filter(e => e.script === scriptFilter);
    }

    function filterByEntity(group: Entity[]): Entity[] {
        if (!entityFilter.trim()) return group;
        const filter = entityFilter;
        return group.filter(e => 
            e.model.includes(filter) || 
            e.id.includes(filter)
        );
    }

    function filterByPlayerDistance(group: Entity[]): Entity[] {
        if (!enablePlayerDistanceFilter || !playerPosition) return group;
        return group.filter(e => 
            calculateDistance(playerPosition, e.position) <= maxPlayerDistance
        );
    }

    function filterGroup(group: Entity[]): Entity[] {
        let filtered = filterGroupByScript(group);
        filtered = filterByEntity(filtered);
        filtered = filterByPlayerDistance(filtered);
        return filtered;
    }

    function sortGroups(groups: { [key: string]: Entity[] }): { [key: string]: Entity[] } {
        const entries = Object.entries(groups);
        console.log('sortGroups called with sortBy:', sortBy, 'entries:', entries.length);
        
        if (sortBy === "count") {
            console.log('Sorting by count');
            entries.sort(([, a], [, b]) => {
                console.log(`Comparing ${a.length} vs ${b.length}`);
                return b.length - a.length;
            });
        } else if (sortBy === "distance" && playerPosition) {
            console.log('Sorting by distance with playerPosition:', playerPosition);
            entries.sort(([, a], [, b]) => {
                const avgDistA = a.reduce((sum, entity) => {
                    return sum + calculateDistance(playerPosition, entity.position);
                }, 0) / a.length;
                
                const avgDistB = b.reduce((sum, entity) => {
                    return sum + calculateDistance(playerPosition, entity.position);
                }, 0) / b.length;
                
                return avgDistA - avgDistB;
            });
        } else {
            console.log('No sorting applied - sortBy:', sortBy, 'playerPosition:', !!playerPosition);
        }
        
        return Object.fromEntries(entries);
    }

    function buildGroups() {
        let groups: { [key: string]: Entity[] } = {};
        
        switch (groupingMode) {
            case "distance":
                groups = groupEntitiesByDistance(entities, maxDistance);
                break;
            case "model":
                groups = groupEntitiesByModel(entities);
                break;
            case "model-distance":
                groups = groupEntitiesByModelAndDistance(entities, maxDistance);
                break;
        }
        
        allGroups = groups;
    }

    async function checkEntity() {
        FetchNUI<{ networked_only: boolean }, { entities: Entity[], playerPosition: { x: number; y: number; z: number } }>("getEntities", { networked_only })
            .then((res) => {
                if (res.err) throw new Error(res.err);
                entities = res.result.entities;
                playerPosition = res.result.playerPosition;
            })
            .catch((error) => {
                console.error("Error fetching entities:", error);
            });
    }

    function openEntityCamera(entity: Entity, group: Entity[]) {
        cameraEntity = entity;
        cameraGroup = group;
        showCamera = true;
    }

    function closeCameraView() {
        showCamera = false;
        cameraEntity = null;
        cameraGroup = [];
    }
</script>

<div id="entity-checker-container">
    <div class="controls">
        <!-- Primary Controls Row -->
        <div class="control-section">
            <h3 class="section-title">Grouping & Detection</h3>
            <div class="control-row">
                <div class="control-group">
                    <label for="grouping-mode">Grouping:</label>
                    <select id="grouping-mode" bind:value={groupingMode}>
                        <option value="distance">Distance</option>
                        <option value="model">Model</option>
                        <option value="model-distance">Model + Distance</option>
                    </select>
                </div>

                {#if groupingMode === "distance" || groupingMode === "model-distance"}
                    <div class="control-group">
                        <label for="max-distance">Group Dist:</label>
                        <input id="max-distance" type="number" bind:value={maxDistance} min="0.1" step="0.1" />
                    </div>
                {/if}

                <div class="control-group">
                    <label for="networked-only">Net Only:</label>
                    <input id="networked-only" type="checkbox" bind:checked={networked_only} />
                </div>

                <div class="control-group action-group">
                    <Button fullWidth onClick={() => checkEntity()}>Check Entities</Button>
                </div>
            </div>
        </div>

        <!-- Filter Controls Row -->
        <div class="control-section">
            <h3 class="section-title">Filters & Sorting</h3>
            <div class="control-row">
                <div class="control-group">
                    <label for="entity-filter">Entity/Model:</label>
                    <input 
                        id="entity-filter" 
                        type="text" 
                        bind:value={entityFilter} 
                        placeholder="Filter by name/model..."
                    />
                </div>

                <div class="control-group">
                    <label for="script-filter">Script:</label>
                    <select id="script-filter" bind:value={scriptFilter}>
                        <option value="all">All</option>
                        <option value="none">None</option>
                        {#each uniqueScripts as script}
                            <option value={script}>{script}</option>
                        {/each}
                    </select>
                </div>

                <div class="control-group">
                    <label for="player-distance-enabled">Player Dist:</label>
                    <input id="player-distance-enabled" type="checkbox" bind:checked={enablePlayerDistanceFilter} />
                </div>

                {#if enablePlayerDistanceFilter}
                    <div class="control-group">
                        <label for="max-player-distance">Max:</label>
                        <input id="max-player-distance" type="number" bind:value={maxPlayerDistance} min="1" step="1" />
                    </div>
                {/if}

                <div class="control-group">
                    <label for="sort-by">Sort:</label>
                    <select id="sort-by" bind:value={sortBy}>
                        <option value="count">Count</option>
                        <option value="distance">Distance</option>
                    </select>
                </div>
            </div>
        </div>
    </div>

    <div class="results">
        {#if Object.keys(groupedEntities).length === 0}
            <p class="no-groups">No entity groups found with current settings.</p>
        {:else}
            <div class="summary">
                <div class="summary-item">
                    <span class="summary-value">{Object.keys(groupedEntities).length}</span>
                    <span class="summary-label">Groups Found</span>
                </div>
                <div class="summary-item">
                    <span class="summary-value">{Object.values(groupedEntities).reduce((acc, group) => acc + group.length, 0)}</span>
                    <span class="summary-label">Filtered Entities</span>
                </div>
                <div class="summary-item">
                    <span class="summary-value">{entities.length}</span>
                    <span class="summary-label">Total Found</span>
                </div>
                <div class="summary-item">
                    <span class="summary-value"> {Object.values(groupedEntities).reduce((acc, group) => acc + group.filter((e) => e.isNetworked).length, 0)} </span>
                    <span class="summary-label">Filtered Net</span>
                </div>
            </div>

            {#each Object.entries(groupedEntities) as [groupName, group], groupIndex}
                <CollapsibleBox title={groupName} showCount={group.length} variant={groupIndex % 2 === 0 ? "primary" : "success"} size="md" isOpen={false}>
                    {#snippet children()}
                        <div class="entity-grid">
                            {#each group as entity, index}
                                <div class="entity-card">
                                    <div class="entity-header">
                                        <div class="entity-type-badge" class:vehicle={entity.type === "vehicle"} class:object={entity.type === "object"} class:ped={entity.type === "ped"}>
                                            {entity.type.toUpperCase()}
                                        </div>
                                        <div class="entity-id">Entity: {entity.id}</div>
                                    </div>

                                    <div class="entity-content">
                                        <div class="entity-model">{entity.model}</div>
                                        <div class="entity-position">
                                            <span class="coord-label">Pos:</span>
                                            <span class="coords">
                                                {entity.position.x.toFixed(1)}, {entity.position.y.toFixed(1)}, {entity.position.z.toFixed(1)}
                                            </span>
                                        </div>
                                        {#if entity.script}
                                            <div class="entity-script">
                                                <span class="script-label">Script:</span>
                                                <span class="script-name">{entity.script}</span>
                                            </div>
                                        {/if}
                                    </div>

                                    <div class="entity-footer">
                                        <div class="entity-actions">
                                            <button 
                                                class="camera-button" 
                                                onclick={() => openEntityCamera(entity, group)}
                                                title="View Camera & Highlight Group"
                                            >
                                                📹
                                            </button>
                                            <div class="entity-number">#{index + 1}</div>
                                        </div>
                                        <div class="entity-network" class:networked={entity.isNetworked}>
                                            {entity.isNetworked ? "NET" : "LOCAL"}
                                        </div>
                                    </div>
                                </div>
                            {/each}
                        </div>
                    {/snippet}

                    {#snippet headerContent()}
                        <div class="group-stats">
                            <span class="stat-item">
                                {new Set(group.map((e) => e.model)).size} models
                            </span>
                            <span class="stat-item">
                                {group.filter((e) => e.isNetworked).length} net
                            </span>
                        </div>
                    {/snippet}
                </CollapsibleBox>
            {/each}
        {/if}
    </div>

    {#if cameraEntity}
        <EntityCamera 
            entityId={cameraEntity.id}
            coords={cameraEntity.position}
            groupEntities={cameraGroup}
            isOpen={showCamera}
            onClose={closeCameraView}
        />
    {/if}
</div>

<style>
    #entity-checker-container {
        width: 100%;
        height: 100%;
        display: flex;
        flex-direction: column;
        padding: 8px;
        gap: 8px;
        background: var(--background-color);
        color: var(--text-color);
    }

    .controls {
        padding: 16px;
        background: var(--background2-color);
        border-radius: 0.75rem;
        border: 1px solid var(--primary-color-transparent);
        display: flex;
        flex-direction: column;
        gap: 16px;
    }

    .control-section {
        display: flex;
        flex-direction: column;
        gap: 8px;
    }

    .section-title {
        font-size: 0.9rem;
        font-weight: 600;
        color: var(--color2);
        margin: 0;
        padding-bottom: 4px;
        border-bottom: 1px solid var(--primary-color-transparent);
    }

    .control-row {
        display: flex;
        align-items: center;
        gap: 16px;
        flex-wrap: wrap;
    }

    .primary-controls {
        border-bottom: 1px solid var(--primary-color-transparent);
        padding-bottom: 16px;
    }

    .filter-controls {
        padding-top: 4px;
    }

    .control-group {
        display: flex;
        align-items: center;
        gap: 8px;
        min-width: 0;
    }

    .control-group label {
        font-weight: 600;
        color: var(--text-color);
        font-size: 0.85rem;
        white-space: nowrap;
        min-width: fit-content;
    }

    .control-group select,
    .control-group input[type="number"],
    .control-group input[type="text"] {
        min-width: 100px;
        padding: 6px 10px;
        border: 1px solid var(--primary-color);
        border-radius: 0.4rem;
        background: var(--background-color);
        color: var(--text-color);
        font-size: 0.85rem;
        transition: all 0.2s ease;
    }

    .control-group input[type="text"] {
        min-width: 140px;
    }

    .control-group input[type="checkbox"] {
        width: 18px;
        height: 18px;
        accent-color: var(--primary-color);
        cursor: pointer;
    }

    .control-group select:focus,
    .control-group input[type="number"]:focus,
    .control-group input[type="text"]:focus {
        outline: none;
        border-color: var(--secondary-color);
        box-shadow: 0 0 0 2px var(--primary-color-transparent);
    }

    .action-group {
        margin-left: auto;
        min-width: 140px;
    }

    .results {
        flex: 1;
        overflow-y: auto;
        display: flex;
        flex-direction: column;
        gap: 16px;
    }

    .summary {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
        gap: 8px;
        padding: 12px;
        background: var(--background2-color);
        border-radius: 0.75rem;
        border: 1px solid var(--color2);
    }

    .summary-item {
        display: flex;
        flex-direction: column;
        align-items: center;
        flex: 1;
    }

    .summary-value {
        font-size: 1.5rem;
        font-weight: 700;
        color: var(--color2);
    }

    .summary-label {
        font-size: 0.8rem;
        color: var(--text2-color);
        margin-top: 2px;
    }

    .no-groups {
        text-align: center;
        color: var(--text2-color);
        font-style: italic;
        padding: 48px;
        background: var(--background2-color);
        border-radius: 0.75rem;
        border: 1px solid var(--primary-color-transparent);
    }

    .group-stats {
        display: flex;
        gap: 6px;
        font-size: 0.7rem;
        color: var(--text2-color);
    }

    .stat-item {
        padding: 2px 6px;
        background: var(--background-color);
        border-radius: 0.25rem;
        font-weight: 500;
    }

    .entity-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
        gap: 12px;
        margin-top: 8px;
    }

    .entity-card {
        background: var(--background-color);
        border-radius: 0.5rem;
        padding: 12px;
        border: 1px solid var(--primary-color-transparent);
        display: flex;
        flex-direction: column;
        gap: 8px;
        transition: all 0.2s ease;
        position: relative;
    }

    .entity-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .entity-type-badge {
        padding: 3px 6px;
        border-radius: 0.25rem;
        font-size: 0.7rem;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .entity-type-badge.vehicle {
        background: var(--color3);
        color: var(--background-color);
    }

    .entity-type-badge.object {
        background: var(--color1);
        color: var(--background-color);
    }

    .entity-type-badge.ped {
        background: var(--color4);
        color: var(--background-color);
    }

    .entity-id {
        font-size: 0.8rem;
        font-weight: 600;
        color: var(--secondary-color);
    }

    .entity-content {
        display: flex;
        flex-direction: column;
        gap: 6px;
        flex: 1;
    }

    .entity-model {
        font-family: "Fira Code", "Consolas", monospace;
        font-size: 0.9rem;
        font-weight: 600;
        color: var(--color2);
        word-break: break-word;
    }

    .entity-position {
        display: flex;
        align-items: center;
        gap: 6px;
        font-size: 0.8rem;
    }

    .coord-label {
        color: var(--text2-color);
        font-weight: 500;
    }

    .coords {
        font-family: "Fira Code", "Consolas", monospace;
        color: var(--color1);
        font-weight: 500;
    }

    .entity-script {
        display: flex;
        align-items: center;
        gap: 6px;
        font-size: 0.8rem;
    }

    .script-label {
        color: var(--text2-color);
        font-weight: 500;
    }

    .script-name {
        font-family: "Fira Code", "Consolas", monospace;
        color: var(--color3);
        font-weight: 500;
        background: var(--background2-color);
        padding: 2px 6px;
        border-radius: 0.25rem;
    }

    .entity-footer {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-top: 4px;
    }

    .entity-actions {
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .camera-button {
        background: var(--primary-color);
        border: none;
        border-radius: 0.25rem;
        padding: 4px 6px;
        font-size: 0.8rem;
        cursor: pointer;
        transition: all 0.2s ease;
        color: var(--background-color);
    }

    .camera-button:hover {
        background: var(--secondary-color);
        transform: scale(1.1);
    }

    .entity-number {
        font-size: 0.75rem;
        color: var(--text2-color);
        font-weight: 500;
    }

    .entity-network {
        font-size: 0.7rem;
        font-weight: 600;
        padding: 2px 6px;
        border-radius: 0.25rem;
        background: var(--background2-color);
        color: var(--text2-color);
    }

    .entity-network.networked {
        background: var(--color2);
        color: var(--background-color);
    }
</style>
