-- data/actions/scripts/exp_book.lua

local config = {
    rate = 1.25,           -- extra exp rate (use it however your server reads it)
    time = 1,              -- hours of extra exp time
    storage = 20011,       -- storage for exp bonus expiration timestamp (os.time())
    exhaustStorage = 9583, -- storage for item reuse cooldown expiration (os.time())
    exhaustTime = 3600     -- seconds of cooldown to reuse the book
}

local function plural(n, s, p)
    return n == 1 and s or p
end

local function formatTime(t)
    if t < 0 then t = 0 end
    local h = math.floor(t / 3600)
    local m = math.floor((t % 3600) / 60)
    local s = t % 60
    local parts = {}
    if h > 0 then table.insert(parts, string.format("%d %s", h, plural(h, "hour", "hours"))) end
    if m > 0 then table.insert(parts, string.format("%d %s", m, plural(m, "minute", "minutes"))) end
    if s > 0 or (#parts == 0) then table.insert(parts, string.format("%d %s", s, plural(s, "second", "seconds"))) end
    return table.concat(parts, ", ")
end

function onUse(cid, item, fromPosition, itemEx, toPosition)
    local player = Player(cid)
    if not player then
        return true
    end

    -- cooldown (replacement for exhaustion.*)
    local now = os.time()
    local reuseUntil = player:getStorageValue(config.exhaustStorage)
    if reuseUntil == -1 then reuseUntil = 0 end

    if reuseUntil > now then
        local left = reuseUntil - now
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        player:sendCancelMessage("You need to wait " .. formatTime(left) .. " before you can use this again.")
        return true
    end

    -- exp bonus remaining?
    local bonusUntil = player:getStorageValue(config.storage)
    if bonusUntil == -1 then bonusUntil = 0 end

    if bonusUntil <= now then
        -- grant / refresh bonus
        local newUntil = now + (config.time * 3600)
        player:setStorageValue(config.storage, newUntil)
        player:setStorageValue(config.exhaustStorage, now + config.exhaustTime)

        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE,
            string.format("Your extra experience rate is now: %.2f. It will last for %d %s.",
                config.rate, config.time, plural(config.time, "hour", "hours")))
        item:remove(1)
    else
        -- already active -> tell remaining time
        local left = bonusUntil - now
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE,
            "You still have extra experience time left: " .. formatTime(left) .. ".")
    end

    return true
end
