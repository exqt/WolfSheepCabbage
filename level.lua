local Class = require 'lib/middleclass'
local Level = Class('Level')

local Player = require 'player'
local Wolf = require 'wolf'
local Sheep = require 'sheep'
local Cabbage = require 'cabbage'

local MAX_LEVEL_SIZE = 16

local TILE_IMAGE = love.graphics.newImage('asset/tile.png')
local TILE_WATER = love.graphics.newQuad(0, 0, 16, 16, TILE_IMAGE:getDimensions())
local TILE_HBRIDGE = love.graphics.newQuad(16, 0, 16, 16, TILE_IMAGE:getDimensions())
local TILE_VBRIDGE = love.graphics.newQuad(32, 0, 16, 16, TILE_IMAGE:getDimensions())
local TILE_GROUND = love.graphics.newQuad(48, 0, 16, 16, TILE_IMAGE:getDimensions())
local TILES = {TILE_WATER, TILE_HBRIDGE, TILE_VBRIDGE, TILE_GROUND}

function Level:initialize(data)
    self.height = #data
    self.width = #data[1]
    self.tiles = {}

    self.objects = {}
    self.player = nil

    self.goals = {
        Wolf = {},
        Sheep = {},
        Cabbage = {}
    }

    self.progress = "INCOMPLETE"

    self.pushCount = 0
    self.moveCount = 0

    self.events = {}

    self.waterCanvas = love.graphics.newCanvas(16*MAX_LEVEL_SIZE, 16*MAX_LEVEL_SIZE)
    self.groundCanvas = love.graphics.newCanvas(16*self.width, 16*self.height)

    for r=1, self.height do
        self.tiles[r] = {}
        for c=1, self.width do
            local s = data[r]:sub(c, c)
            local t = nil

            if s == '.' then
                t = 1
            elseif s == '=' then
                t = 2
            elseif s == '|' then
                t = 3
            elseif s == '-' then
                t = 4
            elseif s == 'W' then
                t = 4
                table.insert(self.objects, Wolf(self, r, c))
            elseif s == 'w' then
                t = 4
                table.insert(self.goals.Wolf, {r=r, c=c})
            elseif s == 'S' then
                t = 4
                table.insert(self.objects, Sheep(self, r, c))
            elseif s == 's' then
                t = 4
                table.insert(self.goals.Sheep, {r=r, c=c})
            elseif s == 'C' then
                t = 4
                table.insert(self.objects, Cabbage(self, r, c))
            elseif s == 'c' then
                t = 4
                table.insert(self.goals.Cabbage, {r=r, c=c})
            elseif s == 'P' then
                t = 4
                self.player = Player(self, r, c)
                table.insert(self.objects, self.player)
            end

            self.tiles[r][c] = t
        end
    end
end

function Level:getTileAt(r, c)
    if 1 <= r and r <= self.height and 1 <= c and c <= self.width then
        return self.tiles[r][c]
    end

    return 1
end

function Level:getObjectAt(r, c)
    for _, o in ipairs(self.objects) do
        if o.r == r and o.c == c then
            return o
        end
    end

    return nil
end

function Level:removeObjectAt(r, c)
    for i, o in ipairs(self.objects) do
        if o.r == r and o.c == c then
            return table.remove(self.objects, i)
        end
    end

    return nil
end

function Level:controlPlayer(dir)
    if self.player:push(dir) then
        self.pushCount = self.pushCount + 1
    end

    if self.player:move(dir) then
        self.moveCount = self.moveCount + 1
    end
end

function Level:updateProgess()
    if self.progress ~= "INCOMPLETE" then return end

    for type, _ in pairs(self.goals) do
        for _, pos in ipairs(self.goals[type]) do
            local o = self:getObjectAt(pos.r, pos.c)
            if o == nil then return end
            if o.class.name ~= type then return end
        end
    end

    self.progress = "COMPLETE"

    -- INCOMPLETE, FAIL_CABBAGE, FAIL_SHEEP, COMPLETE
end

function Level:keypressed(key)
    if key == 'w' then
        table.insert(self.events, "UP")
    elseif key == 's' then
        table.insert(self.events, "DOWN")
    elseif key == 'a' then
        table.insert(self.events, "LEFT")
    elseif key == 'd' then
        table.insert(self.events, "RIGHT")
    elseif key == 'r' then
        table.insert(self.events, "RESET")
    elseif key == 'z' then
        table.insert(self.events, "UNDO")
    end
end

function Level:update(dt)
    for _, e in ipairs(self.events) do
        if e == "RIGHT" then
            self:controlPlayer(1)
        elseif e == "DOWN" then
            self:controlPlayer(2)
        elseif e == "LEFT" then
            self:controlPlayer(3)
        elseif e == "UP" then
            self:controlPlayer(4)
        end
    end

    self.events = {}

    for _, o in ipairs(self.objects) do
        o:update(dt)
    end

    self:updateProgess()
end

function Level:draw()
    love.graphics.setCanvas(self.waterCanvas)
    for r=1, MAX_LEVEL_SIZE do
        for c=1, MAX_LEVEL_SIZE do
            love.graphics.draw(TILE_IMAGE, TILE_WATER, c*16-16, r*16-16)
        end
    end

    love.graphics.setCanvas(self.groundCanvas)
    for r=1, self.height do
        for c=1, self.width do
            love.graphics.draw(TILE_IMAGE, TILES[self.tiles[r][c]], c*16-16, r*16-16)
        end
    end

    for _, o in ipairs(self.objects) do
        o:draw()
    end

    love.graphics.setCanvas()

    love.graphics.draw(self.waterCanvas, 0, 0, 0, 2, 2)
    love.graphics.draw(
        self.groundCanvas,
        math.floor(MAX_LEVEL_SIZE/2-self.width/2)*32,
        math.floor(MAX_LEVEL_SIZE/2-self.height/2)*32,
        0, 2, 2
    )

    love.graphics.print("Moves: " .. tostring(self.moveCount), 0, 400)
    love.graphics.print("Progress: " .. tostring(self.progress), 0, 420)
end

return Level
