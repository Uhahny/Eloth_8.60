local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_EARTHDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_SMALLPLANTS)
combat:setArea(createCombatArea(AREA_CIRCLE6X6))

function onGetFormulaValues(player, level, magicLevel)
	local min = (level / 5) + (magicLevel * 3) + 32
	local max = (level / 5) + (magicLevel * 9) + 40
	return -min, -max
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

function onCastSpell(creature, variant)

    -- [[ Auto-inserted guard: block casting if 10+ players are on screen ]]
    local __pos = nil
    local __plr = nil
    if creature and type(creature) == "userdata" and creature.getPosition then
        __pos = creature:getPosition()
        if creature.getPlayer then __plr = creature:getPlayer() end
    end
    if not __pos and cid ~= nil then
        if type(Player) == "function" then __plr = Player(cid) end
        if __plr and __plr.getPosition then __pos = __plr:getPosition() end
        if not __pos and type(getCreaturePosition) == "function" then __pos = getCreaturePosition(cid) end
    end
    if __pos then
        local __spectators = Game.getSpectators(__pos, false, true, 8, 8, 8, 8)
        if #__spectators >= 10 then
            if __plr and __plr.sendCancelMessage then
                __plr:sendCancelMessage("Too many players are on the screen. You cannot use this spell now.")
            elseif cid ~= nil and type(doPlayerSendCancel) == "function" then
                doPlayerSendCancel(cid, "Too many players are on the screen. You cannot use this spell now.")
            end
            __pos:sendMagicEffect(CONST_ME_POFF)
            return false
        end
    end
	return combat:execute(creature, variant)
end
