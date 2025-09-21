local fuel = {}

function fuel.setFuel(vehicle, amount)
    Entity(vehicle).state:set('fuel', amount, true)
    return true
end

function fuel.getFuel(vehicle)
    return Entity(vehicle).state.fuel or 0
end

return fuel