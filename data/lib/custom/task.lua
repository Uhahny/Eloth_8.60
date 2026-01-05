RANK_NONE = 0
RANK_JOIN = 1
RANK_HUNTSMAN = 2
RANK_RANGER = 3
RANK_BIGGAMEHUNTER = 4
RANK_TROPHYHUNTER = 5
RANK_ELITEHUNTER = 6

tasksByPlayer = 3

tasks = {
	[1] = {killsRequired = 50, raceName = "rotworm", level = {8, 60000}, creatures = {"rotworm"}, rewards = {{type = "exp", value = {200000}},{type="item",value={2160, 2}},{type = "points", value = {5}}}},
	[2] = {killsRequired = 50, raceName = "cyclops", level = {8, 60000}, creatures = {"cyclops"}, rewards = {{type = "exp", value = {400000}},{type="item",value={2160, 5}},{type = "points", value = {5}}}},
	[3] = {killsRequired = 100, raceName = "dragon", level = {8, 60000}, creatures = {"dragon"}, rewards = {{type = "exp", value = {1000000}},{type="item",value={2160, 25}},{type = "points", value = {5}}}},
	[4] = {killsRequired = 150, raceName = "hero", level = {8, 60000}, creatures = {"hero"}, rewards = {{type = "exp", value = {1000000}},{type="item",value={2160, 30}},{type = "points", value = {5}}}},
	[5] = {killsRequired = 250, raceName = "red arciere", level = {8, 60000}, creatures = {"red arciere"}, rewards = {{type = "exp", value = {1000000}},{type="item",value={2160, 30}},{type = "points", value = {5}}}},
	[6] = {killsRequired = 300, raceName = "cyrulik", level = {8, 60000}, creatures = {"supery fury"}, rewards = {{type = "exp", value = {50000000}},{type="item",value={2160, 40}},{type = "points", value = {5}}}},
	[7] = {killsRequired = 350, raceName = "pro cyrulik", level = {8, 60000}, creatures = {"pro cyrulik"}, rewards = {{type = "exp", value = {50000000}},{type="item",value={2160, 100}},{type = "points", value = {5}}}},
	[8] = {killsRequired = 400, raceName = "hellspawn", level = {8, 60000}, creatures = {"hellspawn"}, rewards = {{type = "exp", value = {50000000}},{type="item",value={2160, 50}},{type = "points", value = {5}}}},
	[9] = {killsRequired = 500, raceName = "slave", level = {8, 60000}, creatures = {"slave"}, rewards = {{type = "exp", value = {50000000}},{type="item",value={8310, 1}},{type = "points", value = {5}}}},
	[10] = {killsRequired = 600, raceName = "fire lord", level = {8, 60000}, creatures = {"fire lord"}, rewards = {{type = "exp", value = {50000000}},{type="item",value={8310, 2}},{type = "points", value = {5}}}},
	[11] = {killsRequired = 700, raceName = "snape", level = {8, 60000}, creatures = {"snape"}, rewards = {{type = "exp", value = {50000000}},{type="item",value={8310, 1}},{type = "points", value = {5}}}},
	[12] = {killsRequired = 800, raceName = "rrrat", level = {8, 60000}, creatures = {"rrrat"}, rewards = {{type = "exp", value = {50000000}},{type="item",value={8310, 1}},{type="item",value={5919, 1}},{type = "points", value = {5}}}},
	[13] = {killsRequired = 900, raceName = "desert ghost", level = {8, 60000}, creatures = {"desert ghost"}, rewards = {{type = "exp", value = {50000000}},{type="item",value={8310, 1}},{type="item",value={10523, 1}},{type = "points", value = {5}}}},
	[14] = {killsRequired = 1000, raceName = "zgredek", level = {8, 60000}, creatures = {"zgredek"}, rewards = {{type = "exp", value = {50000000}},{type="item",value={8310, 1}},{type = "points", value = {5}}}},
	[15] = {killsRequired = 1100, raceName = "maxi", level = {8, 60000}, creatures = {"maxi"}, rewards = {{type = "exp", value = {50000000}},{type="item",value={8310, 2}},{type = "points", value = {5}}}},
	[16] = {killsRequired = 1200, raceName = "predator", level = {8, 60000}, creatures = {"predator"}, rewards = {{type = "exp", value = {50000000}},{type="item",value={8310, 1}},{type="item",value={10309, 1}},{type = "points", value = {5}}}},
	[17] = {killsRequired = 1300, raceName = "red goblin", level = {8, 60000}, creatures = {"red goblin"}, rewards = {{type = "exp", value = {50000000}},{type="item",value={8310, 1}},{type="item",value={5809, 1}},{type = "points", value = {5}}}},
	[18] = {killsRequired = 1400, raceName = "vandal", level = {8, 60000}, creatures = {"vandal"}, rewards = {{type = "exp", value = {50000000}},{type="item",value={8310, 2}},{type = "points", value = {5}}}},
	[19] = {killsRequired = 1500, raceName = "demon hunter", level = {8, 60000}, creatures = {"demon hunter"}, rewards = {{type = "exp", value = {50000000}},{type="item",value={8310, 1}},{type = "points", value = {5}}}},
	[20] = {killsRequired = 1600, raceName = "dilas", level = {8, 60000}, creatures = {"dilas"}, rewards = {{type = "exp", value = {50000000}},{type="item",value={8310, 2}},{type = "points", value = {5}}}},
	[21] = {killsRequired = 1700, raceName = "gostir", level = {8, 60000}, creatures = {"gostir"}, rewards = {{type = "exp", value = {50000000}},{type="item",value={2160, 50}},{type="item",value={8310, 2}},{type = "points", value = {5}}}},
	[22] = {killsRequired = 1800, raceName = "berros", level = {8, 60000}, creatures = {"berros"}, rewards = {{type = "exp", value = {50000000}},{type="item",value={2160, 50}},{type="item",value={8310, 2}},{type = "points", value = {5}}}},
	[25] = {killsRequired = 1900, raceName = "mage ghost", level = {8, 60000}, creatures = {"mege ghost"}, rewards = {{type = "exp", value = {50000000}},{type="item",value={2160, 100}},{type="item",value={8310, 3}},{type = "points", value = {5}}}},
	[34] = {killsRequired = 2000, raceName = "dragon mage", level = {8, 60000}, creatures = {"dragon mage"}, rewards = {{type = "exp", value = {50000000}},{type="item",value={2160, 100}},{type="item",value={8310, 3}},{type = "points", value = {5}}}},
	[23] = {killsRequired = 2100, raceName = "ron the raper", level = {8, 60000}, creatures = {"ron the raper"}, rewards = {{type = "exp", value = {50000000}},{type="item",value={2160, 77}},{type="item",value={8310, 3}},{type = "points", value = {5}}}},
	[24] = {killsRequired = 2200, raceName = "reborn minos", level = {8, 60000}, creatures = {"reborn minos"}, rewards = {{type = "exp", value = {50000000}},{type="item",value={2160, 50}},{type="item",value={8310, 1}},{type = "points", value = {5}}}},
	[25] = {killsRequired = 2300, raceName = "reborn elf", level = {8, 60000}, creatures = {"reborn elf"}, rewards = {{type = "exp", value = {50000000}},{type="item",value={2160, 50}},{type="item",value={8310, 3}},{type = "points", value = {5}}}},
	[26] = {killsRequired = 2400, raceName = "reborn ghoul", level = {8, 60000}, creatures = {"reborn ghoul"}, rewards = {{type = "exp", value = {50000000}},{type="item",value={2160, 50}},{type="item",value={8310, 3}},{type = "points", value = {5}}}},
	[27] = {killsRequired = 2500, raceName = "reborn frost", level = {8, 60000}, creatures = {"reborn frost"}, rewards = {{type = "exp", value = {50000000}},{type="item",value={2160, 50}},{type="item",value={8310, 3}},{type = "points", value = {5}}}},
	[28] = {killsRequired = 2600, raceName = "drakens", level = {8, 60000}, creatures = {"draken elite", "draken spellweaver", "draken warmaster", "draken abomination"}, rewards = {{type = "exp", value = {5000000}},{type="item",value={2160, 50}},{type="item",value={8310, 3}},{type = "points", value = {5}}}},
	[29] = {killsRequired = 2700, raceName = "reborn skeleton", level = {8, 60000}, creatures = {"reborn skeleton"}, rewards = {{type = "exp", value = {50000000}},{type="item",value={2160, 50}},{type="item",value={8310, 3}},{type = "points", value = {5}}}},
	[30] = {killsRequired = 2800, raceName = "reborn hero", level = {8, 60000}, creatures = {"reborn hero"}, rewards = {{type = "exp", value = {50000000}},{type="item",value={2160, 50}},{type="item",value={8310, 3}},{type = "points", value = {5}}}},
	[31] = {killsRequired = 2900, raceName = "reborn wyrm", level = {8, 60000}, creatures = {"reborn wyrm"}, rewards = {{type = "exp", value = {50000000}},{type="item",value={2160, 50}},{type="item",value={8310, 3}},{type = "points", value = {5}}}},
	[32] = {killsRequired = 3000, raceName = "reborn medusa", level = {8, 60000}, creatures = {"reborn medusa"}, rewards = {{type = "exp", value = {50000000}},{type="item",value={2160, 50}},{type="item",value={8310, 3}},{type = "points", value = {5}}}},
	[33] = {killsRequired = 3100, raceName = "reborn orc", level = {8, 60000}, creatures = {"reborn orc"}, rewards = {{type = "exp", value = {50000000}},{type="item",value={2160, 50}},{type="item",value={8310, 3}},{type = "points", value = {5}}}},
	[35] = {killsRequired = 3200, raceName = "reborn warlock", level = {8, 60000}, creatures = {"reborn warlock"}, rewards = {{type = "exp", value = {50000000}},{type="item",value={2160, 100}},{type="item",value={8310, 3}},{type = "points", value = {5}}}},
	[36] = {killsRequired = 3300, raceName = "vip bk", level = {8, 60000}, creatures = {"vip bk"}, rewards = {{type = "exp", value = {50000000}},{type="item",value={2160, 100}},{type="item",value={8310, 3}},{type = "points", value = {5}}}},
	[37] = {killsRequired = 3400, raceName = "vip bandit", level = {8, 60000}, creatures = {"vip bandit"}, rewards = {{type = "exp", value = {50000000}},{type="item",value={2160, 100}},{type="item",value={8310, 3}},{type = "points", value = {5}}}},
	[38] = {killsRequired = 3500, raceName = "vip pirate", level = {8, 60000}, creatures = {"vip pirate"}, rewards = {{type = "exp", value = {50000000}},{type="item",value={2160, 100}},{type="item",value={8310, 3}},{type = "points", value = {5}}}},
	[40] = {killsRequired = 100, raceName = "exp bug", level = {8, 60000}, creatures = {"exp bug"}, rewards = {{type = "storage", value = {Storage.bossRoom.demons, 1}},{type = "points", value = {5}}}},
	[41] = {killsRequired = 5000, raceName = "madpg the witch", level = {8, 60000}, creatures = {"madpg the witch"}, rewards = {{type = "exp", value = {41752050005}},{type="item",value={8310, 10}},{type = "points", value = {5}}}},
	[42] = {killsRequired = 5000, raceName = "sir pryk", level = {8, 60000}, creatures = {"sir pryk"}, rewards = {{type = "exp", value = {51752050005}},{type="item",value={8310, 10}},{type = "points", value = {5}}}},
	[43] = {killsRequired = 5000, raceName = "butt head", level = {8, 60000}, creatures = {"butt head"}, rewards = {{type = "exp", value = {61752050005}},{type="item",value={8310, 10}},{type = "points", value = {5}}}},
	[44] = {killsRequired = 5000, raceName = "butch", level = {8, 60000}, creatures = {"butch"}, rewards = {{type = "exp", value = {71752050005}},{type="item",value={8310, 10}},{type = "points", value = {5}}}},
	[45] = {killsRequired = 5000, raceName = "fury nomad", level = {8, 60000}, creatures = {"fury nomad"}, rewards = {{type = "exp", value = {81752050005}},{type="item",value={8310, 10}},{type = "points", value = {5}}}},
	[46] = {killsRequired = 5000, raceName = "fake santa", level = {8, 60000}, creatures = {"fake santa"}, rewards = {{type = "exp", value = {91752050005}},{type="item",value={8310, 10}},{type = "points", value = {5}}}},
	[47] = {killsRequired = 5000, raceName = "dark mage", level = {8, 60000}, creatures = {"dark mage"}, rewards = {{type = "exp", value = {101752050005}},{type="item",value={8310, 10}},{type = "points", value = {5}}}},
	[48] = {killsRequired = 5000, raceName = "bone knight", level = {8, 60000}, creatures = {"bone knight"}, rewards = {{type = "exp", value = {111752050005}},{type="item",value={8310, 10}},{type = "points", value = {5}}}},
	[49] = {killsRequired = 5000, raceName = "klux", level = {8, 60000}, creatures = {"klux"}, rewards = {{type = "exp", value = {121752050005}},{type="item",value={8310, 10}},{type = "points", value = {5}}}},
	[50] = {killsRequired = 5000, raceName = "belzi", level = {8, 60000}, creatures = {"belzi"}, rewards = {{type = "exp", value = {121752050005}},{type="item",value={8310, 10}},{type = "points", value = {5}}}},
	[51] = {killsRequired = 5000, raceName = "reborn fury", level = {8, 60000}, creatures = {"reborn fury"}, rewards = {{type = "exp", value = {141752050005}},{type="item",value={8310, 10}},{type = "points", value = {5}}}},

}

function Player.getTaskRank(self)
	return (self:getStorageValue(Storage.task.pointsTask) >= 100 and RANK_ELITEHUNTER 
	or self:getStorageValue(Storage.task.pointsTask) >= 70 and RANK_TROPHYHUNTER 
	or self:getStorageValue(Storage.task.pointsTask) >= 40 and RANK_BIGGAMEHUNTER 
	or self:getStorageValue(Storage.task.pointsTask) >= 20 and RANK_RANGER 
	or self:getStorageValue(Storage.task.pointsTask) >= 10 and RANK_HUNTSMAN 
	or self:getStorageValue(Storage.task.storageJoin) == 1 and RANK_JOIN 
	or RANK_NONE)
end

function Player.getTaskPoints(self)
	return math.max(self:getStorageValue(Storage.task.pointsTask), 0)
end

function getTaskByName(name, table)
	local t = (table and table or tasks)
	for k, v in pairs(t) do
		if v.name then
			if v.name:lower() == name:lower() then
				return k
			end
		else
			if v.raceName:lower() == name:lower() then
				return k
			end
		end
	end
	return false
end

function Player.getTasks(self)
	local canmake = {}
	local able = {}
	for k, v in pairs(tasks) do
		if self:getStorageValue(Storage.task.storageTaskBase + k) < 1 then
			able[k] = true
			if self:getLevel() < v.level[1] or self:getLevel() > v.level[2] then
				able[k] = false
			end
			if v.storage and self:getStorageValue(v.storage[1]) < v.storage[2] then
				able[k] = false
			end

			if v.rank then
				if self:getTaskRank() < v.rank then
					able[k] = false
				end
			end

			if v.premium then
				if not self:isPremium() then
					able[k] = false
				end
			end

			if able[k] then
				canmake[#canmake + 1] = k
			end
		end
	end
	return canmake
end

function Player.canStartTask(self, name, table)
	local v = ""
	local id = 0
	local t = (table and table or tasks)
	for k, i in pairs(t) do
		if i.name then
			if i.name:lower() == name:lower() then
				v = i
				id = k
				break
			end
		else
			if i.raceName:lower() == name:lower() then
				v = i
				id = k
				break
			end
		end
	end
	if v == "" then
		return false
	end
	if self:getStorageValue(Storage.task.storageTaskBase + id) > 0 then
		return false
	end
	if v.level and self:getLevel() < v.level[1] and self:getLevel() > v.level[2] then
		return false
	end
	if v.premium and not self:isPremium() then
		return false
	end
	if v.rank and self:getTaskRank() < v.rank then
		return false
	end
	if v.storage and self:getStorageValue(v.storage[1]) < v.storage then
		return false
	end
	return true
end

function Player.getStartedTasks(self)
	local tmp = {}
	for k, v in pairs(tasks) do
		if self:getStorageValue(Storage.task.storageTaskBase + k) > 0 and self:getStorageValue(Storage.task.storageTaskBase + k) < 2 then
			tmp[#tmp + 1] = k
		end
	end
	return tmp
end