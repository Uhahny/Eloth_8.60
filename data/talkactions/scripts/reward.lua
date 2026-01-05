  function onSay(cid, words, param, channel)  
        
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
        local gm = getCreatureName(cid)
        for _, cid in ipairs(getPlayersOnline()) do
                local accId = getPlayerAccount(cid)
                if(getNotationsCount(accId) < 1) then
                    doPlayerAddItem(cid, t[1], 1)
                        doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Everyone have been rewarded a "..getItemNameById(t[1]).." by "..gm.." for the reason: "..tostring(t[2])..".")
                        doSendMagicEffect(getCreaturePosition(cid), CONST_ME_GIFT_WRAPS)               
                end
        end
        return TRUE
end 