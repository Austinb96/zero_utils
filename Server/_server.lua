RegisterNetEvent('QBCore:Server:UpdateObject',function()
	if source ~= '' then return false end
	QBCore = exports['qb-core']:GetCoreObject()
	PrintUtils.PrintDebug("Server Core was Updated")
end)