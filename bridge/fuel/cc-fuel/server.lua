local fuel = {}

function fuel.setFuel(vehicle, amount)
    Entity(vehicle).state:set('zutils:fuel', amount, true)
    return true
end

function fuel.getFuel(_)
    printwarn("server get fuel not supported for cc-fuel at this time")
    return false, "server get fuel not supported"
end

return fuel