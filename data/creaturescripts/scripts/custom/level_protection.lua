function onLogin(player)
	local freeBlessMaxLevel = 80 -- Set the max level for free blessings to 100

	if player:getLevel() < freeBlessMaxLevel then
		local bless = 5
		for i = 1, bless do
			player:addBlessing(i)
		end
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, 'You received free blessings because your level is less than ' .. freeBlessMaxLevel .. '!')
	end
	return true
end
