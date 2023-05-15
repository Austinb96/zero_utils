function ZeroUtils.OpenStash(stash)
	ZeroUtils.AssterType(stash, "string")
	Inventory[GetKey().Inventory].OpenStash(stash)
end

Inventory.QB.OpenStash = function(stash)
	if stash:find("-") then error("StashName cannot contain '-' for qb-inventory!: "..stash) end
	TriggerEvent("inventory:client:SetCurrentStash", stash)
	TriggerServerEvent("inventory:server:OpenInventory", "stash", stash)
end

Inventory.OX.OpenStash = function (stash)
	exports.ox_inventory:openInventory('stash', "Bakery_"..stash)
end