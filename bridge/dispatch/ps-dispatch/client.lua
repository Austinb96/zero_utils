local dispatch = {}

function dispatch.sendAlert(options)
    local dispatchData = {
            title = options.name,
            codeName = options.name,
            code = options.tencode,
            priority = options.priority or (tostring("Priority "..options.priority.."")),
            message = options.message,
            coords = options.coords or GetEntityCoords(PlayerPedId()),
            showLocation = options.showLocation or true,
            showDirection = options.showDirection or true,
            showGender = options.showGender or true,
            showVehicle = options.showVehicle or true,
            platePercentage = options.platePercentage or 50,
            showWeapon = options.showWeapon or true,
            takePhoto = options.takePhoto or true,
            coordsOffset = options.coordsOffset or 20,
            removeTime = options.removeTime or 1000 * 60 * 10,
            showTime = options.showTime or 10000,
            flash = options.flash or false,
            showNumber = options.showNumber or false,
            blip = {
                color = options.blipColor or 3,
                sprite = options.blipSprite or 110,
                scale = options.blipScale or 1.0,
                radius = options.blipRadius or 40.0,
            },
            jobs = options.jobs or {},
        }
            local dispatchData = {
                message = options.message or "", -- Title of the alert
                codeName = options.dispatchCode or "NONE", -- Unique name for each alert
                code = options.code or '10-80', -- Code that is displayed before the title
                icon = options.icon or 'fas fa-question', -- Icon that is displaed after the title
                priority = options.priority or 2, -- Changes color of the alert ( 1 = red, 2 = default )
                coords = options.coords or GetEntityCoords(PlayerPedId()), -- Coords of the player
                gender = options.showGender or true, -- Gender of the player
                street = GetStreetAndZone(GetEntityCoords(PlayerPedId())), -- Street of the player
                camId = options.camId or nil, -- Cam ID ( for heists )
                color = options.firstColor or nil, -- Color of the vehicle
                callsign = options.callsign or nil, -- Callsigns
                name = options.name or nil, -- Name of either officer/ems or a player
                vehicle = options.model or nil, -- Vehicle name
                plate = options.plate or nil, -- Vehicle plate
                alertTime = options.alertTime or nil, -- How long it stays on the screen in seconds
                doorCount = options.doorCount or nil, -- How many doors on vehicle
                automaticGunfire = options.automaticGunfire or false, -- Automatic Gun or not
                alert = {
                    radius = options.radius or 0, -- Radius around the blip
                    sprite = options.sprite or 1, -- Sprite of the blip
                    color = options.color or 1, -- Color of the blip
                    scale = options.scale or 0.5, -- Scale of the blip
                    length = options.length or 2, -- How long it stays on the map
                    sound = options.sound or "Lose_1st", -- Alert sound
                    sound2 = options.sound2 or "GTAO_FM_Events_Soundset", -- Alert sound
                    offset = options.offset or false, -- Blip / radius offset
                    flash = options.flash or false -- Blip flash
                },
                jobs = options.jobs or { 'leo' },
            }

        TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end

return dispatch
