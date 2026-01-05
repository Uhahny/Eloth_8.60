function onSay(p, words, param)

    local exhaust = 5
    local storage = 123456
    local p = player or Player(cid)
    if not p then return false end
    if p:getStorageValue(storage) > os.time() then
        p:sendCancelMessage("You are exhausted.")
        return false
    end
    p:setStorageValue(storage, os.time() + exhaust)
local t = string.explode(param, ",")
local pos = {x = t[1], y = t[2], z = t[3]}
if(doTeleportThing(p, pos) == true) then
doSendMagicEffect(getCreaturePosition(p), CONST_ME_TELEPORT)
else
doSendMagicEffect(getCreaturePosition(p), CONST_ME_POFF)
end
return 1
end