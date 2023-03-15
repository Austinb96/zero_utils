PrintUtils = {}

local canPrint = function ()
    if Config.Debuging.PrintDebug then
        return true
    end
    if DevConfig and DevConfig.PrintDebug then
        return true
    end
    return false
end

PrintColors = {
    White = "^0",
    Red = "^1",
    Green = "^2",
    Yellow = "^3",
    DarkBlue = "^4",
    LightBlue = "^5",
    Violet = "^6",
}

function PrintUtils.Print(text, color)
    color = color or PrintColors.White
    print(color..text..PrintColors.White)
end

function PrintUtils.PrintMulti(table)
    local output = ''
    local text
    local color
    for _, item in pairs(table) do
        text = item.text
        color = item.color or PrintColors.White
        output = output..color .. text .. " "
    end

    output = output..PrintColors.White

    print(output)
end

function PrintUtils.PrintError(text)
    if not canPrint() then return end
    print(PrintColors.Red.."Error: "..text..PrintColors.White)
end

function PrintUtils.PrintWarning(text)
    if not canPrint() then return end
    print(PrintColors.Yellow.."Warning!!: "..text..PrintColors.White)
end

function PrintUtils.PrintDebug(text, color)
    color = color or PrintColors.Violet
    if not canPrint() then return end
    PrintUtils.Print(text, color)
end

function PrintUtils.PrintMultiDebug(table)
    if not canPrint() then return end
    PrintUtils.PrintMulti(table)
end