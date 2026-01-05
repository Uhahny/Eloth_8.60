local TEXTCOLOR = {
    BLACK = 0,
    BLUE = 5,
    GREEN = 18,
    LIGHTGREEN = 66,
    DARKBROWN = 78,
    LIGHTBLUE = 89,
    MAYABLUE = 95,
    DARKRED = 108,
    DARKPURPLE = 112,
    BROWN = 120,
    GREY = 129,
    TEAL = 143,
    DARKPINK = 152,
    PURPLE = 154,
    DARKORANGE = 156,
    RED = 180,
    PINK = 190,
    ORANGE = 192,
    DARKYELLOW = 205,
    YELLOW = 210,
    WHITE = 215,
    NONE = 255,
}

local effects = {
    {position = Position(32358, 32243, 6), text = 'Citizen', effects = {CONST_ME_TUTORIALARROW}, textColor = TEXTCOLOR.WHITE},
    {position = Position(32365, 32236, 7), text = 'Training', effects = {CONST_ME_TUTORIALARROW}, textColor = TEXTCOLOR.WHITE},


    {position = Position(32353, 32218, 7), text = 'War Cities', effects = {29,11}, textColor = TEXTCOLOR.YELLOW},
    {position = Position(32351, 32218, 7), text = 'Hunting Arena', effects = {29,11}, textColor = TEXTCOLOR.YELLOW},
    {position = Position(32349, 32218, 7), text = 'Boss Room', effects = {29,11}, textColor = TEXTCOLOR.YELLOW},

    {position = Position(32364, 32243, 7), text = 'WAR Blue', effects = {29,11}, textColor = TEXTCOLOR.YELLOW},
    {position = Position(32374, 32243, 7), text = 'WAR Red', effects = {29,11}, textColor = TEXTCOLOR.YELLOW},

    
}

function onThink(creature, interval)
    for i = 1, #effects do
        local settings = effects[i]
        local spectators = Game.getSpectators(settings.position, false, true, 7, 7, 5, 5)
        if #spectators > 0 then
            if settings.text then
                Game.sendAnimatedText(settings.text, settings.position, settings.textColor)
            end
            for _, effect in ipairs(settings.effects) do
                settings.position:sendMagicEffect(effect)
            end
        end
    end
    return true
end

