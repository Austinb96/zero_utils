function MakeBlip(blipData)
	local blip = AddBlipForCoord(blipData.coords)

	SetBlipAsShortRange(blip, true)
	SetBlipSprite(blip, blipData.sprite or 1)
	SetBlipColour(blip, blipData.color or 0)
	SetBlipScale(blip, blipData.scale or 0.7)
	SetBlipDisplay(blip, blipData.display or 6)
	if blipData.category then SetBlipCategory(blipData.category) end
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentString(tostring(blipData.label))
	EndTextCommandSetBlipName(blip)
	PrintUtils.PrintDebug("Blip Created for location: "..Color.White..tostring(blipData.label))
	return blip
end

