local function setupTargets(netid, options)
    if not options.target then options.target = {} end
    local targetOptions = {}
    if options.target.targetOptions then
        for i = 1, #options.target.targetOptions do
            targetOptions[#targetOptions+1] = options.target.targetOptions[i]
        end
    end
    if options.target.onPickupEvent or options.item then
        targetOptions[#targetOptions+1] = {
            label = "Pick Up",
            icon = "fas fa-hand-paper",
            distance = 2.0,
            groups = options.target.groups,
            onSelect = function()
                zutils.progressBar("pickup_item", "Picking up", options.pickupTime or 1000, {
                    useWhileDead = false,
                    canCancel = true,
                    controlDisables = {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    },
                    animation = {
                        animDict = options.anim.dict,
                        anim = options.anim.anim,
                        flags = options.anim.flag or 49,
                    },
                    onFinish = function()
                        local result = zutils.callback.await("zutils:server:pickupItem",nil, netid, options.item)
                        if not result then return end
                        if options.target.onPickupEvent then
                            TriggerEvent(options.target.onPickupEvent, netid)
                        end
                    end,
                })
            end
        }
    end
    printdb("Setting up prop target for %s", netid)
    zutils.target.AddNetIDTarget(netid, targetOptions)
end

RegisterNetEvent('zero_utils:client:SetupPropTarget', function(netid, options)
    setupTargets(netid, options)
end)

CreateThread(function()
    while not LocalPlayer.state.isLoggedIn do Wait(1000) end
    printdb("Getting Current Targets")
    local targets = zutils.callback.await("zutils:server:getSpawnedItems")
    if not targets then return end
    for netid, options in pairs(targets) do
        setupTargets(netid, options)
    end
end)