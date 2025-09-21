local shop = zutils.bridge_loader("shop", "server")
if not shop then return end

zutils.shop = {}

function zutils.shop.registerShop(id, shopData)
    printdb(true, "Registering shop with ID: %s", id)
    printtable(shopData)
    shop.registerShop(id, shopData)
end

return zutils.shop