RegisterNetEvent('QBCore:Client:UpdateObject', function()
	QBCore = exports['qb-core']:GetCoreObject()
	PrintUtils.PrintDebug("Client Core Updated")
end)

function ZeroUtils.GetDebugUtils(canDebug)
	local resource = GetInvokingResource()
	DebugUtils.SetCanDebug(resource, canDebug)
	return DebugUtils
end