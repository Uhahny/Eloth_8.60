local worlds = {
	[WORLDTYPE_OPTIONAL] = "Optional PvP",
	[WORLDTYPE_OPEN] = "Open PvP",
	[WORLDTYPE_HARDCORE] = "Hardcore PvP"
}

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
local world = worlds[getWorldType()]
	if(not world) then
		return true
	end

	doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "World type is currently set to " .. world .. ".")
	return true
end
