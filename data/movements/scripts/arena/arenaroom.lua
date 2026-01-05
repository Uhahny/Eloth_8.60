local leave = Position(32312, 31134, 6)
local arena_room_max_time = 60 -- ustaw czas w sekundach
local arena_monsters = {
	-- przykładowe potwory (musisz uzupełnić pod swoje ID)
	[42300] = "Orc",
	[42301] = "Cyclops",
	[42302] = "Dragon"
}

local function checkArenaRooms()
	addEvent(checkArenaRooms, 1000)

	for i = 42300, 42309 do
		local playerId = Game.getStorageValue(i)
		local player = Player(playerId)

		if player then
			local timeLeft = player:getStorageValue(42350)

			if timeLeft <= os.time() then
				player:teleportTo(leave)
				leave:sendMagicEffect(CONST_ME_TELEPORT)
				player:setStorageValue(42350, 0)
				Game.setStorageValue(i, 0)
				player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE,
					"You have been kicked from arena! You have only " .. arena_room_max_time .. " seconds for one room.")
			elseif timeLeft - 10 <= os.time() then
				player:sendTextMessage(MESSAGE_EVENT_DEFAULT,
					"You have " .. (timeLeft - os.time()) .. " seconds to pass to the next room!")
			end
		else
			Game.setStorageValue(i, 0)
		end
	end
end

function onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if not _G["InitArenaScript"] then
		_G["InitArenaScript"] = true
		for i = 0, 9 do
			Game.setStorageValue(42300 + i, 0)
			Game.setStorageValue(42400 + i, 0)
		end
		checkArenaRooms()
	end

	local arena_room = item.actionid
	local currentLevel = player:getStorageValue(42355)

	if player:getStorageValue(arena_room + currentLevel * 10 - 1) == 1 or arena_room + currentLevel * 10 - 1 == 42299 then
		if Game.getStorageValue(arena_room) == 0 then
			local monsterId = Game.getStorageValue(arena_room + 100)
			if monsterId > 0 then
				local monster = Creature(monsterId)
				if monster then
					monster:remove()
				end
			end

			local spawnPos = item:getPosition()
			local monsterName = arena_monsters[arena_room + currentLevel * 10]
			if monsterName then
				local monster = Game.createMonster(monsterName, Position(spawnPos.x - 1, spawnPos.y - 1, spawnPos.z))
				if monster then
					Game.setStorageValue(arena_room + 100, monster:getId())
				end
			end

			player:teleportTo(spawnPos)
			spawnPos:sendMagicEffect(CONST_ME_TELEPORT)
			Game.setStorageValue(arena_room, player:getId())
			Game.setStorageValue(arena_room - 1, 0)
			player:setStorageValue(42350, os.time() + arena_room_max_time)
		else
			player:teleportTo(fromPosition)
			fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
			local otherId = Game.getStorageValue(arena_room)
			local other = Player(otherId)
			if other then
				player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE,
					other:getName() .. " is now in the next room. Wait a moment and try again.")
			else
				player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE,
					"Room is busy. Try again later.")
			end
		end
	else
		player:teleportTo(fromPosition)
		fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "First kill the monster!")
	end

	if arena_room == 42300 then
		player:setStorageValue(42351, 0)
		player:setStorageValue(42352, 1)
	end

	return true
end