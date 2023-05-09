PrintUtils = {}
local canPrint = {}

local function CanPrintDebug()
	local resource = GetInvokingResource() or 'utils'
	return canPrint[resource] or false
end
function PrintUtils.SetCanPrint(resource, canPrintDebug)
	resource = resource or 'utils'
	canPrint[resource] = canPrintDebug
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

function PrintUtils.GetColors()
	return Color
end

--- @alias ColorTypes '^0' | '^1' | '^2' | '^3' | '^4' | '^5' | '^6'

--- - `text` (`string|table`)
--- - (Optional)`color` (`string | Color`): color for entire print line
--- - (Optional)`prefix` (`string`): Prefix for print line
--- -
---@param text string|table
---@param color? ColorTypes
---@param prefix? string
---@usage
--- Example 1: PrintUtils.Print("Hello", Color.Red)
--- -
---@usage
--- Example 2: PrintUtils.Print({"Hello", Color.Red}, nil, "ExamplePrefix:")
--- -
---@usage
--- Example 3: PrintUtils.Print({{"Hello"},{"World", Color.Yellow}}, Color.Red)
function PrintUtils.Print(text, color, prefix)
	color = color or Color.White
	prefix = prefix.." " or ''
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

--- Will print text to multiple lines
--- - (Optional)`color` (`string | Color`): color for entire print lines
--- - (Optional)`prefix` (`string`): Prefix for print lines
--- -
---@param table table
---@param color? ColorTypes
---@param prefix? string
---@usage
--- Example 1: PrintUtils.PrintMulti({"Hello", Color.Red}, nil, "ExamplePrefix:")
--- -
---@usage
--- Example 2: PrintUtils.PrintMulti({{"Hello"},{"World", Color.Yellow}}, Color.Red)
function PrintUtils.PrintMulti(table, color, prefix)
	if type(table) ~= "table" then PrintUtils.PrintError("Expected table got: "..Color.white..type(table)..":"..tostring(table))end
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

--- Will print out red text with "Error:" prefix along with a trace
--- - Does not stop execution
--- -
---@param text string
---@usage
--- Example 1: PrintUtils.PrintError("This is an Error")
function PrintUtils.PrintError(text)
    local trace = Citizen.InvokeNative(`FORMAT_STACK_TRACE` & 0xFFFFFFFF, nil, 1, Citizen.ResultAsString())
	local traceLines = {}
    for line in trace:gmatch("[^\r\n]+") do
        table.insert(traceLines, line)
    end

	PrintUtils.PrintMulti(
		{
			{text, Color.Red, "Error: "},
			{traceLines, Color.Red, "Error:"},
		}
	)
end


--- Print Warning in Yellow text and "Warning!:" prefix
--- - (Optional)`showIf` (`boolean`): boolean to pass in if you want the option to hide
--- -
---@param text string
---@param showIf boolean
---@usage
--- Example 1: PrintUtils.PrintWarning("This is an Warning!")
function PrintUtils.PrintWarning(text, showIf)
    if showIf and showIf == false then return end
    PrintUtils.Print(text, Color.Yellow,"Warning!:")
end

--- Print Warning in Yellow text and "Warning!:" prefix for multiple lines
--- - (Optional)`showIf` (`boolean`): boolean to pass in if you want the option to hide
--- -
---@param table string
---@param showIf boolean
---@see PrintUtils.PrintMulti
function PrintUtils.PrintMultiWarning(table, showIf)
    if showIf and showIf == false then return end
    PrintUtils.PrintMulti(table, Color.Yellow, "Warning!:")
end


--- Print Debug in Green text and "Debug:" prefix
--- - (Optional)`showDebug` (`boolean`): option to overwrite bool from when printutils was setup
--- -
---@param text string
---@param showIf boolean
---@usage
--- Example 1: PrintUtils.PrintDebug("This is an Debug Message")
function PrintUtils.PrintDebug(text, showDebug)
	showDebug = showDebug or CanPrintDebug()
    if not showDebug then return end
    PrintUtils.Print(text, Color.Green, Color.Violet.."Debug:")
end


--- Print Debug in Green text and "Debug:" prefix
--- - (Optional)`showDebug` (`boolean`): option to overwrite bool from when printutils was setup
--- -
---@param table table
---@param showDebug boolean
---@see PrintUtils.PrintMulti
function PrintUtils.PrintMultiDebug(table, showDebug)
    showDebug = showDebug or CanPrintDebug()
    if not showDebug then return end
    PrintUtils.PrintMulti(table, Color.Green, "Debug:")
end

---Prints out a table for debuging
---@param table table
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
