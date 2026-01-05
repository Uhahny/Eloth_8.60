local playersNeeded = 5
local ipsNeeded = 5
local minimumLevel = 8
local storageId = 4157338
local pointsForPlayer = 300

local function sendPlayersList(cid, list)
    for i, pid in ipairs(list) do
        local level = getPlayerLevel(pid)
        local storage = getCreatureStorage(pid, storageId)
        local valid = storage > 1 and " - already received!" or ""
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, getCreatureName(pid) .. " - Level: " .. level .. valid .. " - Number: " .. storage)
    end
end

function onSay(cid, words, param, channel)
    if getPlayerGuildLevel(cid) == 3 then
        local leaderGuild = getPlayerGuildId(cid)
        local players = getPlayersOnline()
        local guildMembersValid = {}
        local guildMembersInvalid = {}
        local ips = {}

        for i, pid in ipairs(players) do
            if leaderGuild == getPlayerGuildId(pid) then
                local level = getPlayerLevel(pid)
                local storage = tonumber(getCreatureStorage(pid, storageId))

                if level >= minimumLevel and storage < 2 then
                    table.insert(guildMembersValid, pid)
                else
                    table.insert(guildMembersInvalid, pid)
                end

                -- Collect IPs of valid players
                if level >= minimumLevel then
                    local ip = getPlayerIp(pid)
                    ips[ip] = (ips[ip] or 0) + 1
                end
            end
        end

        local uniqueIPs = 0
        for ip, count in pairs(ips) do
            uniqueIPs = uniqueIPs + 1
        end

        if #guildMembersValid >= playersNeeded then
            if uniqueIPs >= ipsNeeded then
                doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "Players that received points:")
                sendPlayersList(cid, guildMembersValid)
                doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "Players that did not receive points:")
                sendPlayersList(cid, guildMembersInvalid)
                
                local accounts = {}
                for i, pid in ipairs(guildMembersValid) do
                    table.insert(accounts, getPlayerAccountId(pid))
                    doCreatureSetStorage(pid, storageId, os.time())
                end
                db.query("UPDATE `accounts` SET `premium_points` = `premium_points` + " .. pointsForPlayer .. " WHERE `id` IN (" .. table.concat(accounts, ",") .. ");")
            else
                doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, #guildMembersValid .. " players from your guild are valid (" .. playersNeeded .. " required), but you have together only " .. uniqueIPs .. " unique IPs (" .. ipsNeeded .. " required)")
                doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "Valid players:")
                sendPlayersList(cid, guildMembersValid)
                doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "Invalid players:")
                sendPlayersList(cid, guildMembersInvalid)
            end
        else
            doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, #guildMembersValid .. " players from your guild are valid, " .. playersNeeded .. " required. Minimum level required is " .. minimumLevel)
            doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "Valid players:")
            sendPlayersList(cid, guildMembersValid)
            doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "Invalid players:")
            sendPlayersList(cid, guildMembersInvalid)
        end
    else
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "Only guild leaders can request points.")
    end
    return true
end
