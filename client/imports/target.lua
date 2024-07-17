if not Config.Bridge.Target then
    if GetResourceState("ox_target"):find("start") then
        Config.Bridge.Target = "ox"
    elseif GetResourceState("qb_target"):find("start") then
        Config.Bridge.Target = "qb"
    else
        printwarn("Config.Bridge.Target not set. Checking for started resources")
    end
end

zutils.target = require(("client/bridge/%s/target.lua"):format(string.upper(Config.Bridge.Target))) or FailedSetup("progressBar")

return zutils.target