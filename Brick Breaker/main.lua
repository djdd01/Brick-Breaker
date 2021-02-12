WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

push = require 'push'
Class = require 'class'
require 'Brick'
require 'Ball'
require 'Paddle'
ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)
paddle = Paddle(VIRTUAL_WIDTH / 2 - 17, 230, 34, 4)
paddleSpeed = 350

love.graphics.setDefaultFilter('nearest', 'nearest')

function love.load()
    time = 4
    lives = 10
    gamestate = 'start'
    Font = love.graphics.newFont('Fonts/font.ttf', 16)
    VictoryFont = love.graphics.newFont('Fonts/font.ttf', 32)
    SmallFont = love.graphics.newFont('Fonts/font.ttf', 8)

    sounds = {
        ['paddle_hit'] = love.audio.newSource('Sounds/paddlehit.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('Sounds/wall_hit.wav', 'static'),
        ['score'] = love.audio.newSource('Sounds/Explosion13.wav', 'static'),
        ['victory'] = love.audio.newSource('Sounds/Victory.wav', 'static')
    }

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT,
                     {fullscreen = false, vsync = true, resizable = false})
end

function love.keypressed(key)
    if key == 'escape' then love.event.quit() end
    if key == 'enter' or key == 'return' then
        if gamestate == 'start' or gamestate == 'pause' then
            gamestate = 'play'
        elseif gamestate == 'play' then
            gamestate = 'pause'
        elseif gamestate == 'lose' or gamestate == 'Win' then
            love.event.quit('restart')
        end
    end
    if key == 'r' then love.event.quit('restart') end
end

function love.update(dt)
    if gamestate == 'play' then
        time = time - dt
        paddle:update(dt)
        if time <= 0 then ball:update(dt) end
        if love.keyboard.isDown('left') then
            paddle.dx = -paddleSpeed
        elseif love.keyboard.isDown('right') then
            paddle.dx = paddleSpeed
        else

            paddle.dx = 0
        end
        if ball.x <= 0 or ball.x >= 432 then
            sounds['wall_hit']:play()
            ball.dx = -ball.dx
        end
        if ball.y <= 0 then
            sounds['wall_hit']:play()
            ball.dy = -ball.dy
        end
        if ball:collides(paddle) then
            sounds['paddle_hit']:play()
            ball.dy = -ball.dy
        end
        brick:collides()
        if ball.y >= 243 then
            sounds['score']:play()
            lives = lives - 1
            if lives > 0 then
                gamestate = 'pause'
                time = 3
                ball:reset()
                paddle:reset()
            elseif lives == 0 then
                gamestate = 'lose'
            end
        end
        if #bricks == 0 then gamestate = 'Win' end
    end
end

function love.draw()
    push:apply('start')
    love.graphics.setFont(Font)
    if gamestate == 'start' then
        love.graphics.printf("Welcome to Brick Breaker!", 0, VIRTUAL_HEIGHT / 2 - 20,
                             VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(SmallFont)
        love.graphics.printf("Press Enter to play", 0, VIRTUAL_HEIGHT / 2,
                             VIRTUAL_WIDTH, 'center')
    elseif gamestate == 'play' or gamestate == 'pause' then
        love.graphics.setFont(Font)
        if time >= 1 then
            love.graphics.print("Lives: " .. tostring(lives),
                                VIRTUAL_WIDTH - 90, VIRTUAL_HEIGHT - 24)
            love.graphics.print(math.floor(time), 24, VIRTUAL_HEIGHT - 24)
        elseif time < 1 and time >= 0 then
            love.graphics.print("GO!", 16, VIRTUAL_HEIGHT - 24)
        end
        bricks:render()
        ball:render()
        paddle:render()
    elseif gamestate == 'lose' then
        love.graphics.setFont(VictoryFont)
        love.graphics.printf("YOU LOSE :(", 0, VIRTUAL_HEIGHT / 2 - 20,
                             VIRTUAL_WIDTH, 'center')
    end
    if gamestate == 'Win' then
        sounds['victory']:play()
        love.graphics.setFont(VictoryFont)
        love.graphics.printf("YOU WIN :)", 0, VIRTUAL_HEIGHT / 2 - 20,
                             VIRTUAL_WIDTH, 'center')
    end
    push:apply('end')
end

