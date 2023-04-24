--   ___                          ___
--  (o o)                        (o o)
-- (  V  )     DO NOT TOUCH     (  V  )
-- --m-m--------------------------m-m--
-- -UNLESS YOU KNOW WHAT YOU ARE DOING-
Notify = {
	--TODO Not Tested
	OKOK = function (message, type, src, title)
		if not src then	exports['okokNotify']:Alert(title, message, 6000, type)
		else TriggerClientEvent('okokNotify:Alert', src, title, message, 6000, type) end
	end,

	QB = function (message, type, src, title)
		if not src then	TriggerEvent("QBCore:Notify", message, type)
		else TriggerClientEvent("QBCore:Notify", src, message, type) end
	end,
	--TODO Not Tested
	T = function (message, type, src, title)
		if not src then exports['t-notify']:Custom({title = title, style = type, message = message, sound = true})
		else TriggerClientEvent('t-notify:client:Custom', src, { style = type, duration = 6000, title = title, message = message, sound = true, custom = true}) end
	end,
	--TODO Not Tested
	Infinity = function (message, type, src, title)
		if not src then TriggerEvent('infinity-notify:sendNotify', message, type)
		else TriggerClientEvent('infinity-notify:sendNotify', src, message, type) end
	end,
	--TODO Not Tested
	RR = function (message, type, src, title)
		if not src then exports.rr_uilib:Notify({msg = message, type = type, style = "dark", duration = 6000, position = "top-right", })
		else TriggerClientEvent("rr_uilib:Notify", src, {msg = message, type = type, style = "dark", duration = 6000, position = "top-right", }) end
	end,
	--TODO Not Tested
	RZ = function (message, type, src, title)
		if not src then exports['redutzu-notify']:Notify({title = title, message = message, type = type, duration = 6000 })
		else TriggerClientEvent('rz-notify:client:notify', source, { title = title, message = message, type = type, duration = 6000 }) end
	end,
	OX = function (message, type,src, title)
		print("OX Notifty Called")
		if src and RequireServer() then
			TriggerClientEvent('ox_lib:notify', src, {title = title, description = message, type = type, duration = 5000, position = 'center-right'})
		elseif RequireClient() then
			print("client notify called")
			exports.ox_lib:notify({title = title, description = message, type = type, duration = 5000, position = 'center-right'})
		end
	end,
}

Inventory = {
	QB = {
		HasItem = function (item, amount, src)
			amount = amount or 1
			local playerData
			local playerName
			if src and RequireServer() then
				playerData = exports['qb-core']:GetCoreObject().Players[src].PlayerData
				playerName = src..":"..GetPlayerName(src)
			elseif RequireClient() then
				playerData = exports['qb-core']:GetCoreObject().Functions.GetPlayerData()
				playerName = "You"
			end

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
			return exports['qb-core']:GetCoreObject().Shared.Items[itemName] ~= nil
		end
	},

	OX = {
		HasItem = function (item, amount, src)
			local count
			if src and RequireServer then
				count = ox_inventory:Search(src,'count', item)
			elseif RequireClient() then
				count = ox_inventory:Search('count', item)
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
			--TODO add Support for OX Item Checking
			if exports.ox_inventory:Items()[itemName] then return true end

			return false
		end
	}
}

Menu = {QB = {},OX={}
	-- --TODO add ox menu support
}

function GetCitizenID(src)
	local playerData
	if src and RequireServer() then
		playerData = exports['qb-core']:GetCoreObject().Functions.GetPlayer(src).PlayerData
	elseif RequireClient() then
		playerData = exports['qb-core']:GetCoreObject().Functions.GetPlayerData()
	end

	if playerData.citizenid then
		PrintUtils.PrintDebug("CitizenId found: "..Color.White..playerData.citizenid)
		return playerData.citizenid
	else
		local playerName = GetPlayerName(src or -1)
		PrintUtils.PrintWarning("citizenId Not found! Giving Player name instead:"..Color.White..playerName)
		return playerName
	end
end

function RequireClient()
	if IsDuplicityVersion() then
		PrintUtils.PrintError("Called on Server when expected Client! Add src if not applied", true)
	else
		return true
	end
end

function RequireServer()
	if not IsDuplicityVersion() then
		PrintUtils.PrintError("Called on Client when expected Server! remove src if applied", true)
	else
		return true
	end
end
