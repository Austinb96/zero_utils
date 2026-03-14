zutils.perms = {}
local function ace_allow(allow) return allow == false and 'deny' or 'allow' end
local function is_player(x)
    if type(x) == 'number' then
        x = 'player.' .. x
    end

    return x
end
function zutils.perms.addAce(principal, ace, allow)
    principal = is_player(principal)
    ExecuteCommand(('add_ace %s %s %s'):format(principal, ace, ace_allow(allow)))
end

function zutils.perms.removeAce(principal, ace, allow)
    principal = is_player(principal)
    ExecuteCommand(('remove_ace %s %s %s'):format(principal, ace, ace_allow(allow)))
end

function zutils.perms.addPrincipal(child, parent)
    child = is_player(child)
    ExecuteCommand(('add_principal %s %s'):format(child, parent))
end

function zutils.perms.removePrincipal(child, parent)
    child = is_player(child)
    ExecuteCommand(('remove_principal %s %s'):format(child, parent))
end

function zutils.perms.hasPerm(src, ace)
    local has_ace = IsPlayerAceAllowed(src, ace)
    return has_ace
end

return zutils.perms