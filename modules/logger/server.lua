--just a wrapper for our logging prefix.
zutils.core_loader("ox_lib")

zutils.logger = {}
local exploit_webhook = GetConvar("exploit_webhook", "")
zutils.discord.registerWebhook("exploit-alerts", exploit_webhook)
local function send_discord_hook(src, msg, player_data)
    if exploit_webhook == "" then
        return
    end
    local webhook = zutils.discord:createWebhook()

    -- Get player info for the webhook
    local playerName = "Unknown Player"
    local discordId = "Unknown"
    local coords = "Unknown"
    local characterName = "Unknown"
    local citizenId = "Unknown"

    if src > 0 then
        playerName = GetPlayerName(src) or "Unknown Player"
        for _, identifier in pairs(GetPlayerIdentifiers(src)) do
            if string.find(identifier, "discord:") then
                discordId = string.gsub(identifier, "discord:", "<@") .. ">"
            end
        end
        
        local ped = GetPlayerPed(src)
        if ped and ped ~= 0 then
            local playerCoords = GetEntityCoords(ped)
            coords = string.format("%.2f, %.2f, %.2f", playerCoords.x, playerCoords.y, playerCoords.z)
        end
        
        if player_data then
            characterName = player_data.character_name or "Unknown"
            citizenId = player_data.citizenid or "Unknown"
        end
    end

    webhook:setTitle("🚨 EXPLOIT DETECTED")
            :setDescription("**Suspicious activity has been detected on the server!**")
            :setColor(16711680)
            :addField("🔍 Log Message", msg, false)
            :addField("👤 Player Name", playerName, true)
            :addField("👤 Character", characterName, true)
            :addField("🆔 Citizen ID", citizenId, true)
            :addField("💬 Discord", discordId, true)
            :addField("📍 Coordinates", coords, true)
            :addField("🏠 Server ID", tostring(src), true)
            :addField("⏰ Server Time", os.date("%Y-%m-%d %H:%M:%S"), true)
            :setFooter("FreestyleRP Anti-Cheat", "https://i.imgur.com/3ZC8b2D.png")
            :setTimestamp()
            :send("exploit-alerts")
end

setmetatable(zutils.logger, {
    __call = function(_, src, type, msg, ...)
        local tags = {}
        local player_data = nil
        src = tonumber(src) or 0
        if src > 0 then
            local character_msg, player_data = zutils.logger.getFormatedPlayer(src)
            if player_data then
                tags[#tags + 1] = ("character_name: %s"):format(player_data.character_name)
                tags[#tags + 1] = ("citizenid: %s"):format(player_data.citizenid)
                local ped = GetPlayerPed(src)
                local coords = GetEntityCoords(ped)
                tags[#tags + 1] = ("coords: vector3(%s %s %s)"):format(coords.x, coords.y, coords.z)
            end
            msg = ("%s %s"):format(character_msg, msg)
        end
        local varArgs = { ... }
        for i = 1, #varArgs do
            tags[#tags + 1] = varArgs[i]
        end
        printdb("src:%s type:%s msg:%s tags:%s ", src, type, msg, tags)
        lib.logger(src, type, msg, table.unpack(tags))
        if type == "exploit" then
            send_discord_hook(src, msg, player_data)
        end
    end
})

function zutils.logger.getFormatedPlayer(src)
    local player_data = zutils.player.getPlayerData(src)
    if player_data then
        local character_name = ("%s %s"):format(player_data.charinfo.firstname, player_data.charinfo.lastname)
        player_data.character_name = character_name
        return ("%s(src:%s cid:%s (%s))"):format(GetPlayerName(src), src, player_data.citizenid, character_name), player_data
    else
        return ("Unknown Player"):format(GetPlayerName(src), src), nil
    end
end

return zutils.logger
