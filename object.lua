local Class = require 'lib/middleclass'
local Object = Class('Object')

local dr = {0, 1, 0, -1, 1, 1, -1, -1}
local dc = {1, 0, -1, 0, -1, 1, -1, 1}

function Object:initialize(level, r, c)
    self.level = level
    self.r = r
    self.c = c
end

function Object:move(dir)
    local nr, nc = self.r + dr[dir], self.c + dc[dir]
    if
        self.level:getTileAt(nr, nc) == "WATER" or
        self.level:getObjectAt(nr, nc) ~= nil
    then
        return false
    end

    self.r, self.c = nr, nc
    return true
end

function Object:push(dir)
    local nr, nc = self.r + dr[dir], self.c + dc[dir]
    local o = self.level:getObjectAt(self.r + dr[dir], self.c + dc[dir])

    if o == nil then return false end
    if not o:move(dir) then return false end

    return true
end

function Object:setPosition(r, c)
    self.r = r
    self.c = c
end

function Object:getAdjacentObjects(nDirs)
    nDirs = nDirs or 4
    local objs = {}
    for dir=1, nDirs do
        local nr, nc = self.r + dr[dir], self.c + dc[dir]
        objs[dir] = self.level:getObjectAt(nr, nc)
    end

    return objs
end

function Object:removeObjectAndMove(dir)
    local nr, nc = self.r + dr[dir], self.c + dc[dir]
    local o = self.level:getObjectAt(self.r + dr[dir], self.c + dc[dir])

    if o == nil then return nil end
    self.level:removeObjectAt(nr, nc)

    return self:move(dir)
end

return Object