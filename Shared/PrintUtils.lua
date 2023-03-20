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

Color = {
    White = "^0",
    Red = "^1",
    Green = "^2",
    Yellow = "^3",
    DarkBlue = "^4",
    LightBlue = "^5",
    Violet = "^6",
}

--Example usage of PrintUtils.Print

--// Print with everything one color //--
-- PrintUtils.Print("Testing Print", PrintColors.Red)

--// Used to print MultiColoredLine //--
-- PrintUtils.Print(
--     {
--         {text = "Testing", color = PrintColors.Green },
--         {text = "Print", color = PrintColors.Violet }
--     }
-- )

--// Or you can print MultiColor like this //--
--PrintUtils.Print(PrintColors.Red .. "this will also work ".. PrintColors.DarkBlue .. "Just like this")
function PrintUtils.Print(text, color)
    local output = ''
    local isTextATable = type(text) == "table"
    if isTextATable then
        for _, item in pairs(text) do
            text = item.text
            color = item.color or Color.White
            output = output..color .. text .. " "
        end
    else
        color = color or Color.White
        output = color..text
    end

    print(output..Color.White)
end




--Used to print multiple lines of Print. eg.

-- PrintUtils.PrintMulti(
--     {
--         {{text = "Testing", color = PrintColors.Green},{text = "Multi", color = PrintColors.Yellow}},  //use this to print multiColored Lines
--         {text = "Print", color = PrintColors.Violet }      //next table item will print to new line
--     }
-- )
function PrintUtils.PrintMulti(table)
    for _, item in pairs(table) do
        if type(item.text) == "string" then
            PrintUtils.Print(item.text, item.color)
        else
            PrintUtils.Print(item)
        end
    end
end


function PrintUtils.PrintError(text)
    if not canPrint() then return end
    print(Color.Red.."Error: "..text..Color.White)
end

function PrintUtils.PrintWarning(text)
    if not canPrint() then return end
    print(Color.Yellow.."Warning!!: "..text..Color.White)
end

function PrintUtils.PrintDebug(text, color)
    color = color or Color.Violet
    if not canPrint() then return end
    PrintUtils.Print("Debug: "..text, color)
end

function PrintUtils.PrintMultiDebug(table)
    if not canPrint() then return end
    PrintUtils.PrintMulti(table)
end