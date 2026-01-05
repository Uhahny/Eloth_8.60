local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

local talkState = {}

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

-- Load shared tasks + storages
dofile('data/scripts/custom/tasks.lua')

local function normalize(str)
    return str:lower():gsub("%s+", "")
end

local function showTasks(player, cid)
    local text = "Available tasks:\n"
    for id, task in pairs(TASKS) do
        text = text .. string.format("%d) %s — kill %d %s\n", id, task.name, task.count, task.monster)
    end
    npcHandler:say(text .. "Say the number or task name to start. You can say {report} to claim rewards, or {cancel} to abandon your current task.", cid)
end

local function tryStartTask(player, cid, selector)
    local chosen
    local n = tonumber(selector)
    if n and TASKS[n] then
        chosen = TASKS[n]
    else
        local key = normalize(selector)
        for _, task in pairs(TASKS) do
            if normalize(task.name) == key or normalize(task.monster) == key then
                chosen = task; break
            end
        end
    end
    if not chosen then
        npcHandler:say("I don't recognize that task. Say {task} to see the list again.", cid)
        return
    end

    local activeId = player:getStorageValue(STORAGE_ACTIVE_TASK)
    if activeId > 0 then
        local active = TASKS[activeId]
        local killed = math.max(0, player:getStorageValue(STORAGE_KILLCOUNT))
        if active then
            if killed >= active.count then
                npcHandler:say(
                    string.format("You already finished your current task (%s). Say {report} first to claim your reward.", active.name),
                    cid
                )
            else
                npcHandler:say(
                    string.format("You already have an active task (%s). Progress: %d/%d. Finish it, {report} when done, or {cancel} to abandon it.",
                                  active.name, killed, active.count),
                    cid
                )
            end
        else
            npcHandler:say("Your task data seems invalid. I'll reset it. Say {task} to start again.", cid)
            player:setStorageValue(STORAGE_ACTIVE_TASK, -1)
            player:setStorageValue(STORAGE_KILLCOUNT, -1)
        end
        return
    end

    player:setStorageValue(STORAGE_ACTIVE_TASK, chosen.id)
    player:setStorageValue(STORAGE_KILLCOUNT, 0)
    npcHandler:say(string.format("Task started: %s — kill %d %s. Good luck!", chosen.name, chosen.count, chosen.monster), cid)
end

local function checkTask(player, cid)
    local taskId = player:getStorageValue(STORAGE_ACTIVE_TASK)
    if taskId <= 0 then
        npcHandler:say("You don't have an active task. Say {task} to see available tasks.", cid)
        return
    end
    local task = TASKS[taskId]
    if not task then
        npcHandler:say("Your task data seems invalid. I'll reset it. Start again with {task}.", cid)
        player:setStorageValue(STORAGE_ACTIVE_TASK, -1)
        player:setStorageValue(STORAGE_KILLCOUNT, -1)
        return
    end

    local killed = math.max(0, player:getStorageValue(STORAGE_KILLCOUNT))
    if killed >= task.count then
        if task.rewardExp and task.rewardExp > 0 then player:addExperience(task.rewardExp) end
        if task.rewardItem and task.rewardItem.id and task.rewardItem.count then player:addItem(task.rewardItem.id, task.rewardItem.count) end
        if task.rewardMoney and task.rewardMoney > 0 then player:addMoney(task.rewardMoney) end

        npcHandler:say(string.format("Congratulations! You completed the task: %s. Rewards granted.", task.name), cid)
        player:setStorageValue(STORAGE_ACTIVE_TASK, -1)
        player:setStorageValue(STORAGE_KILLCOUNT, -1)
    else
        npcHandler:say(string.format("Progress: %d/%d %s killed.", killed, task.count, task.monster), cid)
    end
end

local function promptCancel(player, cid)
    local taskId = player:getStorageValue(STORAGE_ACTIVE_TASK)
    if taskId <= 0 then
        npcHandler:say("You don't have an active task to cancel.", cid)
        return false
    end
    local task = TASKS[taskId]
    if not task then
        npcHandler:say("Your task data seems invalid. I'll reset it now.", cid)
        player:setStorageValue(STORAGE_ACTIVE_TASK, -1)
        player:setStorageValue(STORAGE_KILLCOUNT, -1)
        return false
    end
    local killed = math.max(0, player:getStorageValue(STORAGE_KILLCOUNT))
    npcHandler:say(string.format(
        "Do you really want to abandon your current task (%s)? You will lose your progress (%d/%d). Say {yes} to confirm or {no} to keep it.",
        task.name, killed, task.count
    ), cid)
    return true
end

function creatureSayCallback(cid, type, msg)
    if not npcHandler:isFocused(cid) then return false end
    local player = Player(cid)
    local talkUser = cid
    local m = msg:lower()

    -- greet
    if m:find("hi") or m:find("hello") then
        npcHandler:say("Hello! Say {task} for available tasks, {report} to claim rewards, or {cancel} to abandon your current task.", cid)

    -- list tasks
    elseif m:find("task") and not m:find("report") then
        talkState[talkUser] = 1
        showTasks(player, cid)

    -- start by selection when waiting for task choice
    elseif talkState[talkUser] == 1 then
        tryStartTask(player, cid, msg)
        talkState[talkUser] = 0

    -- report / claim
    elseif m:find("report") then
        checkTask(player, cid)
        talkState[talkUser] = 0

    -- cancel prompt
    elseif m:find("cancel") or m:find("abandon") or m:find("give up") then
        if promptCancel(player, cid) then
            talkState[talkUser] = 2  -- waiting for yes/no
        else
            talkState[talkUser] = 0
        end

    -- confirmation for cancel
    elseif talkState[talkUser] == 2 and (m == "yes" or m == "y") then
        player:setStorageValue(STORAGE_ACTIVE_TASK, -1)
        player:setStorageValue(STORAGE_KILLCOUNT, -1)
        npcHandler:say("Your task has been abandoned. You can choose a new one with {task}.", cid)
        talkState[talkUser] = 0

    elseif talkState[talkUser] == 2 and (m == "no" or m == "n") then
        npcHandler:say("Alright, your current task remains active.", cid)
        talkState[talkUser] = 0
    end

    return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
