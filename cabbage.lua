local Class = require 'lib/middleclass'
local Object = require 'object'
local Cabbage = Class('Cabbage', Object)

Cabbage.static.IMAGE = love.graphics.newImage('asset/cabbage.png')
Cabbage.static.IDLE = love.graphics.newQuad(0, 0, 16, 16, Cabbage.static.IMAGE:getDimensions())

function Cabbage:initialize(level, r, c)
    Object.initialize(self, level, r, c)
end

function Cabbage:update(dt)

end

function Cabbage:draw()
    love.graphics.draw(Cabbage.static.IMAGE, Cabbage.static.IDLE, 16*self.c-16, 16*self.r-16)
end

return Cabbage