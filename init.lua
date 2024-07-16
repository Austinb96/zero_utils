print('Loading zero_utils')
local resourceName = GetCurrentResourceName()
local zero_utils = 'zero_utils'
local LoadResourceFile = LoadResourceFile

require = function(path)
    local chunk = LoadResourceFile("zero_utils", path)
    if not chunk then return error(("failed to find module (%s)"):format(path)) end
    local fn, err = load(chunk, ('@@zero_utils/%s'):format(path))
    if not fn or err then return error(('\n^1Error importing module (%s): %s^0'):format(path, err), 3) end
    if not fn or err then return error(("failed to import module (%s) %s"):format(path, err)) end
    if printdb then printdb('imported module (%s)', path) end
    return fn()
end


if resourceName == zero_utils then 
    local debug_getinfo = debug.getinfo
    zutils = setmetatable({
        name = zero_utils,
        context = IsDuplicityVersion() and 'server' or 'client',
    }, {
        __newindex = function(self, name, fn)
            rawset(self, name, fn)
            if debug_getinfo(2, 'S').short_src:find('.*@zero%_utils.*') then
                exports(name, fn)
            end
        end
    })
    return
end



local function loadModule(self, module)
    local paths = {
        ("%s/imports/%s.lua"):format(self.context, module),
        ("shared/imports/%s.lua"):format(module)
    }
    
    for _, path in ipairs(paths) do
        local chunk = LoadResourceFile(zero_utils, path)
        if chunk then
            local fn, err = load(chunk, ('@@zero_utils/%s'):format(path))
            if fn then
                local result = fn()
                if result then
                    self[module] = result
                    return result
                end
            else
                printerr("Error importing module (%s): %s", path, err)
            end
        end
    end
end


local function call(self, index, ...)
    local module = rawget(self, index)

    if module then
        return module
    end
    -- Use custom require to attempt to load the module
    module = loadModule(self, index)
    
    if module then
        rawset(self, index, module)
        return module
    end

    -- Handle fallback for functions only
    if type(exports[index]) == "function" then
        local function method(...)
            return exports[index](nil, ...)
        end
        
        if not ... then
            rawset(self, index, method)
        end

        return method
    else
        printerr("Failed to load module (%s). Make sure function is correct!", index)
    end
end
zutils = setmetatable({
    name = resourceName,
    context = IsDuplicityVersion() and 'server' or 'client',
}, {
    __index = call,
    __call = call
})

if not Config.Bridge then Config.Bridge = {} end

require('/shared/printutils.lua')
require('/shared/utils.lua')
require(('/%s/utils.lua'):format(zutils.context))


printdb('Loaded zero_utils')

