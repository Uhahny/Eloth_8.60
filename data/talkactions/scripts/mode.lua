local config = {
	optional = {"1", "optional", "optionalpvp"},
	open = {"2", "open", "openpvp"},
	hardcore = {"3", "hardcore", "hardcorepvp"}
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
if(param == '') then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Command param required.")
		return true
	end

	local world = getWorldType()
	param = param:lower()
	if(table.isStrIn(param, config.optional)) then
		setWorldType(WORLDTYPE_OPTIONAL)
		world = "Optional PvP"
	elseif(table.isStrIn(param, config.open)) then
		setWorldType(WORLDTYPE_OPEN)
		world = "Open PvP"
	elseif(table.isStrIn(param, config.hardcore)) then
		setWorldType(WORLDTYPE_HARDCORE)
		world = "Hardcore PvP"
	else
		doPlayerSendCancel(cid, "Bad gameworld type.")
		return true
	end

	doBroadcastMessage("Gameworld type set to: " .. world .. ".", MESSAGE_EVENT_ADVANCE)
	return true
end
