--   ___                          ___
--  (o o)                        (o o)
-- (  V  )     DO NOT TOUCH     (  V  )
-- --m-m--------------------------m-m--
-- -UNLESS YOU KNOW WHAT YOU ARE DOING-
Notify = {
	OKOK = function (message, type, src, title)
		if not src then	exports['okokNotify']:Alert(title, message, 6000, type)
		else TriggerClientEvent('okokNotify:Alert', src, title, message, 6000, type) end
	end,

	QB = function (message, type, src, title)
		if not src then	TriggerEvent("QBCore:Notify", message, type)
		else TriggerClientEvent("QBCore:Notify", src, message, type) end
	end,

	T = function (message, type, src, title)
		if not src then exports['t-notify']:Custom({title = title, style = type, message = message, sound = true})
		else TriggerClientEvent('t-notify:client:Custom', src, { style = type, duration = 6000, title = title, message = message, sound = true, custom = true}) end
	end,
	Infinity = function (src, message, type, title)
		if not src then TriggerEvent('infinity-notify:sendNotify', message, type)
		else TriggerClientEvent('infinity-notify:sendNotify', src, message, type) end
	end,
	RR = function (message, type, src, title)
		if not src then exports.rr_uilib:Notify({msg = message, type = type, style = "dark", duration = 6000, position = "top-right", })
		else TriggerClientEvent("rr_uilib:Notify", src, {msg = message, type = type, style = "dark", duration = 6000, position = "top-right", }) end
	end,
	RZ = function (message, type, src, title)
		if not src then exports['redutzu-notify']:Notify({title = title, message = message, type = type, duration = 6000 })
		else TriggerClientEvent('rz-notify:client:notify', source, { title = title, message = message, type = type, duration = 6000 }) end
	end,
	OX = function (message, type,src, title)
		if not src then	exports.ox_lib:notify({title = title, description = message, type = type or "success"})
		else exports.ox_lib:notify({title = title, description = message, type = type or "success"}) end
	end,
}

--TODO add support for OX inventory items
IfItemExists = {
	QB = function (itemName)
		return QBCore.Shared.Items[itemName] ~= nil
	end,
}

Inventory = {
	QB = {
		HasItem = function (item, amount, src)
			amount = amount or 1
			local playerData
			if src then
				playerData = QBCore.Players[src].PlayerData
			else
				playerData = QBCore.Functions.GetPlayerData()
			end

			local count = 0
			for _, itemData in pairs(playerData.items) do
				if itemData and (itemData.name == item) then
					PrintUtils.PrintDebug("Has Item: "..Color.Yellow..tostring(item)..Color.Violet.." Slot: "..Color.Yellow..itemData.slot..Color.Violet.."("..Color.Yellow..tostring(itemData.amount)..Color.Violet..")")
					count += itemData.amount
				end
			end
			if count >= amount then
				PrintUtils.PrintDebug("Item Found! Items Found: "..Color.Yellow..item.."("..count..")")
				return true
			else
				PrintUtils.PrintDebug("Item not Found: "..Color.Yellow..tostring(item))
				return false
			end
		end,
	},

	--TODO Not Tested
	OX = {
		HasItem = function (item, amount, src)
			src = src or PlayerPedId()
			local count = ox_inventory:Search(src,'count', item)
			if count >= amount then
				PrintUtils.PrintDebug("Item Found! Items Found: "..Color.Yellow..item.."("..count..")")
				return true
			else
				PrintUtils.PrintDebug("Item not Found: "..Color.Yellow..tostring(item))
				return false
			end
		end
	}
}




CreateThread(function ()
	if not Config then
		Wait(0)
	end
	if Config.Inventory == Inventory.QB then
		IfItemExists = IfItemExists.QB
	-- elseif Config.Inventory == Inventory.OX then
	-- 	IfItemExists = IfItemExists.OX
	end
end)
