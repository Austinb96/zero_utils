--   ___                          ___
--  (o o)                        (o o)
-- (  V  )     DO NOT TOUCH     (  V  )
-- --m-m--------------------------m-m--
-- -UNLESS YOU KNOW WHAT YOU ARE DOING-

--TODO add ox item support

ZeroUtils ={}
ItemSetup = {
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
				PrintUtils.PrintError("Item: "..Color.White..key.. " Failed to setup! Please Manualy add items", true)
			end
		end
		TriggerEvent('QBCore:Client:OnSharedUpdateMultiple', 'Items', updateItems)
	end,
}


--#region Menu
function ZeroUtils.OpenMenu(type, menuData, isDynamic)
	Menu[string.upper(type)].OpenMenu(menuData, isDynamic)
end

Menu.QB.OpenMenu = function (menuData)
	exports['qb-menu']:openMenu(menuData)
end

local OXMenuCache = {}
Menu.OX.OpenMenu = function (menuData, isDynamic)
	-- if not menuData.id then PrintUtils.PrintError("menuData.id not found for ox! please check that everything is done correcly", true) end
	if not OXMenuCache[menuData.id] or isDynamic then
		OXMenuCache[menuData.id] = true
		exports.ox_lib:registerContext(menuData)
	end

	exports.ox_lib:showContext(menuData.id)
end

function ConvertMenuToOX(menuData)
	local menu = {
		id = menuData.id,
		title = menuData.title,
		options = {}
	}

	for key, value in pairs(menuData) do
		if type(value) == "table" then
			menu.options[#menu.options+1] = value
		end
	end

	PrintUtils.PrintTable(menu)
	return menu
end
--#endregion