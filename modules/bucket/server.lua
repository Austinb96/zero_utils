zutils.bucket = {}

function zutils.bucket.getPlayer(src)
    return GetPlayerRoutingBucket(src)
end

function zutils.bucket.setPlayer(src, bucket)
    SetPlayerRoutingBucket(src, bucket)
end

function zutils.bucket.getEntity(entity)
    return GetEntityRoutingBucket(entity)
end

function zutils.bucket.setPlayer(entity, bucket)
    SetEntityRoutingBucket(entity, bucket)
end

return zutils.bucket
