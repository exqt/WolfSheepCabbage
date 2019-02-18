local Class = require 'lib/middleclass'
local Manager = Class('Manager')
local Level = require 'level'

local currentLevelIndex = 1
local currentLevel = nil
local filenames = nil

function Manager:initialize()
    filenames = love.filesystem.getDirectoryItems('level')
    table.sort(filenames)

    self:loadLevel(currentLevelIndex)
end

function Manager:loadLevel()
    local l = require("./level/"..filenames[currentLevelIndex]:sub(0, -5))
    currentLevel = Level(l.data)
end

function Manager:nextLevel()
    currentLevelIndex = (currentLevelIndex + 1) % #filenames + 1
    self:loadLevel()
end

function Manager:prevLevel()
    currentLevelIndex = (currentLevelIndex + #filenames - 1) % #filenames + 1
    self:loadLevel()
end

function Manager:keypressed(key)
    if key == '[' then
        self:prevLevel()
    elseif key == ']' then
        self:nextLevel()
    end

    currentLevel:keypressed(key)
end

function Manager:update(dt)
    currentLevel:update(dt)
end

function Manager:draw()
    currentLevel:draw()
end

return Manager()