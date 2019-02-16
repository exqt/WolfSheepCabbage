local Class = require 'lib/middleclass'
local Level = Class('Level')

local Player = require 'player'
local Wolf = require 'wolf'
local Sheep = require 'sheep'
local Cabbage = require 'cabbage'

local MAX_SIZE = 16

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
        wolves = {},
        sheep = {},
        cabbages = {}
    }

    self.progress = "INCOMPLETE"

    self.pushCount = 0
    self.moveCount = 0

    self.canvas = love.graphics.newCanvas(16*self.width, 16*self.width)
    self.canvas:setFilter("nearest")

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
            elseif s == 'S' then
                t = 4
                table.insert(self.objects, Sheep(self, r, c))
            elseif s == 's' then
                t = 4
            elseif s == 'C' then
                t = 4
                table.insert(self.objects, Cabbage(self, r, c))
            elseif s == 'c' then
                t = 4
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

function Level:controlPlayer(dir)
    if self.player:push(dir) then
        self.pushCount = self.pushCount + 1
    end

    if self.player:move(dir) then
        self.moveCount = self.moveCount + 1
    end
end

function Level:updateProgess()
    -- INCOMPLETE, FAIL_CABBAGE, FAIL_SHEEP, COMPLETE
end

function Level:update(dt)

end

function Level:draw()
    love.graphics.setCanvas(self.canvas)

    for r=1, self.height do
        for c=1, self.width do
            love.graphics.draw(TILE_IMAGE, TILES[self.tiles[r][c]], c*16-16, r*16-16)
        end
    end

    for _, o in ipairs(self.objects) do
        o:draw()
    end

    love.graphics.setCanvas()

    love.graphics.draw(self.canvas, 0, 0, 0, 2, 2)
    love.graphics.print("Moves: " .. tostring(self.moveCount), 0, 400)
end

return Level
