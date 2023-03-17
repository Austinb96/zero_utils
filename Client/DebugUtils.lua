DebugUtils = {}

local canDebug = function ()
    if Config.Debuging.Debug then
        return true
    end
    if DevConfig and DevConfig.Debug then
        return true
    end
    return false
end


local debugObjects = {
    entity = {},
    static = {}
}



local draw = false
--TODO optimize for when you have to many objects to draw
local function StartDrawing()
    CreateThread(function ()
        local pos
        local forwardVector
        while canDebug() and draw do
            if next(debugObjects.entity) == nil and next(debugObjects.static) == nil then
                PrintUtils.PrintDebug("No More DrawObjects")
                draw = false
            end
            for type, objectsOfType in pairs(debugObjects) do
                for index, drawObject in pairs(objectsOfType) do
                    if(type == "entity") then
                        if DoesEntityExist(drawObject.obj) then
                            pos = GetEntityCoords(drawObject.obj)
                            forwardVector = GetEntityForwardVector(drawObject.obj)
                            forwardVector = vector3(forwardVector.x, forwardVector.y, drawObject.offset.y)
                            pos = pos + MultiplyVec3Vec2(forwardVector, drawObject.offset, true)
                        else
                            debugObjects[type][drawObject.obj] = nil
                            pos = nil
                        end
                    else
                        pos = drawObject.obj + drawObject.offset
                    end

                    if pos then
                        DrawMarker(1, pos.x, pos.y, pos.z + 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 0, 0, 200, false, true, 2, nil, nil, false)
                    end

                end
            end
            Wait(0)
        end
    end)
end


function DebugUtils.DrawMarker(obj, offset)
    offset = offset or vector3(0,0,0)
    PrintUtils.PrintDebug("Draw Marker for: "..obj.." with offset: "..offset)
    if type(obj) == "number" then
        debugObjects.entity[obj] = {obj = obj, offset = offset}
    elseif type(obj) == "vector3" then
        print(obj)
        debugObjects.static[obj] = {obj = obj, offset = offset}
    else
        PrintUtils.PrintError("Trying to add wrong type to drawMarker: "..tostring(obj))
    end

    if draw == false then
        PrintUtils.PrintDebug("Starting Drawing!")
        draw = true
        StartDrawing()
    end
end




