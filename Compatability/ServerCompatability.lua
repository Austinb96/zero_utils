--#region QB
Inventory.QB.AddItem = function (src,item,amount)
		local player = QBCore.Functions.GetPlayer(src)
		return player.Functions.AddItem(item, amount or 1)
	end

Inventory.QB.RemoveItem = function (src, item, amount)
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