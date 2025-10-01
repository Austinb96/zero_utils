local fuel = {}

function fuel.setFuel(veh, amount)
    exports["cc-fuel"]:SetFuel(veh, amount)
    return true
end

function fuel.getFuel(veh)
    return exports["cc-fuel"]:GetFuel(veh)
end

return fuel