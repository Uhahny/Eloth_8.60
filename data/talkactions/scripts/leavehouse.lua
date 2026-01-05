function onSay(player, words, param)
	
    local exhaust = 5
    local storage = 123456
    local p = player or Player(cid)
    if not p then return false end
    if p:getStorageValue(storage) > os.time() then
        p:sendCancelMessage("You are exhausted.")
        return false
    end
    p:setStorageValue(storage, os.time() + exhaust)
local position = player:getPosition()
	local tile = Tile(position)
	local house = tile and tile:getHouse()
	if not house then
		player:sendCancelMessage("You are not inside a house.")
		position:sendMagicEffect(CONST_ME_POFF)
		return false
	end

	if house:getOwnerGuid() ~= player:getGuid() then
		player:sendCancelMessage("You are not the owner of this house.")
		position:sendMagicEffect(CONST_ME_POFF)
		return false
	end

	house:setOwnerGuid(0)
	player:sendTextMessage(MESSAGE_INFO_DESCR, "You have successfully left your house.")
	position:sendMagicEffect(CONST_ME_POFF)
	return false
end
