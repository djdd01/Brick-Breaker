Paddle = Class {}

function Paddle:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dx = 0
end

function Paddle:update(dt)
    if self.dx < 0 then
        self.x = math.max(0, self.x + self.dx * dt)
    elseif self.dx > 0 then
        self.x = math.min(432 - self.width, self.x + self.dx * dt)
    end
end

function Paddle:reset()
    self.x = VIRTUAL_WIDTH / 2 - 17
    self.y = 230
    self.width = 34
    self.height = 4
end

function Paddle:render()
    love.graphics.setColor(80 / 255, 80 / 255, 80 / 255, 1)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end
