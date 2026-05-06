zutils.file = {}

function zutils.file.read(file_path, resource)
    if not file_path then return false, "path must be defined" end
    local ext = file_path:match("%.([^%.]+)$")
    if not ext then
        file_path = file_path .. ".txt"
    end
    local data = LoadResourceFile(resource or zutils.name, file_path)
    return data
end

function zutils.file.save(file_path, data, resource, data_length)
    local ext = file_path:match("%.([^%.]+)$")
    if not ext then
        file_path = file_path .. ".txt"
    end

    local result = SaveResourceFile(resource or zutils.name, file_path, data, data_length or -1)

    if not result then
        printwarn("file %s failed to save", file_path)
        return false, ("file %s failed to save"):format(file_path)
    end

    return result
end

function zutils.file.saveTable(file_path, tbl, resource, data_length, sort_order, include_return)
    local ext = file_path:match("%.([^%.]+)$")
    if not ext then
        file_path = file_path .. ".lua"
    end

    local data = table.serialize(tbl, 0, sort_order)
    
    if include_return then
        data = "return " .. data
    end 

    local result = SaveResourceFile(resource or zutils.name, file_path, data, data_length or -1)

    if not result then
        printwarn("file %s failed to save", file_path)
        return false, ("file %s failed to save"):format(file_path)
    end

    return result
end

return zutils.file
