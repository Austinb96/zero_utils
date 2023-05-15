InstallItems = {
	QB = function (itemData)
		if type(itemData) ~= "table" then
			PrintUtils.PrintError("itemData is not of type table") return
		end
		local updateItems = {}
		PrintUtils.PrintDebug("Add Item called")

		for key, data in pairs(itemData) do
			if not QBCore.Shared.Items[key] then
				if key ~= data.name then
					PrintUtils.PrintWarning("Item: %s Does Not match the Name: %s Please fix if this is not intended", key, data.name)
				end
				QBCore.Shared['Items'][key] = data
				updateItems[key] = data
				PrintUtils.PrintDebug("Item added: %s",QBCore.Shared.Items[key].name)
			else
				PrintUtils.PrintDebug("Item allready exists: %s",key)
			end

			if not QBCore.Shared.Items[key] then
				PrintUtils.PrintError("Item: %s ,Failed to setup! Please Manualy add items", key)
			end
		end
		TriggerEvent('QBCore:Client:OnSharedUpdateMultiple', 'Items', updateItems)
	end,
}