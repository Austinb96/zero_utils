function ZeroUtils.HasItem(item, amount, src)
	if type(item) ~= "string" then PrintUtils.PrintError("Item is not a string: " ..tostring(item)) end
	if type(amount) ~= "number" then
		local newAmount = tonumber(amount)
		if not newAmount then
			PrintUtils.PrintError("Amount is not a number: " ..tostring(amount)..":"..type(amount))
		end

		amount = newAmount
	end
	return Inventory[GetKey().Inventory].HasItem(item, amount, src)
end

function ZeroUtils.ItemExists(itemName)
	if type(itemName) ~= "string" then PrintUtils.PrintError("ItemName is not a string: " ..tostring(itemName)) end
	local itemExists, item = Inventory[GetKey().Inventory].ItemExists(itemName)
	if itemExists then
		return itemExists, item
	else
		PrintUtils.PrintError("Item Not Found: %s",itemName)
	end
end

Inventory = {
	QB = {
		HasItem = function (item, amount, src)
			amount = amount or 1
			local playerData = GetPlayerData(src)
			local playerName = (src and GetPlayerName(src)) or "You"

			PrintUtils.PrintDebug("Checking %s for Item: %s(%s)",playerName,item,amount)
			local count = 0
			for _, itemData in pairs(playerData.items) do
				if itemData and (itemData.name == item) then
					PrintUtils.PrintDebug("Item Found!: %s Slot: %s(%s)",item,itemData.slot,itemData.amount)
					count += itemData.amount
				end
			end
			if count >= amount then
				PrintUtils.PrintDebug("Items Found!: %s(%s)", item, count)
				return true
			else
				PrintUtils.PrintDebug("Item not Found: %s",item)
				return false
			end
		end,

		ItemExists = function (itemName)
			return QBCore.Shared.Items[itemName] ~= nil , QBCore.Shared.Items[itemName]
		end,
	},

	OX = {
		HasItem = function (item, amount, src)
			local playerName = (src and GetPlayerName(src)) or "You"
			PrintUtils.PrintDebug("Checking %s for Item: %s(%s)",playerName,item,amount)
			local count
			if src and RequireServer() then
				count = exports.ox_inventory:Search(src,'count', item)
			elseif RequireClient() then
				count = exports.ox_inventory:Search('count', item)
			end
			if count >= amount then
				PrintUtils.PrintDebug("Items Found!: %s (%s)", item, count)
				return true
			else
				PrintUtils.PrintDebug("Item not Found: %s",item)
				return false
			end
		end,

		ItemExists = function (itemName)
			if exports.ox_inventory:Items()[itemName] then
				return true and exports.ox_inventory:Items()[itemName]
			end
			return false
		end
	}
}