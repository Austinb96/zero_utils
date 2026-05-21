local billing = {}

function billing.open(data)
    TriggerEvent("jim-payments:client:Charge", {
        job = data.job,
        gang = data.gang,
        coords = data.coords.xyz,
        img = data.img or "",
    })
end

return billing