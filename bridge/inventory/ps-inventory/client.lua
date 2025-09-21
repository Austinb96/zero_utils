local inventory = {}

function inventory.getPlayerInventory()
    local PlayerInv = QBCore.Functions.GetPlayerData().items
    if not PlayerInv then
        return {}
    end
    return PlayerInv
end

return inventory