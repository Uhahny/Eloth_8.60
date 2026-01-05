local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

-- Load shared tasks + storages
dofile('data/scripts/custom/tasks.lua')

local HAS_MODAL = ModalWindow ~= nil
if HAS_MODAL then
    dofile('data/creaturescripts/scripts/task_modal.lua') -- guarded inside for missing ModalWindow
end

local function log(fmt, ...)
    print(string.format('[GrizzlyTasks] ' .. fmt, ...))
end

local function msgcontains(txt, keyword)
    return txt:lower():find(keyword:lower()) ~= nil
end

local function sortedTaskIds()
    local ids = {}
    for id in pairs(TASKS) do
        ids[#ids + 1] = id
    end
    table.sort(ids)
    return ids
end

local function findTaskByName(fragment)
    local needle = fragment:lower()
    for _, id in ipairs(sortedTaskIds()) do
        local task = TASKS[id]
        local name = task.name:lower()
        if name == needle or name:find(needle, 1, true) then
            return task
        end
    end
    return nil
end

local function giveRewards(player, rewards)
    for _, reward in ipairs(rewards) do
        if reward.type == "exp" then
            player:addExperience(reward.amount)
        elseif reward.type == "gold" then
            player:addItem(2148, reward.amount)
        elseif reward.type == "item" then
            player:addItem(reward.id, reward.amount)
        elseif reward.type == "boss" then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have unlocked boss: " .. reward.name .. "!")
        end
    end
end

local function listTasksText()
    local lines = {"Available tasks:"}
    for _, id in ipairs(sortedTaskIds()) do
        local task = TASKS[id]
        lines[#lines + 1] = string.format('%2d) %-26s (%4d %s)', id, task.name, task.count, task.monster)
    end
    lines[#lines + 1] = "Say 'task <number or name>' to start. 'report' to claim. 'cancel' to abandon."
    return table.concat(lines, "\n")
end

local function startTask(player, task)
    local active = player:getStorageValue(STORAGE_ACTIVE_TASK)
    if active > 0 then
        local activeTask = TASKS[active]
        local kills = math.max(0, player:getStorageValue(STORAGE_KILLCOUNT))
        player:sendTextMessage(MESSAGE_STATUS_SMALL, string.format("You already have %s (%d/%d). 'report' or 'cancel' first.", activeTask and activeTask.name or 'a task', kills, activeTask and activeTask.count or 0))
        return false
    end
    player:setStorageValue(STORAGE_ACTIVE_TASK, task.id)
    player:setStorageValue(STORAGE_KILLCOUNT, 0)
    log('Player %s started task %s (#%d)', player:getName(), task.name, task.id)
    npcHandler:say(string.format("Task started: %s. Kill %d %s.", task.name, task.count, task.monster), player)
    return true
end

local function reportTask(player)
    local active = player:getStorageValue(STORAGE_ACTIVE_TASK)
    local task = TASKS[active]
    if not task then
        npcHandler:say("You have no active task.", player)
        player:setStorageValue(STORAGE_ACTIVE_TASK, -1)
        player:setStorageValue(STORAGE_KILLCOUNT, -1)
        return
    end
    local kills = math.max(0, player:getStorageValue(STORAGE_KILLCOUNT))
    if kills >= task.count then
        giveRewards(player, task.rewards)
        log('Player %s completed task %s (#%d)', player:getName(), task.name, task.id)
        npcHandler:say(string.format("Completed %s. Rewards delivered!", task.name), player)
        player:setStorageValue(STORAGE_ACTIVE_TASK, -1)
        player:setStorageValue(STORAGE_KILLCOUNT, -1)
    else
        npcHandler:say(string.format("Progress: %d/%d %s.", kills, task.count, task.monster), player)
    end
end

local function cancelTask(player)
    local active = player:getStorageValue(STORAGE_ACTIVE_TASK)
    if active <= 0 then
        npcHandler:say("You have no active task.", player)
        return
    end
    local task = TASKS[active]
    log('Player %s cancelled task %s (#%d)', player:getName(), task and task.name or 'unknown', active)
    player:setStorageValue(STORAGE_ACTIVE_TASK, -1)
    player:setStorageValue(STORAGE_KILLCOUNT, -1)
    npcHandler:say(string.format("Task %s cancelled.", task and task.name or ''), player)
end

function creatureSayCallback(cid, type, msg)
    if not npcHandler:isFocused(cid) then
        return false
    end

    local player = Player(cid)
    local text = msg:lower()

    if msgcontains(text, 'hi') or msgcontains(text, 'hello') then
        if HAS_MODAL and TaskModal and TaskModal.sendList then
            npcHandler:say('Opening task manager.', cid)
            TaskModal.sendList(player, 1)
        else
            npcHandler:say("Hi! Say 'task' for list, 'task <number or name>' to start, 'report' to finish, 'cancel' to abandon.", cid)
            npcHandler:say(listTasksText(), cid)
        end
        return true
    end

    local selection = text:match('tasks?%s+(.+)')
    if selection then
        selection = selection:match('^%s*(.-)%s*$') -- trim
        local task
        local asNumber = tonumber(selection)
        if asNumber and TASKS[asNumber] then
            task = TASKS[asNumber]
        else
            task = findTaskByName(selection)
        end

        if not task then
            npcHandler:say("No such task id or name. Say 'task' to list.", cid)
            return true
        end

        startTask(player, task)
        return true
    end

    if HAS_MODAL and (msgcontains(text, 'task') or msgcontains(text, 'mission') or msgcontains(text, 'lista')) then
        TaskModal.sendList(player, 1)
        return true
    end

    -- text fallback flow
    if msgcontains(text, 'task') then
        npcHandler:say(listTasksText(), cid)
        return true
    end

    if msgcontains(text, 'report') then
        reportTask(player)
        return true
    end

    if msgcontains(text, 'cancel') or msgcontains(text, 'abandon') then
        cancelTask(player)
        return true
    end

    return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
