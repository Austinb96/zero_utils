local inventory = zutils.bridge_loader("inventory")
if not inventory then return end

zutils.inventory = {}

local personal_stashes = {}

function zutils.inventory.getItemInfo(item)
    return inventory.getItemInfo(item)
end

function zutils.inventory.findItem(inv, item, metadata)
    return inventory.findItem(inv, item, metadata)
end

function zutils.inventory.doesItemExist(item)
    local exists, err = inventory.getItemInfo(item)
    if not exists then
        printwarn("Item does not exist: %s", err)
        return false, err
    end
    return true
end

function zutils.inventory.getAvailableWeight(inv)
    return inventory.getAvailableWeight(inv)
end

function zutils.inventory.getItemCount(inv, item, metadata)
    return inventory.getItemCount(inv, item, metadata)
end

function zutils.inventory.createUseableItem(itemName, cb)
    return inventory.createUseableItem(itemName, cb)
end

function zutils.inventory.addItem(inv, item, count, metadata, slot, cb)
    assert(item, "Item must be specified")
    count = count or 1

    if not zutils.inventory.doesItemExist(item) then
        return false, "Item does not exist: " .. item
    end

    if not zutils.inventory.canCarryItem(inv, item, count, metadata) then
        return false, "Inventory Cannot carry: " .. item
    end

    local result = inventory.addItem(inv, item, count, metadata, slot, cb)
    if not result then
        return false, "Inventory AddItem failed: " .. item
    end
    return true
end

zutils.inventory.AddItem = zutils.inventory.addItem -- Alias for compatibility

function zutils.inventory.removeItem(inv, item, count, metadata, slot, cb)
    assert(item, "Item must be specified")
    count = count or 1

    if not zutils.inventory.doesItemExist(item) then
        return false, "Item does not exist: " .. tostring(item)
    end

    if not zutils.inventory.hasItem(inv, item, count, metadata) then
        return false, "Inventory does not have item: " .. tostring(item)
    end

    local result = inventory.removeItem(inv, item, count, metadata, slot, cb)
    if not result then
        return false, "Inventory RemoveItem failed: " .. tostring(item)
    end
    return true
end

zutils.inventory.RemoveItem = zutils.inventory.removeItem -- Alias for compatibility

function zutils.inventory.canCarryItem(inv, item, count, metadata)
    return inventory.canCarryItem(inv, item, count, metadata)
end

function zutils.inventory.hasItem(inv, item, count, metadata)
    count = count or 1
    return inventory.hasItem(inv, item, count, metadata)
end

zutils.inventory.HasItem = zutils.inventory.hasItem -- Alias for compatibility

function zutils.inventory.registerStash(id, label, slots, max_weight, owner, groups, coords, is_personal)
    assert(id, "ID must be specified")
    assert(label, "Label must be specified")
    coords = coords and coords.xyz or nil

    if is_personal then
        printdb("Registering personal stash: %s", id)
        personal_stashes[id] = {
            label = label,
            slots = slots or 50,
            max_weight = max_weight or 1000000,
            owner = owner or nil,
            groups = groups or nil,
            coords = coords or nil
        }
        return
    end
    slots = slots or 50
    max_weight = max_weight or 1000000
    inventory.registerStash(id, label, slots, max_weight, owner, groups, coords)
    printdb( "Registered stash: %s with label: %s, slots: %s, max_weight: %s, owner: %s", id, label, slots, max_weight, owner)
end

zutils.inventory.RegisterStash = zutils.inventory.registerStash -- Alias for compatibility

function zutils.inventory.forceOpenInventory(source, inv, id)
    assert(source, "Source must be specified")
    assert(inv, "Inventory must be specified")
    return inventory.forceOpenInventory(source, inv, id)
end

local function to_craft_table(t1)
    if type(t1) == "table" then
        if type(t1[1]) == "string" then
            t1 = { t1 }
        end
        local temp = {}
        for index, v in pairs(t1) do
            local item = v.item or v[1]
            local amount = v.amount or v.count or v[2] or 1
            local metadata = v.metadata or v[3]
            if item then
                temp[#temp + 1] = {
                    item,
                    amount,
                    metadata,
                }
            else
                printwarn("craft failed to convert at index %s", index)
                return false, ("craft failed to convert at index %s"):format(index)
            end
        end
        t1 = temp
    elseif type(t1) == "string" then
        t1 = { { t1, 1 } }
    end

    return t1
end

function zutils.inventory.craftItem(src, items, ingredients, options)
    printdb("----------------------------------------------------------")

    options        = options or {}
    local amount   = options.amount or 1
    local duration = options.duration or 0
    local label    = options.label or "Crafting..."

    local err
    items, err = to_craft_table(items)
    if not items then return false, err end
    ingredients, err = to_craft_table(ingredients)
    if not ingredients then return false, err end

    for _, t in ipairs({items, ingredients}) do
        for _, entry in ipairs(t) do
            if not zutils.inventory.doesItemExist(entry[1]) then
                zutils.logger(src, "exploit", (" tried to craft with an item that does not exist: %s"):format(entry[1]))
                return false, "Item does not exist: " .. entry[1]
            end
        end
    end

    local iterations     = duration == 0 and 1 or amount
    local multiplier     = duration == 0 and amount or 1

    for i = 1, iterations do

        for _, ing in ipairs(ingredients) do
            local required = (ing[2] == -1 and 1 or ing[2]) * multiplier
            if not zutils.inventory.hasItem(src, ing[1], required, ing[3]) then
                return false, "Missing ingredient: " .. ing[1]
            end
        end

        local available_weight = inventory.getAvailableWeight(src)
        local available_slots  = inventory.getAvailableSlots(src)

        local weightAfterRemoval = available_weight
        local slotsAfterRemoval  = available_slots

        for _, ing in ipairs(ingredients) do
            if ing[2] ~= -1 then
                local info = zutils.inventory.getItemInfo(ing[1])
                weightAfterRemoval += info.weight * ing[2] * multiplier
                slotsAfterRemoval  += multiplier
            end
        end

        local weightNeeded = 0
        local slotsNeeded  = 0

        for _, item in ipairs(items) do
            local info = zutils.inventory.getItemInfo(item[1])
            weightNeeded += info.weight * item[2] * multiplier
            slotsNeeded  += multiplier
        end

        if weightAfterRemoval < weightNeeded then
            zutils.notify(src, "error", "Not enough weight capacity")
            return false, "Not enough weight capacity"
        end

        if slotsAfterRemoval < slotsNeeded then
            zutils.notify(src, "error", "Not enough slots")
            return false, "Not enough slots"
        end

        if duration > 0 then
            local ok = zutils.progressBar(
                src,
                "crafting_" .. i,
                label .. " (" .. i .. "/" .. amount .. ")",
                duration,
                {
                    canCancel = true,
                    animation = options.animation or {
                        dict = "mini@repair",
                        anim = "fixing_a_ped",
                        flags = 49
                    },
                    controlDisables = options.controlDisables
                }
            )
            if not ok then
                return false, "Cancelled"
            end
        end

        for _, ing in ipairs(ingredients) do
            if ing[2] ~= -1 then
                local required = ing[2] * multiplier
                local ok, err = zutils.inventory.removeItem(src, ing[1], required, ing[3])
                if not ok then return false, err end
            end
        end

        for _, item in ipairs(items) do
            local give = item[2] * multiplier
            local ok, err = zutils.inventory.addItem(src, item[1], give, item[3])
            if not ok then return false, err end
        end
    end

    printdb("----------------------------------------------------------")
    return true
end

zutils.callback.register("zutils:inventory:registerPersonalStash:" .. zutils.name, function(source, id)
    local allowed_stash = personal_stashes[id]
    if not allowed_stash then
        printwarn("(src:%s, name:%s) tried to register a personal stash that does not exist: %s", source, GetPlayerName(source), id)
        zutils.logger(source, "exploit", "Tried to register a personal stash that does not exist: " .. id)
        return false
    end

    if allowed_stash.coords then
        local coords = allowed_stash.coords
        local player_coords = GetEntityCoords(GetPlayerPed(source))
        if #(coords - player_coords) > 5.0 then
            printwarn("(src:%s, name:%s) tried to register a personal stash at an invalid location: %s", source,
                GetPlayerName(source), id)
            zutils.logger(source, "exploit", "Tried to register a personal stash at an invalid location: " .. id)
            return false
        end
    end

    local playerId = zutils.player.getPlayerId(source)
    local new_id = id .. playerId
    zutils.inventory.registerStash(new_id, personal_stashes[id].label, personal_stashes[id].slots,
        personal_stashes[id].max_weight, playerId, personal_stashes[id].groups, personal_stashes[id].coords)
    return true
end)

function zutils.inventory.giveRandomItem(source, items, options)
    assert(source, "source must be specified")
    assert(type(items) == "table" and #items > 0, "items must be a non-empty table")

    options           = options or {}
    local repeats     = options.repeats or 0
    local minCount    = options.amount or 1
    local waitTime    = options.wait or 0
    local force       = options.force or false
    local maxAttempts = options.attempts or 10

    local function get_amount(cfgAmount)
        if type(cfgAmount) == "number" then
            return cfgAmount
        end
        local min = (cfgAmount and cfgAmount[1]) or 1
        local max = (cfgAmount and cfgAmount[2]) or min
        if min > max then min, max = max, min end
        return math.random(min, max)
    end

    local function roll_once()
        local pool = {}
        for _, cfg in ipairs(items) do
            local name = cfg.item
            if name and zutils.inventory.doesItemExist(name) then
                local chance = tonumber(cfg.chance) or 1.0
                if math.random() <= chance then
                    pool[#pool + 1] = cfg
                end
            else
                printwarn("Item does not exist in random roll: %s", tostring(name))
            end
        end

        local results = {}
        if #pool > 0 then
            for i = 1, math.min(minCount, #pool) do
                local choice = table.remove(pool, math.random(#pool))
                local qty = get_amount(choice.amount)
                local ok, err = options.debug or zutils.inventory.addItem(source, choice.item, qty, choice.metadata)
                if ok then
                    results[#results + 1] = { item = choice.item, amount = qty }
                    printdb("Gave %s x%s to %s", choice.item, qty, source)
                else
                    return results, err
                end
            end
        end

        return results
    end

    local final = {}
    local totalRolls = 1 + repeats
    local attempts = 0

    for roll = 1, totalRolls do
        local rollResults, err = {}, nil

        repeat
            attempts = attempts + 1
            rollResults, err = roll_once()
            if err then return final, err end
        until #rollResults > 0 or not force or attempts >= maxAttempts

        for i = 1, #rollResults do
            final[#final + 1] = rollResults[i]
        end

        if roll < totalRolls and waitTime > 0 then
            Wait(waitTime)
        end
    end

    return final
end

return zutils.inventory
