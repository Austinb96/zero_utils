zutils.discord = {}

local webhooks = {}

zutils.discord.registerWebhook = function(name, url)
    webhooks[name] = url
end

local WebhookBuilder = {}
WebhookBuilder.__index = WebhookBuilder

function WebhookBuilder:new()
    local builder = {
        embed = {
            title = nil,
            description = nil,
            color = nil,
            fields = {},
            author = nil,
            footer = nil,
            thumbnail = nil,
            image = nil,
            timestamp = nil,
            url = nil
        },
        username = "FreestyleRP",
        avatar_url = ""
    }
    setmetatable(builder, WebhookBuilder)
    return builder
end

function WebhookBuilder:setTitle(title)
    self.embed.title = title
    return self
end

function WebhookBuilder:setDescription(description)
    self.embed.description = description
    return self
end

function WebhookBuilder:setColor(color)
    self.embed.color = color
    return self
end

function WebhookBuilder:setUrl(url)
    self.embed.url = url
    return self
end

function WebhookBuilder:addField(name, value, inline)
    if inline == nil then inline = false end
    table.insert(self.embed.fields, {
        name = name,
        value = value,
        inline = inline
    })
    return self
end
function WebhookBuilder:removeField(index)
    if self.embed.fields[index] then
        table.remove(self.embed.fields, index)
    end
    return self
end
function WebhookBuilder:clearFields()
    self.embed.fields = {}
    return self
end
function WebhookBuilder:setAuthor(name, url, icon_url)
    self.embed.author = {
        name = name,
        url = url,
        icon_url = icon_url
    }
    return self
end
function WebhookBuilder:setFooter(text, icon_url)
    self.embed.footer = {
        text = text,
        icon_url = icon_url
    }
    return self
end

function WebhookBuilder:setThumbnail(url)
    self.embed.thumbnail = {
        url = url
    }
    return self
end

function WebhookBuilder:setImage(url)
    self.embed.image = {
        url = url
    }
    return self
end

function WebhookBuilder:setTimestamp(timestamp)
    if timestamp then
        self.embed.timestamp = timestamp
    else
        self.embed.timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    end
    return self
end

function WebhookBuilder:setUsername(username)
    self.username = username
    return self
end

function WebhookBuilder:setAvatarUrl(avatar_url)
    self.avatar_url = avatar_url
    return self
end

local valid_returns = {
    ["200"] = true,
    ["204"] = true
}
function WebhookBuilder:send(webhookName)
    local webhook = webhooks[webhookName]
    if not webhook then
        printwarn("Discord webhook not found: %s", webhookName)
        return
    end

    local cleanEmbed = {}
    for k, v in pairs(self.embed) do
        if v ~= nil then
            if k == "fields" and #v == 0 then
            else
                cleanEmbed[k] = v
            end
        end
    end

    cleanEmbed.type = "rich"

    local payload = {
        username = self.username,
        avatar_url = self.avatar_url,
        embeds = { cleanEmbed }
    }

    PerformHttpRequest(webhook, function(err, text, headers)
        if not valid_returns[tostring(err)] then
            printwarn("Discord webhook error: %s", err)
        end
    end, 'POST', json.encode(payload), { ['Content-Type'] = 'application/json' })
end

function zutils.discord:createWebhook()
    return WebhookBuilder:new()
end

function zutils.discord:sendWebhook(name, title, description, color)
    local builder = self:createWebhook()
    builder:setTitle(title)
        :setDescription(description)
        :setColor(color)
        :send(name)
end

return zutils.discord
