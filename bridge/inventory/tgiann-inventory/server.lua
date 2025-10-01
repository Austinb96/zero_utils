-- TODO pretty sure this just doesn't work. idk whats going on in this one. look at later

local inventory = {}
local _useables = {}
local _exportName = ("%s.ox_useable"):format(GetCurrentResourceName())


function inventory.getItemInfo(item)
    local tg_item = exports["tgiann-inventory"]:Items(item)
    if not tg_item then
        return false, "Item does not exist: " .. item
    end
    return {
        name = tg_item.name,
        label = tg_item.label,
        description = tg_item.description,
        weight = tg_item.weight,
        stackable = tg_item.stackable,
        metadata = tg_item.metadata or {},
    }
end

function inventory.addItem(inv, item, count, metadata, slot, cb)
    return exports["tgiann-inventory"]:AddItem(inv, item, count, slot, metadata)
end

function inventory.removeItem(inv, item, count, metadata, slot, cb)
    return exports["tgiann-inventory"]:RemoveItem(inv, item, count, slot, metadata)
end

function inventory.canCarryItem(inv, item, count)
    if not exports["tgiann-inventory"]:CanCarryItem(inv, item, count) then
        return false, "Inventory Cannot carry: " .. item
    end
    return true
end

--TODO should not only be player
function inventory.hasItem(src, item, count, metadata)
    local PlayerInv = inventory.getPlayerInventory(src)
    local required = count or 1
    local found = 0

    for _, v in pairs(PlayerInv) do
        if v.name == item and (not metadata or v.metadata == metadata) then
            found = found + (v.count or v.amount or 1)
        end
    end

    return found >= required, (found >= required) and nil or ("You do not have enough: %s"):format(item)
end

function inventory.getPlayerInventory(src)
    local PlayerInv = exports["tgiann-inventory"]:GetPlayerItems(src)
    if not PlayerInv then
        return {}
    end
    return PlayerInv
end

function inventory.registerStash(id, label, slots, max_weight, owner, groups, coords)
    return ox_inventory:RegisterStash(id, label, slots, max_weight, owner, groups, coords)
end

function inventory.forceOpenInventory(source, inv, id)
    return ox_inventory:forceOpenInventory(source, inv, id)
end

function inventory.getAvailableWeight(inv, owner)
    local check_inv = ox_inventory:GetInventory(inv, owner)
    return check_inv and (check_inv.maxWeight -check_inv.weight) or 0
end

function inventory.getAvailableSlots(inv, owner)
    local check_inv = ox_inventory:GetInventory(inv, owner)
    return check_inv and (check_inv.slots - #check_inv.items) or 0
end

function inventory.registerShop(id, coords, label, items, society)
    return exports["tgiann-inventory"]:RegisterShop(id, items)
end

exports('tg_useable', function(source, item, slot)
    local name = type(item) == 'table' and (item.name or item?.name) or item
    local cb = name and _useables[name]
    if not cb then return false end

    -- normalize item table for callback parity with QB/ESX
    local itemTbl = type(item) == 'table' and item or { name = name, slot = slot }
    local ok, err = pcall(cb, source, itemTbl)
    if not ok then
        print(('[zutils:tg] useable "%s" errored: %s'):format(name, err))
        return false
    end
    return true
end)

local function _attachExport(name)
    local Items = exports.ox_inventory:Items()
    local def = (type(Items) == 'table' and Items[name]) or exports.ox_inventory:Items(name)
    if not def then
        print(('[zutils:tg] warn: item not found in ox items: %s'):format(name))
        return false
    end
    def.server = def.server or {}
    def.server.export = _exportName
    return true
end

function inventory.createUseableItem(itemName, cb)
    if type(itemName) ~= 'string' or type(cb) ~= 'function' then
        printerr('[zutils:ox] createUseableItem requires (string, function)')
        return false
    end
    if not _attachExport(itemName) then return false end
    _useables[itemName] = cb
    return true
end


return inventory