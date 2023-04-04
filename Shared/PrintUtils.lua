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

function PrintUtils.PrintMulti(table)
	local text
	local color
	local prefix
    for _, item in pairs(table) do
		text = item.text or item[1] or item
		color = item.color or item[2]
		prefix = item.prefix or item[3]
		if type(text) == "table" then
			for _, text2 in pairs(text) do
				PrintUtils.Print(text2, color, prefix)
			end
		else
			PrintUtils.Print(text, color, prefix)
		end
    end
end


function PrintUtils.PrintError(text)
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
end

function PrintUtils.PrintWarning(text)
    if not canPrint() then return end
    PrintUtils.Print(text, Color.Yellow,"Warning!!: ")
end

function PrintUtils.PrintMultiWarning(table)
    if not canPrint() then return end
    PrintUtils.PrintMulti(table, Color.Yellow, "Warning: ")
end

function PrintUtils.PrintDebug(text)
    if not canPrint() then return end
    PrintUtils.Print(text, Color.Violet,"Debug: ")
end

function PrintUtils.PrintMultiDebug(table)
    if not canPrint() then return end
    PrintUtils.PrintMulti(table, Color.Violet, "Debug: ")
end

function PrintUtils.PrintErrorDebug(text)
    if not canPrint() then return end
	PrintUtils.PrintError(text)
end