local Class = require 'lib/middleclass'
local Object = Class('Object')

local dr = {0, 1, 0, -1}
local dc = {1, 0, -1, 0}

function Object:initialize(level, r, c)
    self.level = level
    self.r = r
    self.c = c
end

function Object:move(dir)
    local nr, nc = self.r + dr[dir], self.c + dc[dir]

    if
        self.level:getTileAt(nr, nc) == 1 or
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

return Object