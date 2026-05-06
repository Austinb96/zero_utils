local billing = zutils.bridge_loader("billing")
if not billing then return end

zutils.billing = {}

function zutils.billing.open(data)
    return billing.open(data)
end

return zutils.billing
