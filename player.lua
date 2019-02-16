local Class = require 'lib/middleclass'
local Object = require 'object'
local Player = Class('Player', Object)

Player.static.IMAGE = love.graphics.newImage('asset/player.png')
Player.static.IDLE = love.graphics.newQuad(0, 0, 16, 16, Player.static.IMAGE:getDimensions())

function Player:initialize(level, r, c)
    Object.initialize(self, level, r, c)
end

function Player:update(dt)

end

function Player:draw()
    love.graphics.draw(Player.static.IMAGE, Player.static.IDLE, 16*self.c-16, 16*self.r-16)
end

return Player