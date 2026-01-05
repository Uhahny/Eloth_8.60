local waittime = 20 --Default (30 seconds)
local storage = 5560

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
if exhaustion.get(cid, storage) == FALSE then
                doPlayerSave(cid)
                exhaustion.set(cid, storage, waittime)
                doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "You have successfully saved your character.")
        else
                doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_RED, "You must wait another " .. exhaustion.get(cid, storage) .. " seconds.")
        end    
        return TRUE
end 