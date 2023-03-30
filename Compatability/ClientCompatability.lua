--   ___                          ___
--  (o o)                        (o o)
-- (  V  )     DO NOT TOUCH     (  V  )
-- --m-m--------------------------m-m--
-- -UNLESS YOU KNOW WHAT YOU ARE DOING-
ItemSetup = {
	AddItems = function (itemData)
		if type(itemData) ~= "table" then
			PrintUtils.PrintError("itemData is not of type table") return
		end
		local updateItems = {}
		PrintUtils.PrintDebug("Add Item called")

		for key, data in pairs(itemData) do
			if not QBCore.Shared.Items[key] then
				QBCore.Shared['Items'][key] = data
				updateItems[key] = data
				PrintUtils.PrintDebug("Item added: "..Color.Yellow..tostring(QBCore.Shared.Items[key].name))
			else
				PrintUtils.PrintDebug("Item allready exists: "..Color.White..key)
			end

			if not QBCore.Shared.Items[key] then
				PrintUtils.PrintError("Item Failed to setup! Please Manualy add items")
			end
		end
		TriggerEvent('QBCore:Client:OnSharedUpdateMultiple', 'Items', updateItems)
	end,
}