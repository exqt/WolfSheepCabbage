local Class = require 'lib/middleclass'
local Object = require 'object'
local Wolf = Class('Wolf', Object)

Wolf.static.IMAGE = love.graphics.newImage('asset/wolf.png')
Wolf.static.IDLE = love.graphics.newQuad(0, 0, 16, 16, Wolf.static.IMAGE:getDimensions())

function Wolf:initialize(level, r, c)
    Object.initialize(self, level, r, c)
end

function Wolf:update(dt)
    local objs = self:getAdjacentObjects()
    local cDir = nil

    for i, o in pairs(objs) do
        if o == nil then
            -- pass
        elseif o.class.name == "Sheep" then
            cDir = i
        end
    end

    if cDir then
        self:removeObjectAndMove(cDir)
    end
end

function Wolf:draw()
    love.graphics.draw(Wolf.static.IMAGE, Wolf.static.IDLE, 16*self.c-16, 16*self.r-16)
end

return Wolf