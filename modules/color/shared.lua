zutils.color = {}
local cachedrbg = {}


function zutils.color.rgbaFromHex(hex)
    hex = hex:gsub("#", "")
    if cachedrbg[hex] then return cachedrbg[hex] end
    
    local r, g, b = tonumber("0x" .. hex:sub(1, 2)), tonumber("0x" .. hex:sub(3, 4)), tonumber("0x" .. hex:sub(5, 6))
    local a = #hex > 6 and tonumber("0x" .. hex:sub(7, 8)) or 255
    cachedrbg[hex] = {
        r = r,
        g = g,
        b = b,
        a = a
    }
    
    return cachedrbg[hex]
end

return zutils.color
