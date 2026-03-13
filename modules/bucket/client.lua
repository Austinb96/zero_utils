zutils.bucket = {}

function zutils.bucket.get()
    return zutils.callback.await("zero_utils:server:getPlayerBucket")
end

return zutils.bucket
