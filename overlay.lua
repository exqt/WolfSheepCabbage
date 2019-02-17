local Class = require 'lib/middleclass'
local Overlay = Class('Overlay')

local mainFont = love.graphics.newFont('asset/monogram.ttf', 92)
local subFont = love.graphics.newFont('asset/monogram.ttf', 32)
local mainText = love.graphics.newText(mainFont)
local subText = love.graphics.newText(subFont)

function Overlay:initialize()
    self.timer = 0
end

function Overlay:setText(mainStr, subStr)
    mainText:set(mainStr)
    subText:set(subStr)
end

function Overlay:update(dt)
    self.timer = self.timer + dt
end

function Overlay:draw()
    local sw, sh = love.graphics.getDimensions()
    love.graphics.draw(mainText, sw/2-mainText:getWidth()/2, 200+math.sin(self.timer*3)*10)
    love.graphics.draw(subText, sw/2-subText:getWidth()/2, 300)
end

return Overlay()