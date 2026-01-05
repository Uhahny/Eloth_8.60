function onSay(cid, words, param)
    
    local exhaust = 5
    local storage = 123456
    local p = player or Player(cid)
    if not p then return false end
    if p:getStorageValue(storage) > os.time() then
        p:sendCancelMessage("You are exhausted.")
        return false
    end
    p:setStorageValue(storage, os.time() + exhaust)
local ids = {
            7636,   -- ID of small vial.
            7634,   -- ID of strong vial.
            7635    -- ID of great vial.
    }
    for i = 1, table.maxn(ids) do
        doPlayerRemoveItem(cid, ids[i], getPlayerItemCount(cid, ids[i]))
    end
    doSendMagicEffect(getPlayerPosition(cid), 2)
    doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Empty vials removed.")
               doSendMagicEffect(getPlayerPosition(cid), 2)
        return TRUE
end
   