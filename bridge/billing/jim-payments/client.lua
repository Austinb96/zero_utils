local billing = {}

function billing.open(data)
    TriggerEvent("jim-payments:client:Charge", {
        job = data.job,
        gang = data.gang,
        coords = data.coords.xyz,
        img = "<center><p><img src="..data.img.." width=100px></p>"
    })
end

return billing