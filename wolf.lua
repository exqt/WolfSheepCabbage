local Class = require 'lib/middleclass'
local anim8 = require 'lib/anim8'
local Object = require 'object'
local Wolf = Class('Wolf', Object)

Wolf.static.IMAGE = love.graphics.newImage('asset/wolf.png')

function Wolf:initialize(level, r, c)
    Object.initialize(self, level, r, c)

    self.status = "IDLE"
    self.grid = anim8.newGrid(16, 16, Wolf.static.IMAGE:getDimensions())
    self.animation = {
        IDLE = anim8.newAnimation(self.grid('1-1', 1), 1),
        EXCITED = anim8.newAnimation(self.grid('1-2', 1), 0.3)
    }
end

function Wolf:update(dt)
    local objs = self:getAdjacentObjects(12)
    local cDir = nil
    self.status = "IDLE"

    for i, o in pairs(objs) do
        if o == nil then
            -- pass
        elseif o.class.name == "Sheep" and i <= 4 then
            cDir = i
        elseif o.class.name == "Sheep" then
            self.status = "EXCITED"
        end
    end

    if cDir then
        self:removeObjectAndMove(cDir)
    end

    self.animation[self.status]:update(dt)
end

function Wolf:draw()
    self.animation[self.status]:draw(Wolf.static.IMAGE, 16*self.c-16, 16*self.r-16)
end

return Wolf