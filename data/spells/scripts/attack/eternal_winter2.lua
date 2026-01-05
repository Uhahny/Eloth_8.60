local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ICETORNADO)
combat:setArea(createCombatArea(AREA_CIRCLE5X5))

function onGetFormulaValues(player, level, magicLevel)
	local min = (level / 5) + (magicLevel * 5.5) + 25
	local max = (level / 5) + (magicLevel * 11) + 50
	return -min, -max
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

function onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end

    local spectators = Game.getSpectators(player:getPosition(), false, true, 8, 8, 8, 8)
    if #spectators >= 10 then
        player:sendCancelMessage("Too many players are on the screen. You cannot use this spell now.")
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        return false
    end
