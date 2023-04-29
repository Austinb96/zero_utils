function ZeroUtils.HasItem(scriptType, item, amount, src)
	if type(scriptType) ~= "string" then PrintUtils.PrintError("Type is not a string: " ..tostring(scriptType)) end
	if type(item) ~= "string" then PrintUtils.PrintError("Item is not a string: " ..tostring(item)) end
	if type(amount) ~= "number" then PrintUtils.PrintError("Amount is not a number: " ..tostring(amount)) end
	return Inventory[string.upper(scriptType)].HasItem(item, amount, src)
end
function ZeroUtils.ItemExists(scriptType, itemName)
	if type(scriptType) ~= "string" then PrintUtils.PrintError("Type is not a string: " ..tostring(scriptType)) end
	if type(itemName) ~= "string" then PrintUtils.PrintError("ItemName is not a string: " ..tostring(itemName)) end
	return Inventory[string.upper(scriptType)].ItemExists(itemName)
end

Inventory = {
	QB = {
		HasItem = function (item, amount, src)
			amount = amount or 1
			local playerData = GetPlayerData(src)
			local playerName = GetPlayerName(src) or "You"

			PrintUtils.PrintDebug("Checking "..Color.White..playerName..Color.Green.." for Item: "..Color.White..item.."-"..amount)
			local count = 0
			for _, itemData in pairs(playerData.items) do
				if itemData and (itemData.name == item) then
					PrintUtils.PrintDebug("Item Found!: "..Color.White..tostring(item)..Color.Green.." Slot: "..Color.White..itemData.slot..Color.Green.."("..Color.White..tostring(itemData.amount)..Color.Green..")")
					count += itemData.amount
				end
			end
			if count >= amount then
				PrintUtils.PrintDebug("Items Found!: "..Color.White..item.."("..count..")")
				return true
			else
				PrintUtils.PrintDebug("Item not Found: "..Color.White..tostring(item))
				return false
			end
		end,

		ItemExists = function (itemName)
			return QBCore.Shared.Items[itemName] ~= nil
		end
	},

	OX = {
		HasItem = function (item, amount, src)
			local playerName = GetPlayerName(src) or "You"
			PrintUtils.PrintDebug("Checking "..Color.White..playerName..Color.Green.." for Item: "..Color.White..item.."-"..amount)
			local count
			if src and RequireServer() then
				count = exports.ox_inventory:Search(src,'count', item)
			elseif RequireClient() then
				count = exports.ox_inventory:Search('count', item)
			end
			if count >= amount then
				PrintUtils.PrintDebug("Items Found!: "..Color.Yellow..item.."("..count..")")
				return true
			else
				PrintUtils.PrintDebug("Item not Found: "..Color.Yellow..tostring(item))
				return false
			end
		end,

		ItemExists = function (itemName)
			if exports.ox_inventory:Items()[itemName] then return true end

			return false
		end
	}
}