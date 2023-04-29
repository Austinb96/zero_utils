InstallItems = {
	QB = function(items)
		local AddItems = {}
		for key, data in pairs(items) do
			if not QBCore.Shared.Items[key] then
				AddItems[key] = data
			else
				PrintUtils.PrintWarning("Item allready exists: "..Color.White..key)
			end
		end

		local bool, message, errorItem = QBCore.Functions.AddItems(AddItems)
		if not bool then
			PrintUtils.PrintError("Item Import Failed!: ("..message.."). Please import manualy")
			for key, value in pairs(errorItem) do
				if key == 'name' then
					PrintUtils.PrintError("Item that failed: "..Color.White..value)
				end
			end
		else
			PrintUtils.PrintDebug("Item Import Successful")
		end
	end
}