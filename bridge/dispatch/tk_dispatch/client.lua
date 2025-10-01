local dispatch = {}

function dispatch.sendAlert(options)
        exports.tk_dispatch:addCall({
            title = options.name,
            code = options.tencode,
            priority = options.priority or ("Priority "..options.priority..""),
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
        })
end

return dispatch
