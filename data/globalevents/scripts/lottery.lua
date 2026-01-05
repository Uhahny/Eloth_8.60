-- Lottery System (TFS 1.5) by vDk (modified)
local config = {
    lottery_hour = "3 Hours", -- tylko do wiadomości (realny czas ustawiasz w globalevents.xml)
    crystal_coin_id = 2160, -- ID Crystal Coin
    reward_count = 5, -- ile cc dostaje zwycięzca
    website = true -- zapisywać wynik do bazy danych
}

function onThink(interval, lastExecution)
    local players = Game.getPlayers()
    if #players == 0 then
        return true -- brak graczy online
    end

    -- Wylosowanie zwycięzcy
    local winner = players[math.random(#players)]
    local winnerName = winner:getName()

    -- Dodanie nagrody
    winner:addItem(config.crystal_coin_id, config.reward_count)

    -- Broadcast
    Game.broadcastMessage("[LOTTERY] Winner: " .. winnerName .. " | Reward: " .. config.reward_count .. " Crystal Coins! Congratulations! (Next lottery in " .. config.lottery_hour .. ")", MESSAGE_EVENT_ADVANCE)

    -- Zapis do bazy (jeśli włączony)
    if config.website then
        db.query("INSERT INTO `lottery` (`name`, `item`) VALUES (" ..
            db.escapeString(winnerName) .. ", " ..
            db.escapeString(config.reward_count .. " Crystal Coins") .. ");")
    end

    return true
end