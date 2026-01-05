dofile('data/scripts/custom/tasks.lua')

-- ModalWindow may not be available on this build; guard to avoid runtime errors
TaskModalSession = TaskModalSession or {}
TaskModal = TaskModal or {}

if not ModalWindow then
    print('[TaskModal] ModalWindow API not available; falling back to text dialog.')
    function TaskModal.sendList(player)
        player:sendTextMessage(MESSAGE_STATUS_SMALL, 'Modal windows are not supported on this server build. Use text dialog with Grizzly Adams.')
    end
    function TaskModal.sendDetail(player)
        player:sendTextMessage(MESSAGE_STATUS_SMALL, 'Modal windows are not supported on this server build. Use text dialog with Grizzly Adams.')
    end
    return
end

local LIST_MODAL = 5000
local DETAIL_MODAL = 5001
local PAGE_SIZE = 15

local function formatRewards(task)
    local parts = {}
    for _, reward in ipairs(task.rewards or {}) do
        if reward.type == 'exp' then
            parts[#parts + 1] = string.format('%d exp', reward.amount)
        elseif reward.type == 'gold' then
            parts[#parts + 1] = string.format('%d gold', reward.amount)
        elseif reward.type == 'item' then
            parts[#parts + 1] = string.format('%dx %s', reward.amount, ItemType(reward.id):getName())
        elseif reward.type == 'boss' then
            parts[#parts + 1] = 'boss: ' .. reward.name
        end
    end
    return #parts > 0 and table.concat(parts, ', ') or 'None'
end

local function taskStatus(player, task)
    local activeId = player:getStorageValue(STORAGE_ACTIVE_TASK)
    local kills = math.max(0, player:getStorageValue(STORAGE_KILLCOUNT))
    local status = 'Available'
    if activeId == task.id then
        status = kills >= task.count and 'Ready to report' or 'Active'
    end
    return status, kills
end

local function giveRewards(player, task)
    for _, reward in ipairs(task.rewards or {}) do
        if reward.type == 'exp' then
            player:addExperience(reward.amount)
        elseif reward.type == 'gold' then
            player:addItem(2148, reward.amount)
        elseif reward.type == 'item' then
            player:addItem(reward.id, reward.amount)
        elseif reward.type == 'boss' then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You have unlocked boss: ' .. reward.name .. '!')
        end
    end
end

local function startTask(player, task)
    local activeId = player:getStorageValue(STORAGE_ACTIVE_TASK)
    if activeId > 0 and activeId ~= task.id then
        local active = TASKS[activeId]
        local kills = math.max(0, player:getStorageValue(STORAGE_KILLCOUNT))
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format('You already have task: %s (%d/%d). Cancel or report it first.', active and active.name or 'unknown', kills, active and active.count or 0))
        return false
    end
    player:setStorageValue(STORAGE_ACTIVE_TASK, task.id)
    player:setStorageValue(STORAGE_KILLCOUNT, 0)
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, string.format('[Task] Started: %s. Kill %d %s.', task.name, task.count, task.monster))
    return true
end

local function reportTask(player, task)
    local activeId = player:getStorageValue(STORAGE_ACTIVE_TASK)
    if activeId ~= task.id then
        player:sendTextMessage(MESSAGE_STATUS_SMALL, 'This is not your active task.')
        return false
    end
    local kills = math.max(0, player:getStorageValue(STORAGE_KILLCOUNT))
    if kills < task.count then
        player:sendTextMessage(MESSAGE_STATUS_SMALL, string.format('Progress %d/%d. Keep hunting!', kills, task.count))
        return false
    end
    giveRewards(player, task)
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, string.format('[Task] Completed %s. Rewards delivered.', task.name))
    player:setStorageValue(STORAGE_ACTIVE_TASK, -1)
    player:setStorageValue(STORAGE_KILLCOUNT, -1)
    return true
end

local function cancelTask(player, task)
    local activeId = player:getStorageValue(STORAGE_ACTIVE_TASK)
    if activeId ~= task.id then
        player:sendTextMessage(MESSAGE_STATUS_SMALL, 'You have no active task to cancel here.')
        return false
    end
    player:setStorageValue(STORAGE_ACTIVE_TASK, -1)
    player:setStorageValue(STORAGE_KILLCOUNT, -1)
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, string.format('[Task] Cancelled %s.', task.name))
    return true
end

local function sortedTaskIds()
    local ids = {}
    for id in pairs(TASKS) do
        ids[#ids + 1] = id
    end
    table.sort(ids)
    return ids
end

local function sendList(player, page)
    local ids = sortedTaskIds()
    local maxPage = math.max(1, math.ceil(#ids / PAGE_SIZE))
    page = math.max(1, math.min(page, maxPage))
    local modal = ModalWindow(LIST_MODAL, 'Grizzly Adams Tasks', string.format('Select a task to manage. Page %d/%d', page, maxPage))

    local startIndex = (page - 1) * PAGE_SIZE + 1
    local endIndex = math.min(#ids, page * PAGE_SIZE)
    for i = startIndex, endIndex do
        local task = TASKS[ids[i]]
        local status, kills = taskStatus(player, task)
        modal:addChoice(task.id, string.format('#%d %s [%s] %d/%d', task.id, task.name, status, kills, task.count))
    end

    modal:addButton(1, 'Open')
    modal:addButton(2, 'Prev')
    modal:addButton(3, 'Next')
    modal:addButton(4, 'Close')
    modal:setDefaultEnterButton(1)
    modal:setDefaultEscapeButton(4)

    player:registerEvent('TaskModal')
    player:sendModalWindow(modal)
    TaskModalSession[player:getGuid()] = { page = page }
end

local function sendDetail(player, taskId)
    local task = TASKS[taskId]
    local session = TaskModalSession[player:getGuid()] or { page = 1 }
    if not task then
        sendList(player, session.page)
        return
    end

    local status, kills = taskStatus(player, task)
    local body = string.format('Kill %d %s.\nStatus: %s (%d/%d)\nRewards: %s', task.count, task.monster, status, kills, task.count, formatRewards(task))

    local modal = ModalWindow(DETAIL_MODAL, string.format('Task #%d: %s', task.id, task.name), body)
    modal:addChoice(task.id, task.name)
    modal:addButton(1, 'Start')
    modal:addButton(2, 'Report')
    modal:addButton(3, 'Cancel')
    modal:addButton(4, 'Back')
    modal:addButton(5, 'Close')
    modal:setDefaultEnterButton(1)
    modal:setDefaultEscapeButton(5)

    player:registerEvent('TaskModal')
    player:sendModalWindow(modal)
    TaskModalSession[player:getGuid()] = { page = session.page, detail = task.id }
end

TaskModal.sendList = sendList
TaskModal.sendDetail = sendDetail

function onModalWindow(player, modalId, buttonId, choiceId)
    if modalId ~= LIST_MODAL and modalId ~= DETAIL_MODAL then
        return false
    end

    local session = TaskModalSession[player:getGuid()] or { page = 1 }

    if modalId == LIST_MODAL then
        if buttonId == 1 and choiceId > 0 then
            sendDetail(player, choiceId)
        elseif buttonId == 2 then
            sendList(player, session.page - 1)
        elseif buttonId == 3 then
            sendList(player, session.page + 1)
        end
        return true
    end

    if modalId == DETAIL_MODAL then
        local task = TASKS[choiceId]
        if not task then
            sendList(player, session.page)
            return true
        end

        if buttonId == 1 then
            startTask(player, task)
            sendDetail(player, task.id)
        elseif buttonId == 2 then
            reportTask(player, task)
            sendDetail(player, task.id)
        elseif buttonId == 3 then
            cancelTask(player, task)
            sendDetail(player, task.id)
        elseif buttonId == 4 then
            sendList(player, session.page)
        end
        return true
    end

    return true
end
