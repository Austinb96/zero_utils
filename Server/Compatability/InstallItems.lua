InstallItems = {
	QB = function(items)
		local AddItems = {}
		for key, data in pairs(items) do
			if not QBCore.Shared.Items[key] then
				AddItems[key] = data
			else
				PrintUtils.PrintWarning("Item allready exists: %s",key)
			end
		end

		local bool, message, errorItem = QBCore.Functions.AddItems(AddItems)
		if not bool then
			PrintUtils.PrintError("Item Import Failed!: %s. Please import manualy", message)
			for key, value in pairs(errorItem) do
				if key == 'name' then
					PrintUtils.PrintError("Item that failed: %s",value)
				end
			end
		else
			PrintUtils.PrintDebug("Item Import Successful")
		end
	end
}