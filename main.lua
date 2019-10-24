-- adjusted from the original final asteroids game file on 10/24/2019 by MM

-- game start
gamestart = false

-- love.load()
-- ======================================================================
function love.load()
  -- requirements
  require "text" -- for readout info
  require "image" -- for images

  -- arena
  arenaWidth = 800
  arenaHeight = 600

  -- sizes
  shipRadius = 30
  aimRadius = 5
  bulletRadius = 5

  asteroidStages = {  {speed = 20, radius = 30, alpha = .25},
                      {speed = 20, radius = 30, alpha = .50},
                      {speed = 20, radius = 30, alpha = .75},
                      {speed = 20, radius = 30, alpha = 1} }

  function reset()
    shipX = arenaWidth / 2
    shipY = arenaHeight / 2
    shipAngle = 0
    shipSpeedX = 0
    shipSpeedY = 0
    shipSpeed = 100

    meterHeight = 32 --UI and stat variables
    maxLevel = 256
    meterLevel = maxLevel
    depletionRate = 30
    repletionRate = 90

    bullets = {}
    bulletTimer = 0

    asteroids = { {x = 100, y = 100}, {x = arenaWidth - 100, y = 100}, {x = arenaWidth / 2, y = arenaHeight - 100} }

    offset = 6 --offset used for spacing the draw function calls. You can vary this value.

    jump = false --state variables
    dir = 1
    timer = 0

    math.randomseed(os.time())

    for asteroidIndex, asteroid in ipairs(asteroids) do
        asteroid.angle = math.random() * (2 * math.pi)
        asteroid.stage = #asteroidStages
    end
  end

  reset()
end

-- love.update()
-- ======================================================================
function love.update(dt)

  local turnSpeed = 10

  bulletTimer = bulletTimer + dt

  timer = timer + dt

  --this if statement is in charge of the meter level logic. If you hold down space, then we drain the meter.  If not, we recharge the meter until max.
  if love.keyboard.isDown('space') and meterLevel > 0 then
    meterLevel = meterLevel - depletionRate * dt
    if bulletTimer >= 0.5 then
      bulletTimer = 0

      table.insert(bullets, {x = shipX + math.cos(shipAngle) * shipRadius, y = shipY + math.sin(shipAngle) * shipRadius, angle = shipAngle, timeLeft = 4})
    end
  elseif meterLevel < maxLevel then
    meterLevel = meterLevel + repletionRate * dt
  end

  --[[
  if love.keyboard.isDown('space') then
    if bulletTimer >= 0.5 then
      bulletTimer = 0

      table.insert(bullets, {x = shipX + math.cos(shipAngle) * shipRadius, y = shipY + math.sin(shipAngle) * shipRadius, angle = shipAngle, timeLeft = 4})
    end
  end
  ]]--

  if love.keyboard.isDown('right') then
    shipAngle = (shipAngle + turnSpeed * dt) % (2 * math.pi)
  end

  if love.keyboard.isDown('left') then
    shipAngle = (shipAngle - turnSpeed * dt) % (2 * math.pi)
  end

  if love.keyboard.isDown('up') then
    shipSpeedX = shipSpeedX + math.cos(shipAngle) * shipSpeed * dt
    shipSpeedY = shipSpeedY + math.sin(shipAngle) * shipSpeed * dt
  end

  if love.keyboard.isDown('down') then
    shipSpeedX = shipSpeedX - math.cos(shipAngle) * shipSpeed * dt
    shipSpeedY = shipSpeedY - math.sin(shipAngle) * shipSpeed * dt
  end

  shipX = (shipX + shipSpeedX * dt) % arenaWidth
  shipY = (shipY + shipSpeedY * dt) % arenaHeight

  for bulletIndex = #bullets, 1, -1 do
    local bullet = bullets[bulletIndex]

    bullet.timeLeft = bullet.timeLeft - dt
    if bullet.timeLeft <= 0 then
      table.remove(bullets, bulletIndex)
    else
      local bulletSpeed = 500

      bullet.x = (bullet.x + math.cos(bullet.angle) * bulletSpeed * dt) % arenaWidth
      bullet.y = (bullet.y + math.sin(bullet.angle) * bulletSpeed * dt) % arenaHeight
    end

    for asteroidIndex = #asteroids, 1, -1 do
      local asteroid = asteroids[asteroidIndex]

      if areCirclesIntersecting(bullet.x, bullet.y, bulletRadius, asteroid.x, asteroid.y, asteroidStages[asteroid.stage].radius) then
        table.remove(bullets, bulletIndex)

        if asteroid.stage > 1 then
          local angle1 = math.random() * (2 * math.pi)
          local angle2 = (angle1 - math.pi) % (2 * math.pi)

          table.insert(asteroids, {x = asteroid.x, y = asteroid.y, angle = angle1, stage = asteroid.stage - 1})
          table.insert(asteroids, {x = asteroid.x, y = asteroid.y, angle = angle2, stage = asteroid.stage - 1})
        end

        table.remove(asteroids, asteroidIndex)
        break
      end
    end
  end

  for asteroidIndex, asteroid in ipairs(asteroids) do
    local asteroidSpeed = 10
    asteroid.x = (asteroid.x + math.cos(asteroid.angle) * asteroidStages[asteroid.stage].speed * dt) % arenaWidth
    asteroid.y = (asteroid.y + math.sin(asteroid.angle) * asteroidStages[asteroid.stage].speed * dt) % arenaHeight

    if areCirclesIntersecting(shipX, shipY, shipRadius, asteroid.x, asteroid.y, asteroidStages[asteroid.stage].radius) then
      reset()
      break
    end
  end

  if #asteroids == 0 then
    reset()
  end
end

-- love.draw()
-- ======================================================================
function love.draw()

  if not gamestart then

    splashText() --pulls in text from text.lua

  elseif gamestart then

    for y = -1, 1 do
      for x = -1, 1 do
        love.graphics.origin()
        love.graphics.translate(x * arenaWidth, y * arenaHeight)

        -- background
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(tempBG)

        love.graphics.setColor(0, 0, 1)
        love.graphics.circle('fill', shipX, shipY, shipRadius)

        love.graphics.setColor(0, 1, 1)
        love.graphics.circle('fill', shipX + math.cos(shipAngle) * 20, shipY + math.sin(shipAngle) * 20, aimRadius)

        for bulletIndex, bullet in ipairs(bullets) do
          love.graphics.setColor(0, 1, 0)
          love.graphics.circle('fill', bullet.x, bullet.y, bulletRadius)
        end

        --meter drawing section.  Keep in mind the variables for the maxLevel and meterLevel.
        love.graphics.setColor(0.3, 0.3, 0)
        love.graphics.rectangle('fill', arenaWidth / 20, arenaHeight / 20, maxLevel, meterHeight)
        love.graphics.setColor(1, 1, 0)
        love.graphics.rectangle('fill', arenaWidth / 20, arenaHeight / 20, meterLevel, meterHeight)
        love.graphics.setColor(0, 1, 1)
        love.graphics.setLineWidth(4)
        love.graphics.rectangle('line', arenaWidth / 20, arenaHeight / 20, maxLevel, meterHeight)
        love.graphics.setFont(love.graphics.newFont(20))
        love.graphics.print('ATTACK', arenaWidth / 20, (arenaHeight / 20) + 38)

        -- draw enemies
        for asteroidIndex, asteroid in ipairs(asteroids) do
          love.graphics.setColor(1, 1, 1, asteroidStages[asteroid.stage].alpha)
          love.graphics.draw(miteImage, asteroid.x, asteroid.y, asteroidStages[asteroid.stage].radius)
        end

      end
    end
  end -- end game start
end

-- various functions
-- ======================================================================

-- collision detection
function areCirclesIntersecting(aX, aY, aRadius, bX, bY, bRadius)
  return (aX - bX)^2 + (aY - bY)^2 <= (aRadius + bRadius)^2
end

-- key presses
function love.keypressed(key)

  -- escape
  if key == "escape" then
    love.event.push("quit")
  end

  -- game start
  if key == "return" then
    gamestart = true
  end
end

-- key releases
function love.keyreleased(key)

  -- stop motion
  if key == "up" or key == "down" then
    shipSpeedX, shipSpeedY = 0, 0
  end
end
