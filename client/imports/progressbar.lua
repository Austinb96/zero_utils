if not Config.Bridge.ProgressBar then
    if GetResourceState("qb-core"):find("start") then
        Config.Bridge.ProgressBar = "qb"
    elseif GetResourceState("ox_lib"):find("start") then
        Config.Bridge.ProgressBar = "ox"
    else
        printerr("No compatible resource found for Config.Bridge.ProgressBar please check your Config")
    end
end

zutils.progressBar = require(("client/bridge/%s/progressBar.lua"):format(Config.Bridge.ProgressBar)) or FailedSetup("progressBar")
return zutils.progressBar