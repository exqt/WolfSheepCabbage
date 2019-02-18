local Class = require 'lib/middleclass'
local anim8 = require 'lib/anim8'
local Object = require 'object'
local Sheep = Class('Sheep', Object)

local IMAGE = love.graphics.newImage('asset/sheep.png')
local GOAL_QUAD = love.graphics.newQuad(0, 0, 16, 16, IMAGE:getDimensions())

Sheep.static.drawGoal = function(r, c)
    local cr, cg, cb, ca = love.graphics.getColor()
    love.graphics.setColor(0, 0, 0, 0.2)
    love.graphics.draw(IMAGE, GOAL_QUAD, 16*c-16, 16*r-16)
    love.graphics.setColor(cr, cg, cb, ca)
end

function Sheep:initialize(level, r, c)
    Object.initialize(self, level, r, c)

    self.status = "IDLE"
    self.grid = anim8.newGrid(16, 16, IMAGE:getDimensions())
    self.animation = {
        IDLE = anim8.newAnimation(self.grid('1-1', 1), 1),
        EXCITED = anim8.newAnimation(self.grid('1-2', 1), 0.3)
    }
end

function Sheep:update(dt)
    local objs = self:getAdjacentObjects(8)
    local isPlayerNearby = false
    local cDir = nil
    self.status = "IDLE"

    for i, o in pairs(objs) do
        if o == nil then
            -- pass
        elseif o.class.name == "Player" then
            isPlayerNearby = true
        elseif o.class.name == "Cabbage" and i <= 4 then
            cDir = i
        end
    end

    if not isPlayerNearby and cDir then
        self:removeObjectAndMove(cDir)
    elseif isPlayerNearby and cDir then
        self.status = "EXCITED"
    end

    self.animation[self.status]:update(dt)
end

function Sheep:draw()
    self.animation[self.status]:draw(IMAGE, 16*self.c-16, 16*self.r-16)
end

return Sheep