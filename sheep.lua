local Class = require 'lib/middleclass'
local Object = require 'object'
local Sheep = Class('Sheep', Object)

Sheep.static.IMAGE = love.graphics.newImage('asset/sheep.png')
Sheep.static.IDLE = love.graphics.newQuad(0, 0, 16, 16, Sheep.static.IMAGE:getDimensions())

function Sheep:initialize(level, r, c)
    Object.initialize(self, level, r, c)
end

function Sheep:update(dt)

end

function Sheep:draw()
    love.graphics.draw(Sheep.static.IMAGE, Sheep.static.IDLE, 16*self.c-16, 16*self.r-16)
end

return Sheep