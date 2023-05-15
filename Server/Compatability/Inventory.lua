function ZeroUtils.RemoveItem(src, item, amount)
	Inventory[GetKey().Inventory].RemoveItem(src, item, amount)
end
function ZeroUtils.AddItem(src, item, amount)
	Inventory[GetKey().Inventory].AddItem(src, item, amount)
end

--#region QB
Inventory.QB.AddItem = function (src, item, amount)
	if type(item) ~= 'string' then
		PrintUtils.PrintError('Item is not a string. Item: %s',tostring(item))
	end
	local player = QBCore.Functions.GetPlayer(src)
	if not player.Functions.AddItem(item, amount or 1) then
		PrintUtils.PrintError("Item Does not Exist for Player: %s",item)
		return false
	end
	TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "add")
	PrintUtils.PrintDebug("Giving Player: %s:%s - %s(%s)", src, GetPlayerName(src), QBCore.Shared.Items[item].label,amount)
	return true
end

Inventory.QB.RemoveItem = function (src, item, amount)
	if type(item) ~= 'string' then
		PrintUtils.PrintError('Item is not a string. Item: %s',item)
	end
	if not QBCore.Shared.Items[item] then
		PrintUtils.PrintError("Item Does not Exist: %s",item)
		return nil
	end
	local player = QBCore.Functions.GetPlayer(src)
	if player.Functions.RemoveItem(item, amount or 1) then
		TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "remove")
		PrintUtils.PrintDebug("Taking from Player: %s:%s - %s(%s)", src, GetPlayerName(src), QBCore.Shared.Items[item].label,amount)
	else
		PrintUtils.PrintWarning("%s:%s Does not have the item: %s", src, GetPlayerName(src), Color.White..QBCore.Shared.Items[item].label, amount)
	end
end
--#endregion

--#region OX
Inventory.OX.AddItem = function (src,item,amount)
	return ox_inventory:AddItem(src,item,amount)
	end

Inventory.OX.RemoveItem = function (src, item, amount)
	return ox_inventory:RemoveItem(src,item,amount)
end
--#endregion