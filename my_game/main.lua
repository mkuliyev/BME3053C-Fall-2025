-- Pong (simple) implementation for LÖVE (Love2D)
-- Controls:
--   W / S      -> left paddle
--   Up / Down  -> right paddle
--   R          -> reset score and ball
--   Esc        -> quit

local WINDOW_WIDTH, WINDOW_HEIGHT = 800, 600
local PADDLE_W, PADDLE_H = 10, 100
local PADDLE_SPEED = 400
local BALL_SIZE = 10

local paddles = {}
local ball = {}
local scores = { left = 0, right = 0 }
local smallFont, largeFont

local function clamp(v, a, b)
  return math.max(a, math.min(b, v))
end

local function resetBall(direction)
  ball.x = WINDOW_WIDTH / 2 - BALL_SIZE / 2
  ball.y = WINDOW_HEIGHT / 2 - BALL_SIZE / 2
  local speed = 300
  local dir = direction or (math.random(2) == 1 and -1 or 1)
  local ang = math.rad(math.random(-30, 30))
  ball.vx = speed * dir * math.cos(ang)
  ball.vy = speed * math.sin(ang)
end

local function checkCollision(ax, ay, aw, ah, bx, by, bw, bh)
  return ax < bx + bw and bx < ax + aw and ay < by + bh and by < ay + ah
end

function love.load()
  math.randomseed(os.time())
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.window.setTitle("Pong - BME3053C")

  smallFont = love.graphics.newFont(14)
  largeFont = love.graphics.newFont(36)
  love.graphics.setFont(smallFont)

  paddles.left = { x = 30, y = WINDOW_HEIGHT / 2 - PADDLE_H / 2 }
  paddles.right = { x = WINDOW_WIDTH - 30 - PADDLE_W, y = WINDOW_HEIGHT / 2 - PADDLE_H / 2 }

  ball.x = WINDOW_WIDTH / 2 - BALL_SIZE / 2
  ball.y = WINDOW_HEIGHT / 2 - BALL_SIZE / 2
  ball.vx = 0
  ball.vy = 0

  resetBall()
end

function love.update(dt)
  -- Player input
  if love.keyboard.isDown('w') then paddles.left.y = paddles.left.y - PADDLE_SPEED * dt end
  if love.keyboard.isDown('s') then paddles.left.y = paddles.left.y + PADDLE_SPEED * dt end
  if love.keyboard.isDown('up') then paddles.right.y = paddles.right.y - PADDLE_SPEED * dt end
  if love.keyboard.isDown('down') then paddles.right.y = paddles.right.y + PADDLE_SPEED * dt end

  -- Clamp paddle positions
  paddles.left.y = clamp(paddles.left.y, 0, WINDOW_HEIGHT - PADDLE_H)
  paddles.right.y = clamp(paddles.right.y, 0, WINDOW_HEIGHT - PADDLE_H)

  -- Move ball
  ball.x = ball.x + ball.vx * dt
  ball.y = ball.y + ball.vy * dt

  -- Top/bottom collision
  if ball.y <= 0 then
    ball.y = 0
    ball.vy = -ball.vy
  elseif ball.y + BALL_SIZE >= WINDOW_HEIGHT then
    ball.y = WINDOW_HEIGHT - BALL_SIZE
    ball.vy = -ball.vy
  end

  -- Paddle collisions
  if checkCollision(ball.x, ball.y, BALL_SIZE, BALL_SIZE, paddles.left.x, paddles.left.y, PADDLE_W, PADDLE_H) then
    ball.x = paddles.left.x + PADDLE_W
    ball.vx = -ball.vx * 1.03
    local relative = (ball.y + BALL_SIZE / 2) - (paddles.left.y + PADDLE_H / 2)
    ball.vy = ball.vy + relative * 5
  end
  if checkCollision(ball.x, ball.y, BALL_SIZE, BALL_SIZE, paddles.right.x, paddles.right.y, PADDLE_W, PADDLE_H) then
    ball.x = paddles.right.x - BALL_SIZE
    ball.vx = -ball.vx * 1.03
    local relative = (ball.y + BALL_SIZE / 2) - (paddles.right.y + PADDLE_H / 2)
    ball.vy = ball.vy + relative * 5
  end

  -- Scoring
  if ball.x + BALL_SIZE < 0 then
    scores.right = scores.right + 1
    resetBall(1)
  elseif ball.x > WINDOW_WIDTH then
    scores.left = scores.left + 1
    resetBall(-1)
  end
end

function love.draw()
  love.graphics.clear(20/255, 20/255, 20/255)
  love.graphics.setColor(1, 1, 1)

  -- center dashed line
  for y = 0, WINDOW_HEIGHT, 20 do
    love.graphics.rectangle('fill', WINDOW_WIDTH / 2 - 1, y, 2, 10)
  end

  -- paddles
  love.graphics.rectangle('fill', paddles.left.x, paddles.left.y, PADDLE_W, PADDLE_H)
  love.graphics.rectangle('fill', paddles.right.x, paddles.right.y, PADDLE_W, PADDLE_H)

  -- ball
  love.graphics.rectangle('fill', ball.x, ball.y, BALL_SIZE, BALL_SIZE)

  -- scores
  love.graphics.setFont(largeFont)
  love.graphics.printf(tostring(scores.left), WINDOW_WIDTH * 0.25 - 20, 20, 40, 'center')
  love.graphics.printf(tostring(scores.right), WINDOW_WIDTH * 0.75 - 20, 20, 40, 'center')

  -- instructions
  love.graphics.setFont(smallFont)
  love.graphics.printf('W/S: Left  |  Up/Down: Right  |  R: Reset  |  Esc: Quit', 0, WINDOW_HEIGHT - 28, WINDOW_WIDTH, 'center')
end

function love.keypressed(key)
  if key == 'r' then
    scores.left = 0
    scores.right = 0
    resetBall()
  elseif key == 'escape' then
    love.event.quit()
  end
end


function love.load()
  love.window.setTitle("Hello from Codespaces + LÖVE")
  width, height = 800, 600
  love.window.setMode(width, height)
  msg = "It works! 🚀  Use arrow keys to move the box."
  player = { x = 100, y = 100, s = 40, v = 200 }
end

function love.update(dt)
  if love.keyboard.isDown("d") then player.x = player.x + player.v * dt end
  if love.keyboard.isDown("a")  then player.x = player.x - player.v * dt end
  if love.keyboard.isDown("s")  then player.y = player.y + player.v * dt end
  if love.keyboard.isDown("w")    then player.y = player.y - player.v * dt end
end

function love.draw()
  love.graphics.print(msg, 20, 20)
  love.graphics.rectangle("fill", player.x, player.y, player.s, player.s)
end