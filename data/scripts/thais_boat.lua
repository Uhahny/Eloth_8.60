function onStepIn(creature, item, position, fromPosition)
	local player = creature:isPlayer() and creature or nil
	if not player then
		return true
	end

	local levelRequirement = 320
	local destination = Position(32312, 32210, 6)
	local backPosition = Position(32353, 32226, 7)

	if player:getLevel() >= levelRequirement then
		player:teleportTo(destination)
		destination:sendMagicEffect(CONST_ME_TELEPORT)
	else
		player:teleportTo(backPosition)
		backPosition:sendMagicEffect(CONST_ME_POFF)
		player:sendTextMessage(MESSAGE_STATUS_WARNING, "Only level 320 or higher are able to enter this portal.")
	end

	return true
end
