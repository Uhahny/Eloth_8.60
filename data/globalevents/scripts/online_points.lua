
    local config = {
    storageTime = 25230, -- storage time online
    timeMax = (2000), -- 1 hour
    pointsPerTime = 2, -- 1 point per hour
    itemPoint = 6527 -- item per hour
    }

    function onThink(interval)

    for _, player in ipairs(Game.getPlayers()) do
    local playerIp = player:getIp()
    if (playerIp ~= 0) then
    local time = player:getStorageValue(config.storageTime)
    if (time < 0) then time = 0 end
    if (time >= config.timeMax) then
    player:setStorageValue(config.storageTime, 0)
    player:addItem(config.itemPoint, config.pointsPerTime)
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, 'You recieved ' .. config.pointsPerTime .. ' ' .. ItemType(config.itemPoint):getName() .. ' because 2 hour of gameplay has passed in Game.')
    else
    player:setStorageValue(config.storageTime, (time + interval))
    end end end

    return true
    end