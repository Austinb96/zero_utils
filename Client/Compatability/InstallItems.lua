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
					PrintUtils.PrintWarning({
						{"Item:"},
						{key, Color.White},
						{"Does Not match the Name:"},
						{data.name, Color.White},
						{"Please fix if this is not intended"}
					})
				end
				QBCore.Shared['Items'][key] = data
				updateItems[key] = data
				PrintUtils.PrintDebug("Item added: "..Color.White..tostring(QBCore.Shared.Items[key].name))
			else
				PrintUtils.PrintDebug("Item allready exists: "..Color.White..key)
			end

			if not QBCore.Shared.Items[key] then
				PrintUtils.PrintError("Item: "..Color.White..key.. " Failed to setup! Please Manualy add items")
			end
		end
		TriggerEvent('QBCore:Client:OnSharedUpdateMultiple', 'Items', updateItems)
	end,
}