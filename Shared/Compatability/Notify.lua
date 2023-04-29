function ZeroUtils.Notify(key,data)
	if type(key) ~= "string" then PrintUtils.PrintError("Key is not a string! "..tostring(key))end
	if type(data) ~= "table" then PrintUtils.PrintError("Data is not a table!"..tostring(data))end

	Notify[string.upper(key)](data)
end

Notify = {
	--TODO Not Tested
	OKOK = function (data)
		if not data.src then exports['okokNotify']:Alert(data.title, data.message, data.duration or 6000, data.type)
		else TriggerClientEvent('okokNotify:Alert', data.src, data.title, data.message, data.duration or 6000, data.type) end
	end,

	QB = function (data)
		if not data.src then TriggerEvent("QBCore:Notify", data.message, data.type)
		else TriggerClientEvent("QBCore:Notify", data.src, data.message, data.type) end
	end,
	--TODO Not Tested
	T = function (data)
		if not data.src then exports['t-notify']:Custom({title = data.title, style = data.type, message = data.message, sound = true})
		else TriggerClientEvent('t-notify:client:Custom', data.src, { style = data.type, duration = data.duration or 6000, title = data.title, message = data.message, sound = true, custom = true}) end
	end,
	--TODO Not Tested
	Infinity = function (data)
		if not data.src then TriggerEvent('infinity-notify:sendNotify', data.message, data.type)
		else TriggerClientEvent('infinity-notify:sendNotify', data.src, data.message, data.type) end
	end,
	--TODO Not Tested
	RR = function (data)
		if not data.src then exports.rr_uilib:Notify({msg = data.message, type = data.type, style = "dark", duration = data.duration or 6000, position = "top-right", })
		else TriggerClientEvent("rr_uilib:Notify", data.src, {msg = data.message, type = data.type, style = "dark", duration = data.duration or 6000, position = "top-right", }) end
	end,
	--TODO Not Tested
	RZ = function (data)
		if not data.src then exports['redutzu-notify']:Notify({title = data.title, message = data.message, type = data.type, duration = data.duration or 6000 })
		else TriggerClientEvent('rz-notify:client:notify', source, { title = data.title, message = data.message, type = data.type, duration = data.duration or 6000 }) end
	end,
	OX = function (data)
		if data.src and RequireServer() then
			TriggerClientEvent('ox_lib:notify', data.src, {title = data.title, description = data.message, type = data.type, duration = data.duration or 5000, position = data.position or 'center-right'})
		elseif RequireClient() then
			exports.ox_lib:notify({title = data.title, description = data.message, type = data.type, duration = data.duration or 5000, position = data.position or 'center-right'})
		end
	end,
}