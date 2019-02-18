function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    Lurker = require 'lib.lurker'
    manager = require 'manager'
end

function love.update(dt)
    Lurker.update(dt)
    manager:update(dt)
end

function love.keypressed(key, _, isrepeat)
    manager:keypressed(key)
end

function love.draw()
    manager:draw()
end