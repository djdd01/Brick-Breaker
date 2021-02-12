Ball = Class {}

math.randomseed(os.time())

function Ball:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dx = math.random(2) == 1 and 180 or -180
    self.dy = -150
end

function Ball:collides(box)
    if self.x > box.x + box.width or self.x + self.width < box.x then
        return false
    end
    if self.y > box.y + box.height or self.y + self.height < box.y then
        return false
    end

    return true
end

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Ball:reset()
    self.dx = math.random(2) == 1 and 180 or -180
    self.dy = -150
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2
end

function Ball:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end
