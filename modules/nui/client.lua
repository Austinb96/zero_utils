zutils.nui = {}

local _isNuiFocused = IsNuiFocused
local _disableControlAction = DisableControlAction
local _setPlayerCanDoDriveBy = SetPlayerCanDoDriveBy
local _disablePlayerFiring = DisablePlayerFiring

local function Result(result, err)
    if result == nil and err == nil then
        result = "ok"
    end
    return {
        result = result,
        err = err
    }
end

function zutils.nui.focus(focus, cursor, keep_inputs, stop_basic_inputs)
    SetNuiFocus(focus, cursor ~= nil and cursor or focus)
    if keep_inputs ~= nil then
        SetNuiFocusKeepInput(keep_inputs)
        if stop_basic_inputs then
            CreateThread(function()
                while _isNuiFocused() do
                    _disableControlAction(0, 1, true)
                    _disableControlAction(0, 2, true)
                    _disableControlAction(0, 4, true)
                    _disableControlAction(0, 6, true)
                    _disableControlAction(0, 24, true)
                    _disableControlAction(0, 25, true)
                    _disableControlAction(0, 200, true)
                    _disableControlAction(0, 202, true)
                    _disableControlAction(0, 140, true)
                    _setPlayerCanDoDriveBy(zutils.cache.ped, false)
                    _disablePlayerFiring(zutils.cache.ped, true)
                    Wait(0)
                end
            end)
        end
    end
end

function zutils.nui.registerCallback(action, cb)
    if not cb then return end
    RegisterNUICallback(action, function(data, nuiCb)
        local result, err = cb(data)
        nuiCb(Result(result, err))
    end)
end

function zutils.nui.send(action, data)
    SendNUIMessage({
        action = action,
        data = data
    })
end

return zutils.nui
