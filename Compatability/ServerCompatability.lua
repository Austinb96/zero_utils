--#region QB
Inventory.QB.AddItem = function (src,item,amount)
	local player = QBCore.Functions.GetPlayer(src)
	if not player.Functions.AddItem(item, amount or 1) then
		PrintUtils.PrintError("Item Does not Exist for Player: "..Color.Yellow..item)
		return false
	end
	return true
end

Inventory.QB.RemoveItem = function (src, item, amount)
	if not QBCore.Shared.Items[item] then
		PrintUtils.PrintError("Item Does not Exist"..Color.Yellow..item)
		return nil
	end
	local player = QBCore.Functions.GetPlayer(src)
	return player.Functions.RemoveItem(item, amount or 1)
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