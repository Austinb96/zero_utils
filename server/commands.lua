RegisterCommand("gethash", function(_, args)
    local model = args[1]
    print(("%s = %s"):format(model, GetHashKey(model)))
end, false)
