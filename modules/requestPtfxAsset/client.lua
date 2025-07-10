function zutils.requestPtfxAsset(ptFxName, timeout)
    if HasNamedPtfxAssetLoaded(ptFxName) then return true end
    RequestNamedPtfxAsset(ptFxName)
    return Await(function()
        return HasNamedPtfxAssetLoaded(ptFxName)
    end, {"Ptfx Asset Failed to Load %s", ptFxName}, timeout or 10000)
end

return zutils.requestPtfxAsset
