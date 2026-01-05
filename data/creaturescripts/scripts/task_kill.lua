dofile('data/scripts/custom/tasks.lua')

-- Set this in your tasks.lua if you want to toggle console messages
-- TASK_PROGRESS_CONSOLE = true

function onKill(creature, target)
    local player = creature and creature:getPlayer() or nil
    if not player or not target or not target:isMonster() then
        return true
    end

    -- ignore player-summoned monsters (optional)
    local master = target:getMaster()
    if master and master:isPlayer() then
        return true
    end

    local taskId = player:getStorageValue(STORAGE_ACTIVE_TASK)
    if taskId <= 0 then
        return true
    end

    local task = TASKS[taskId]
    if not task then
        return true
    end

    if target:getName():lower() == task.monster:lower() then
        local killed = math.max(0, player:getStorageValue(STORAGE_KILLCOUNT))
        if killed < task.count then
            killed = killed + 1
            player:setStorageValue(STORAGE_KILLCOUNT, killed)

            if TASK_PROGRESS_CONSOLE then
                local remaining = math.max(0, task.count - killed)
                local msg = string.format("[Task] %s: %d/%d killed (%d remaining).",
                                          task.name, killed, task.count, remaining)
                player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, msg)
            end
        end
    end
    return true
end
