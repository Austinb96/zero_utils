local OXMenuCache = {}

function ZeroUtils.OpenMenu(menuData, isDynamic)
	Menu[GetKey().Inventory].OpenMenu(menuData, isDynamic)
end

Menu = {
	QB = {
		OpenMenu = function (menuData)
			exports['qb-menu']:openMenu(menuData)
		end
	},
	OX = {
		OpenMenu = function(menuData, isDynamic)
			if not OXMenuCache[menuData.id] or isDynamic then
				OXMenuCache[menuData.id] = true
				exports.ox_lib:registerContext(menuData)
			end
			exports.ox_lib:showContext(menuData.id)
		end
	}
}