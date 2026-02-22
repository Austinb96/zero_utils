local shop = zutils.bridge_loader("shop")
if not shop then return end

zutils.shop = {}

function zutils.shop.registerShop(id, shopData)
    shop.registerShop(id, shopData)
end

return zutils.shop