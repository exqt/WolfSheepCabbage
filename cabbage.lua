local Class = require 'lib/middleclass'
local Object = require 'object'
local Cabbage = Class('Cabbage', Object)

local IMAGE = love.graphics.newImage('asset/cabbage.png')
local QUAD = love.graphics.newQuad(0, 0, 16, 16, IMAGE:getDimensions())

Cabbage.static.drawGoal = function(r, c)
    local cr, cg, cb, ca = love.graphics.getColor()
    love.graphics.setColor(0, 0, 0, 0.2)
    love.graphics.draw(IMAGE, QUAD, 16*c-16, 16*r-16)
    love.graphics.setColor(cr, cg, cb, ca)
end

function Cabbage:initialize(level, r, c)
    Object.initialize(self, level, r, c)
end

function Cabbage:update(dt)

end

function Cabbage:draw()
    love.graphics.draw(IMAGE, QUAD, 16*self.c-16, 16*self.r-16)
end

return Cabbage