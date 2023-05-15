InstallItems = {
	QB = function(items)
		PrintUtils.PrintDebug("Installing Items")
		local AddItems = {}
		local exsistingItems = {}
		local count = 0
		for key, data in pairs(items) do
			if not QBCore.Shared.Items[key] then
				AddItems[key] = data
			else
				exsistingItems[#exsistingItems+1] = key
			end
			count += 1
		end
		if #exsistingItems == count then
			PrintUtils.PrintDebug("All Items allready exists")
			return
		end

		PrintUtils.PrintMultiWarning({
			{"Items found that allready Exists:"},
			{"%s", args = {exsistingItems}},
			{"If manualy added items or you are ok with current items installed then you can ignore this warning"}
		})

		local bool, message, errorItem = QBCore.Functions.AddItems(AddItems)
		if not bool then
			PrintUtils.PrintError("Item Install Failed!: %s. Please import manualy", message)
			for key, value in pairs(errorItem) do
				if key == 'name' then
					PrintUtils.PrintError("Item that failed: %s",value)
				end
			end
		else
			PrintUtils.PrintDebug("Item Install Successful")
		end
	end
}