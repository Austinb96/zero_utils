PrintUtils = {}
local canPrint = {}

local function CanPrintDebug(overwrite)
    if overwrite then return overwrite end
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

local function getFormattedText(text, args, textColor)
    if not args then return textColor..text end
    local formattedArgs = {Color.LightBlue.."nil"..textColor}
    local arg
    for i = 1, #args do
        arg = args[i]
        if type(arg) == "table" then
            arg = Color.LightBlue..table.concat(arg,",")..textColor
        else
            tostring(arg)
        end
        formattedArgs[i] = Color.LightBlue..arg..textColor
    end
    return string.format(textColor..text..Color.White, table.unpack(formattedArgs))
end

--- @alias ColorTypes '^0' | '^1' | '^2' | '^3' | '^4' | '^5' | '^6'

---@class options
---@field color? ColorTypes
---@field prefix? string
---@field prefixColor? ColorTypes
--- Will print text to multiple lines
--- -
--- options available are:
--- - (Optional)`color` (`string | Color`): color for entire print lines
--- - (Optional)`prefix` (`string`): Prefix for print lines
--- - (Optional)`prefixColor` (`string`): Color for prefix
--- -
---@param table table
---@param options? options
---@usage
--- Example 1: PrintUtils.PrintMulti({"Hello", color = Color.Red},{"World"})
--- -
---@usage
--- Example 2: PrintUtils.PrintMulti({{"Hello"},{"%s",args={"World"}}}, {color = Color.Red, prefix = "ExamplePrefix:"})
function PrintUtils.PrintMulti(table, options)
    ZeroUtils.AssertType(table, "table")
    options = {
        color = options and options.color or Color.White,
        prefix = options and options.prefix or "",
        prefixColor = options and options.prefixColor or Color.White,
    }
    local formattedText = ""
    for _, item in pairs(table) do
        if type(item) == "table" then
            formattedText = getFormattedText(item[1], item.args, item.color or options.color)

            print(options.prefixColor..options.prefix.." "..formattedText)
        else
            print(options.prefixColor..options.prefix.." "..options.color..item)
        end
    end
end

--- Will print out red text with "Error:" prefix along with a trace
--- - Does not stop execution
--- -
---@param text string
---@usage
--- Example 1: PrintUtils.PrintError("This is an Error")
--- -
---@usage
--- Example 2: PrintUtils.PrintError("This is a %s Error", "Cool")
function PrintUtils.PrintError(text, ...)
    local args = {...}

    local prefix = "Error!: "
    local prefixColor = Color.Red
    local formatedText = getFormattedText(text, args, prefixColor)

    error(prefixColor..prefix..formatedText, 2)
end



--- Print Warning in Yellow text and "Warning!:" prefix
--- - (Optional)`last arg` (`boolean`): Pass in a bool as last arg to show/hide warning
--- -
---@param text string
---@param ...? any
---@usage
--- Example 1: PrintUtils.PrintWarning("This is an Warning!")
--- -
---@usage
--- Example 2: PrintUtils.PrintWarning("This is an %s Warning!", "Fancy", true)
function PrintUtils.PrintWarning(text, ...)
    local args = {...}
    local showIf = args[#args]


    if type(showIf) == "boolean" and showIf == false then
        return
    end

    local prefix = "Warning!: "
    local prefixColor = Color.Yellow
    local formatedText = getFormattedText(text, args, prefixColor)

    -- PrintUtils.Print(formatedText, prefixColor ,prefix)
    print(prefixColor..prefix..formatedText)
end

--- Print Warning in Yellow text and "Warning!:" prefix for multiple lines
--- - (Optional)`showIf` (`boolean`): pass in bool to show/hide warning
--- -
---@param table table
---@param showIf? boolean
---@see PrintUtils.PrintMulti
function PrintUtils.PrintMultiWarning(table, showIf)
    if showIf and showIf == false then return end
    PrintUtils.PrintMulti(table, {color = Color.Yellow,prefix = "Warning!:", prefixColor = Color.Yellow})
end


--- Print Debug in Green text and "Debug:" prefix
--- - (Optional)`last arg` (`boolean`): Pass in a bool as last arg to overwrite show/hide debug
--- -
---@param text string
---@usage
--- Example 1: PrintUtils.PrintDebug("This is an Debug Message")
function PrintUtils.PrintDebug(text,...)
    local args = {...}
    local showIf = args[#args]
    if type(showIf) == "boolean" then
        args[#args] = nil
    else
        showIf = nil
    end
    if not CanPrintDebug(showIf) then return end

    local prefix = Color.Violet.."Debug: "
    local textColor = Color.Green
    local formatedText = getFormattedText(text, args, textColor)

    print(prefix..formatedText)
end


--- Print Debug in Green text and "Debug:" prefix
--- - (Optional)`showDebug` (`boolean`): pass in bool to show/hide debug
--- -
---@param table table
---@param showDebug? boolean
---@see PrintUtils.PrintMulti
function PrintUtils.PrintMultiDebug(table, showDebug)
    showDebug = showDebug or CanPrintDebug()

    if not showDebug then return end
    PrintUtils.PrintMulti(table,{color = Color.Green, prefix = "Debug:", prefixColor = Color.Violet})
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