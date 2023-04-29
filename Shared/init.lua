QBCore = exports['qb-core']:GetCoreObject()
local debug_getinfo = debug.getinfo
ZeroUtils = setmetatable({
    name = 'zero_utils',
    context = IsDuplicityVersion() and 'server' or 'client',
}, {
    __newindex = function(self, name, fn)
        rawset(self, name, fn)
        if debug_getinfo(2, 'S').short_src:find('.*@zero%_utils.*') then
            exports(name, fn)
        end
    end
})

function ZeroUtils.GetPrintUtils(canPrintDebug)
	local resource = GetInvokingResource()
	PrintUtils.SetCanPrint(resource, canPrintDebug)
	return PrintUtils
end

function RequireClient(skipthrowerr)
	if IsDuplicityVersion() then
		if not skipthrowerr then PrintUtils.PrintError("Called on Server when expected Client! Add src if not applied") end
		return false
	else return true end
end

function RequireServer(skipthrowerr)
	if not IsDuplicityVersion() then
		if not skipthrowerr then PrintUtils.PrintError("Called on Client when expected Server! remove src if applied") end
		return false
	else return true end
end