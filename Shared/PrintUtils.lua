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
function PrintUtils.Print(text, color, prefix)
	color = color or Color.White
	prefix = prefix or ''
    local output = ''
	local defaultColor = color
    if type(text) == "table" then
        for _, item in pairs(text) do
            text = item.text or item[1] or item
            color = item.color or item[2] or defaultColor
            output = output..color .. text .. " "
        end
    else
        output = color..text
    end
    print(defaultColor .. prefix .. output..Color.White)
end


--Used to print multiple lines of Print. eg.

-- PrintUtils.PrintMulti(
--     {
--         {{text = "Testing", color = PrintColors.Green},{text = "Multi", color = PrintColors.Yellow}},  //use this to print multiColored Lines
--         {text = "Print", color = PrintColors.Violet }      //next table item will print to new line
--     }
-- )

function PrintUtils.PrintMulti(table, color, prefix)
	local text
    for _, item in pairs(table) do
		text = item.text or item[1] or item
		color = color or item.color or item[2] or Color.White
		prefix = prefix or item.prefix or item[3] or ""
		if type(text) == "table" then
			for _, text2 in pairs(text) do
				PrintUtils.Print(text2, color, prefix)
			end
		else
			PrintUtils.Print(text, color, prefix)
		end
    end
end

function PrintUtils.PrintError(text, stopexe)
    local trace = debug.traceback(nil,2)
	local traceLines = {}
    for line in trace:gmatch("[^\r\n]+") do
        table.insert(traceLines, line)
    end
	PrintUtils.PrintMulti(
		{
			{text, Color.Red, "Error: "},
			{traceLines, Color.Red, "Error: "},
		}
	)
	if stopexe then error("Critical error! Stoping Execution!", 2) end
end

function PrintUtils.PrintWarning(text, showDebug)
    if showDebug or not canPrint() then return end
    PrintUtils.Print(text, Color.Yellow,"Warning!!: ")
end

function PrintUtils.PrintMultiWarning(table, showDebug)
    if showDebug or not canPrint() then return end
    PrintUtils.PrintMulti(table, Color.Yellow, "Warning: ")
end

function PrintUtils.PrintDebug(text, showDebug)
    if not showDebug or not canPrint() then return end
    PrintUtils.Print(text, Color.Green, Color.Violet.."Debug: ")
end

function PrintUtils.PrintMultiDebug(table, showDebug)
    if not showDebug or not canPrint() then return end
    PrintUtils.PrintMulti(table, Color.Green, "Debug: ")
end

function PrintUtils.PrintTable(table, indent)
    indent = indent or 0
    for k, v in pairs(table) do
        local formatting = string.rep("  ", indent) .. k .. ": "
        if type(v) == "table" then
            print(formatting)
            PrintUtils.PrintTable(v, indent+1)
        else
            print(formatting .. tostring(v))
        end
    end
end
