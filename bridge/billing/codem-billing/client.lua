local billing = {}

function billing.open(data)
    TriggerEvent("codem-billing:client:OpenMenu")
end

return billing