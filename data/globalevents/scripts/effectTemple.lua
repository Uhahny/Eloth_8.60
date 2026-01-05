local path1 = {
    Position(32368, 32240, 7),
    Position(32369, 32240, 7),
    Position(32370, 32240, 7)
}

local path2 = {
    Position(32368, 32242, 7),
    Position(32369, 32242, 7),
    Position(32370, 32242, 7)
}

local path3 = {
    Position(32369, 32240, 7),
    Position(32368, 32240, 7),
    Position(32370, 32240, 7)
}

local path4 = {
    Position(32369, 32242, 7),
    Position(32368, 32242, 7),
    Position(32370, 32242, 7)
}

local function animateEffect(path, effect, index)
    if index > #path then return end
    path[index]:sendMagicEffect(effect)
    addEvent(animateEffect, 200, path, effect, index + 1) -- 200 ms miedzy krokami
end

function onThink(interval)
    animateEffect(path1, CONST_ME_FIREAREA, 1)
    animateEffect(path2, CONST_ME_FIREAREA, 1)
    addEvent(function()
        animateEffect(path3, CONST_ME_ENERGYHIT, 1)
        animateEffect(path4, CONST_ME_ENERGYHIT, 1)
    end, 1500)
    return true
end
