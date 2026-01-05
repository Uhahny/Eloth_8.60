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
local state = GAMESTATE_CLOSED
	if(words:sub(2, 2) == "o") then
		state = GAMESTATE_NORMAL
	end

	local str = "Failed to " .. (state == GAMESTATE_CLOSED and "close" or "open") .. " server."
	if(doSetGameState(state)) then
		str = "Server has been " .. (state == GAMESTATE_CLOSED and "closed" or "opened") .. " successfully."
	end

	doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, str)
	return true
end
