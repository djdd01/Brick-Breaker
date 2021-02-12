bricks = {}
i = 1
for x = 15, VIRTUAL_WIDTH - 20, 45 do
    for y = 15, VIRTUAL_HEIGHT / 2 - 40, 15 do
        brick = {}
        brick.x = x
        brick.y = y
        brick.width = 40
        brick.height = 10
        bricks[i] = brick
        i = i + 1
    end
end

function brick:collides()
    for i, brick in ipairs(bricks) do
        if ball:collides(brick) then
            ball.dy = -ball.dy
            sounds['paddle_hit']:play()
            table.remove(bricks, i)
        end
    end
end

function bricks:render()
    for i, brick in ipairs(bricks) do
        love.graphics.rectangle('fill', brick.x, brick.y, brick.width,
                                brick.height)
    end
end
