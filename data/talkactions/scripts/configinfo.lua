local HIDDEN = {"passwordType", "sql"}

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
param = param:trim()
	for _, str in ipairs(HIDDEN) do
		if(param:find(str) ~= nil) then
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Config value \"" .. param .. "\" does not exists.")
			return true
		end
	end

	local value = getConfigValue(param)
	if(value) then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, param .. " = " .. value)
		return true
	end

	doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Config value \"" .. param .. "\" does not exists.")
	return true
end
