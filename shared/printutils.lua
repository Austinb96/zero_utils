local Print = print
local resourceName = GetCurrentResourceName()
local canDebug = nil
local resourcprefix = zutils and zutils.name ~= resourceName and "" or nil
local config_ = Config or config or cfg
CreateThread(function()
    while config_ == nil do
        Wait(0)
        config_ = Config or config or cfg
        if not config_ and GetResourceState(resourceName) == "started" then config_ = {} end
    end
end)

local function canPrint()
    if canDebug ~= nil then
        return canDebug
    end

    local disableDebugConvar = GetConvar("DisableDebug", "false")
    if disableDebugConvar == "true" then
        canDebug = false
        return canDebug
    end

    while config_ == nil do
        Wait(0)
    end

    if config_.PrintDebug ~= nil then
        canDebug = config_.PrintDebug
        return canDebug
    end

    if not config_.Debug then
        return false
    end

    if type(config_.Debug) == "boolean" then
        canDebug = config_.Debug
        return canDebug
    end

    if config_.Debug.PrintDebug ~= nil then
        canDebug = config_.Debug.PrintDebug
        return canDebug
    end

    if config_.Debug.Debug ~= nil then
        canDebug = config_.Debug.Debug
        return canDebug
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

local function getFormattedText(text, args, textColor)
    text = tostring(text)

    if not args or #args == 0 then
        return textColor .. text .. Color.White
    end
    
    for i, arg in pairs(args) do
        if type(arg) == "table" then
            arg = json.encode(arg)
        end
        args[i] = Color.LightBlue .. arg .. textColor
    end

    local ok, formatted = pcall(
        string.format,
        textColor .. text .. Color.White,
        table.unpack(args)
    )

    if ok then
        return formatted
    end

    print(Color.Red .. "[Error] Format failed" .. Color.White, text, formatted)
    local trace = debug.traceback()
    print(Color.Red .. trace .. Color.White)

    local fallbackArgs = {}
    for i = 1, #args do
        local arg = args[i]
        if type(arg) == "table" then
            fallbackArgs[i] = table.concat(arg, ",")
        else
            fallbackArgs[i] = tostring(arg)
        end
    end

    return textColor .. text .. " [" .. table.concat(fallbackArgs, ", ") .. "]" .. Color.White
end

function printfmt(text, ...)
    local args = { ... }
    local options = {
        color = Color.White,
        prefix = "",
    }
    if type(args[#args]) == "table" then
        options.color = args[#args].color or options.color
        options.prefix = args[#args].prefix or options.prefix
        args[#args] = nil
    end
    local formattedText = getFormattedText(text, args, options.color)
    Print(options.prefix .. options.color .. formattedText)
end

--- @alias ColorTypes '^0' | '^1' | '^2' | '^3' | '^4' | '^5' | '^6'

--- Print multiple lines with optional color and prefix.
--- @class options
--- @field color? ColorTypes Color for entire print lines
--- @field prefix? string Prefix for print lines
--- @field prefixColor? ColorTypes Color for prefix
--- @param table table A table of strings or tables specifying text and formatting.
--- @param options? options Formatting options for all lines.
--- @usage Example 1: printmulti({"Hello", color = Color.Red},{"World"})
--- @usage Example 2: printmulti({{"Hello"},{"%s", args={"World"}}}, {color = Color.Red, prefix = "ExamplePrefix:"})
function printmulti(table, options)
    options = {
        color = options and options.color or Color.White,
        prefix = options and options.prefix or "",
        prefixColor = options and options.prefixColor or Color.White,
    }
    local formattedText = ""
    for _, item in pairs(table) do
        if type(item) == "table" then
            local args = {}
            if #item > 1 then
                for i = 2, #item do
                    args[#args + 1] = item[i]
                end
            end
            formattedText = getFormattedText(item[1], args, item.color or options.color)

            Print(options.prefixColor .. options.prefix .. " " .. formattedText)
        else
            Print(options.prefixColor .. options.prefix .. " " .. options.color .. tostring(item))
        end
    end
end

---@param text string
---@usage
--- Example 1: printerr("This is an Error")
--- -
---@usage
--- Example 2: printerr("This is a %s Error", "Cool")
function printerr(text, ...)
    local args = { ... }
    local prefix = "Error!: "
    local formatedText = getFormattedText(text, args, Color.Red)
    local msg = Color.Red .. prefix .. formatedText
    error(msg, 2)
end

--- Print Warning in Yellow text and "Warning!:" prefix
--- -
---@param text string | table
---@param ...? any
---@usage
--- Example 1: PrintUtils.PrintWarning("This is an Warning!")
--- -
---@usage
--- Example 2: PrintUtils.PrintWarning("This is an %s Warning!", "Fancy")
function printwarn(text, ...)
    local args = { ... }

    local prefix = ("Warning%s: "):format((resourcprefix or GetInvokingResource() and "(" .. GetInvokingResource() .. ")" or ""))
    if type(text) == "table" then
        printmulti(text, { color = Color.Yellow, prefix = prefix, prefixColor = Color.Yellow })
        return
    end

    local formatedText = getFormattedText(text, args, Color.Yellow)
    Print(Color.Yellow .. prefix .. formatedText)
end

--- Print Debug in Green text and "Debug:" prefix
---@param text string | boolean | table string or true to always show debug
---@usage
--- Example 1: PrintUtils.PrintDebug("This is an Debug Message")
function printdb(text, ...)
    local args
    if type(text) == "boolean" then
        if text == false then return end
        args = { ... }
        text = args[1] or text
        table.remove(args, 1)
    else
        if not canPrint() then return end
        args = { ... }
    end
    local prefix = ("Debug%s: "):format((resourcprefix or GetInvokingResource() and "(" .. GetInvokingResource() .. ")" or ""))
    if type(text) == "table" then
        printmulti(text, { color = Color.Green, prefix = prefix, prefixColor = Color.Violet })
        return
    end

    local formatedText = getFormattedText(text, args, Color.Green)
    Print(Color.Violet .. prefix .. formatedText)
end

---Prints out a table for debuging
---@param table table | string
function printtable(table, indent, overwriteDebug, skipbracket, visited)
    if not table then return Print("nil Table") end
    if (not overwriteDebug) and GetConvar("DisableDebug", "false") == "true" then return end
    if type(table) ~= "table" then
        printfmt("table: " .. json.encode(table), { color = Color.Violet })
        if type(indent) == "table" then
            printtable(indent, nil, overwriteDebug)
        else
            printwarn("type was not a table, got: " .. tostring(indent))
        end
        return
    end

    local is_root_call = visited == nil
    visited = visited or {}

    if visited[table] then
        Print(string.rep("  ", indent or 0) .. "^1*RECURSION DETECTED*^0")
        return
    end

    visited[table] = true

    indent = indent or 0
    local indentStr = string.rep("  ", indent)
    local indentStrSub = string.rep("  ", indent + 1)
    local bracetColorStr = "^" .. tostring((indent) % 6 + 1)
    local tableColorStr = Color.Violet
    local valueColorStr = Color.LightBlue
    if not skipbracket then
        Print(indentStr .. bracetColorStr .. "{^0")
    end

    for k, v in pairs(table) do
        if type(v) == "table" then
            local newColorStr = "^" .. tostring((indent + 1) % 6 + 1)
            Print(indentStrSub .. tableColorStr .. k .. "^0 = " .. newColorStr .. "{^0")
            printtable(v, indent + 1, overwriteDebug, true, visited)
        else
            Print(indentStrSub .. valueColorStr .. k .. "^0 = " .. tostring(v) .. ",")
        end
    end

    visited[table] = nil
    if is_root_call then
        visited = nil
    end

    Print(indentStr .. bracetColorStr .. "}^0") -- Closing bracket uses the same color
end

PrintUtils = {
    PrintMulti = printmulti,
    PrintError = printerr,
    PrintWarning = printwarn,
    PrintDebug = printdb,
    PrintTable = printtable,
    PrintMultiDebug = function(table, ...)
        printdb(table, ...)
    end,
    PrintFormat = printfmt,
    SetDebug = function(value)
        if not value then return end
        print("Setting Debug to: ", value)
        printDebug = value
        canDebug = value
    end,
}

if not resourceName then
    PrintUtils.Colors = Color
end