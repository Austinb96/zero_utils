--#region QB
Inventory.QB.AddItem = function (src,item,amount)
	local player = QBCore.Functions.GetPlayer(src)
	if not player.Functions.AddItem(item, amount or 1) then
		PrintUtils.PrintError("Item Does not Exist for Player: "..Color.White..item)
		return false
	end
	return true
end

Inventory.QB.RemoveItem = function (src, item, amount)
	if not QBCore.Shared.Items[item] then
		PrintUtils.PrintError("Item Does not Exist"..Color.White..item)
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


ItemSetup = {
	AddItems = function(items)
		local AddItems = {}
		for key, data in pairs(items) do
			if not QBCore.Shared.Items[key] then
				AddItems[key] = data
			else
				PrintUtils.PrintWarning("Item allready exists: "..Color.White..key)
			end
		end

		local bool, message, errorItem = QBCore.Functions.AddItems(AddItems)
		if not bool then
			PrintUtils.PrintError("Item Import Failed!: ("..message.."). Please import manualy")
			for key, value in pairs(errorItem) do
				if key == 'name' then
					PrintUtils.PrintError("Item that failed: "..Color.White..value, true)
				end
			end
		else
			PrintUtils.PrintDebug("Item Import Successful")
		end
	end
}
--#endregion