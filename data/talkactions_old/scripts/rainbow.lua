local rainbow = {}
local function rainbowPlayer(cid)
    local player = Player(cid)
    if not player then
        return true
    end
    local outfit = player:getOutfit()
    outfit.lookHead, outfit.lookBody, outfit.lookLegs, outfit.lookFeet = math.random(0, 132), math.random(0, 132), math.random(0, 132), math.random(0, 132)
    player:setOutfit(outfit)
    player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
    rainbow[cid] = addEvent(rainbowPlayer, 500, cid)
end

function onSay(player, words, param)
    local cid = player:getId()
    if rainbow[cid] == nil then
        rainbow[cid] = addEvent(rainbowPlayer, 500, cid)
        player:sendCancelMessage("Rainbow outfit is now actived.")
    else
        stopEvent(rainbow[cid])
        rainbow[cid] = nil
        player:sendCancelMessage("Rainbow outfit is now disabled.")
    end
    return true
end