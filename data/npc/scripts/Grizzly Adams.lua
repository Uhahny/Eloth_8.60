local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, t, msg) npcHandler:onCreatureSay(cid, t, msg) end
function onThink() npcHandler:onThink() end

-- funkcja nagradzania
local function giveRewards(player, rewards)
    for _, reward in ipairs(rewards) do
        if reward.type == "exp" then
            player:addExperience(reward.amount)
        elseif reward.type == "gold" then
            player:addItem(2148, reward.amount) -- gold coins
        elseif reward.type == "item" then
            player:addItem(reward.id, reward.amount)
        elseif reward.type == "boss" then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have unlocked boss: " .. reward.name .. "!")
            -- tutaj możesz np. ustawić storage żeby gracz miał dostęp do TP
        end
    end
end

-- callback
function creatureSayCallback(cid, type, msg)
    local player = Player(cid)
    if not npcHandler:isFocused(cid) then
        return false
    end

    msg = msg:lower()

    -- LISTA TASKÓW
    if msgcontains(msg, "list") then
        local text = "Available tasks:\n"
        for id, task in pairs(TASKS) do
            local rewards = {}
            for _, r in ipairs(task.rewards) do
                if r.type == "exp" then
                    table.insert(rewards, r.amount .. " exp")
                elseif r.type == "gold" then
                    table.insert(rewards, r.amount .. " gold")
                elseif r.type == "boss" then
                    table.insert(rewards, "boss: " .. r.name)
                elseif r.type == "item" then
                    table.insert(rewards, r.amount .. "x " .. ItemType(r.id):getName())
                end
            end
            text = text .. id .. ". " .. task.name .. " (" .. task.count .. " " .. task.monster .. ") → " .. table.concat(rewards, ", ") .. "\n"
        end
        npcHandler:say(text, cid)

    -- WYBÓR TASKA
    elseif msgcontains(msg, "task") then
        local parts = msg:split(" ")
        local id = tonumber(parts[2])
        if not id or not TASKS[id] then
            npcHandler:say("Please say 'task <number>'. For example: task 3", cid)
            return true
        end
        local active = player:getStorageValue(STORAGE_ACTIVE_TASK)
        if active > 0 then
            npcHandler:say("You are already on a task. Report it first.", cid)
            return true
        end
        player:setStorageValue(STORAGE_ACTIVE_TASK, id)
        player:setStorageValue(STORAGE_KILLCOUNT, 0)
        npcHandler:say("You have started task: " .. TASKS[id].name .. ". Kill " .. TASKS[id].count .. " " .. TASKS[id].monster .. ".", cid)

    -- RAPORT
    elseif msgcontains(msg, "report") then
        local active = player:getStorageValue(STORAGE_ACTIVE_TASK)
        if active < 1 then
            npcHandler:say("You don't have an active task.", cid)
            return true
        end
        local task = TASKS[active]
        local kills = player:getStorageValue(STORAGE_KILLCOUNT)
        if kills >= task.count then
            npcHandler:say("Great job! You have finished " .. task.name .. ".", cid)
            giveRewards(player, task.rewards)
            player:setStorageValue(STORAGE_ACTIVE_TASK, 0) -- reset
            player:setStorageValue(STORAGE_KILLCOUNT, 0)
        else
            npcHandler:say("Progress: " .. kills .. "/" .. task.count .. " " .. task.monster .. ".", cid)
        end
    end

    return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())

-- helper do rozbijania tekstu
function string:split(sep)
    local result = {}
    for part in self:gmatch("[^"..sep.."]+") do
        table.insert(result, part)
    end
    return result
end