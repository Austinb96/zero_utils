local resourceName = GetCurrentResourceName()
local printDebug = nil
if Config.PrintDebug ~= nil then printDebug = Config.PrintDebug end
if type(Config.Debug) == "table" then
    if Config.Debug.PrintDebug ~= nil then
        printDebug = Config.Debug.PrintDebug
    else
        printDebug = Config.Debug.Debug
    end
end
if printDebug == nil then
    printDebug = Config.Debug or false
end
local canDebug = {
    [resourceName] = not (GetConvar("DisableDebug", "false") == "true") and printDebug
}
local resourcprefix = zutils?.name ~= resourceName and "" or nil

Color = {
    White = "^0",
    Red = "^1",
    Green = "^2",
    Yellow = "^3",
    DarkBlue = "^4",
    LightBlue = "^5",
    Violet = "^6",
}

local canPrint
if resourceName == "zero_utils" then
    canPrint = function()
        local resource = GetInvokingResource() or resourceName
        if canDebug[resource] == nil then
            return false
        end
        return canDebug[resource]
    end
else
    canPrint = function()
        return canDebug[resourceName]
    end
end

local function getFormattedText(text, args, textColor)
    if not args then return textColor .. text end
    text = tostring(text)
    local expectedArgs = select(2, text:gsub("%%s", ""))
    if #args < expectedArgs then
        while #args < expectedArgs do
            table.insert(args, "nil")
        end
    elseif #args > expectedArgs then
        local trace = debug.traceback()
        printwarn("Too many arguments for %s, expected %s got %s", text, expectedArgs, #args)
        printwarn(trace)
    end
    local formattedArgs = { Color.LightBlue .. "nil" .. textColor }
    local arg
    for i = 1, #args do
        arg = args[i]
        if type(arg) == "table" then
            arg = Color.LightBlue .. table.concat(arg, ",") .. textColor
        else
            arg = tostring(arg)
        end
        formattedArgs[i] = Color.LightBlue .. arg .. textColor
    end
    return string.format(textColor .. text .. Color.White, table.unpack(formattedArgs))
end

local function log(event, msg, src)
    local context = IsDuplicityVersion() and 'server' or 'client'
    if context == "server" then
        lib.logger(src, event, msg)
    else
        TriggerServerEvent("zero_utils:server:log", event, msg)
    end
end
if resourceName == "zero_utils" then
    RegisterNetEvent("zero_utils:server:log", function (event, msg)
        if not event or not msg then
            printerr("Invalid client log event: %s or msg: %s", event, msg)
            return
        end
        msg = "CLIENT: "..msg
        log(event, msg, source)
    end)
end

function printfmt(text, ...)
    local args = { ... }
    local options = {
        color = Color.White,
        prefix = nil,
    }
    if args.options then
        options.color = args.options.color or options.color
        options.prefix = args.options.prefix or options.prefix
    end
        
    local formattedText = getFormattedText(text, args, options.color)
    print(options.color .. formattedText)
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

            print(options.prefixColor .. options.prefix .. " " .. formattedText)
        else
            print(options.prefixColor .. options.prefix .. " " .. options.color .. tostring(item))
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
    print("Error was called")
    local prefix = "Error!: "
    local formatedText = getFormattedText(text, args, Color.Red)
    local msg = Color.Red..prefix .. formatedText
    log("error", prefix..text:format(...).."\n"..debug.traceback(nil, 2))
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
    print(Color.Yellow .. prefix .. formatedText)
end

--- Print Debug in Green text and "Debug:" prefix
---@param text string | boolean | table string or true to always show debug
---@usage
--- Example 1: PrintUtils.PrintDebug("This is an Debug Message")
function printdb(text, ...)
    local args
    if text == true then
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
    print(Color.Violet .. prefix .. formatedText)
end

---Prints out a table for debuging
---@param table table | string
function printtable(table, indent, overwriteDebug, skipbracket)
    if (not overwriteDebug) and GetConvar("DisableDebug", "false") == "true" then return end
    if type(table) == "string" then
        print(table)
        if type(indent) == "table" then
            printtable(indent, nil, overwriteDebug)
        else
            printwarn("Second arg was not a table: %s %s", type(indent), json.encode(indent))
        end
        return
    end
    indent = indent or 0
    local indentStr = string.rep("  ", indent)
    local indentStrSub = string.rep("  ", indent + 1)
    local colorStr = "^" .. tostring(indent % 6 + 1)
    if not skipbracket then
        print(indentStr .. colorStr .. "{^0")
    end
    for k, v in pairs(table) do
        if type(v) == "table" then
            local newColorStr = "^" .. tostring((indent +1) % 6 + 1)
            print(indentStrSub .. k .. " =" .. newColorStr .. " {^0")
            printtable(v, indent + 1, overwriteDebug, true)
        else
            print(indentStrSub .. k .. " = " .. tostring(v) .. ",")
        end
    end
    print(indentStr .. colorStr .. "}^0,")
end

PrintUtils = {
    PrintMulti = printmulti,
    PrintError = printerr,
    PrintWarning = printwarn,
    PrintDebug = printdb,
    PrintTable = printtable,
    PrintMultiDebug = function(table, ...)
        printdb(table, ...)
    end
}

if not resourceName then
    PrintUtils.Colors = Color
end

if resourceName == "zero_utils" then
    function zutils.GetPrintUtils(canDebugResource)
        local resource = GetInvokingResource()
        canDebug[resource] = not (GetConvar("DisableDebug", "false") == "true") and canDebugResource
        printdb("CanDebug set for %s(%s) should be %s", resource, canDebug[resource], canDebugResource)
        return PrintUtils
    end
end


printdb("PrintUtils Loaded")