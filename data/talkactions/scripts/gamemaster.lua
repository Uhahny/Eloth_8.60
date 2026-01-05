local ignore = createConditionObject(CONDITION_GAMEMASTER, -1, false, GAMEMASTER_IGNORE)
local teleport = createConditionObject(CONDITION_GAMEMASTER, -1, false, GAMEMASTER_TELEPORT)

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
local condition = ignore
	local subId = GAMEMASTER_IGNORE
	local name = "private messages ignoring"
	if(words:sub(2, 2) == "c") then
		condition = teleport
		subId = GAMEMASTER_TELEPORT
		name = "map click teleport"
	end

	local action = "off"
	if(not getCreatureCondition(cid, CONDITION_GAMEMASTER, subId)) then
		doAddCondition(cid, condition)
		action = "on"
	else
		doRemoveCondition(cid, CONDITION_GAMEMASTER, subId)
	end

	doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "You have turned " .. action .. " " .. name .. ".")
	return true
end
