-- adjusted from the original final asteroids game file on 10/24/2019 by MM

-- game start
gamestart = false

-- love.load()
-- ======================================================================
function love.load()
  -- requirements
  require "text" -- for readout info
  require "image" -- for images

  bgMusic = love.audio.newSource('lofi-totoro.ogg', 'stream')
      bgMusic:setLooping(true)
      bgMusic:setVolume(0.5)
      bgMusic:play()

  -- particle system manager
  psystem = love.graphics.newParticleSystem(particle, 32)

  psystem:setParticleLifetime(0.25, 1)
  psystem:setLinearAcceleration(-200, -200, 200, 200) -- xmin, ymin, xmax, ymax
  psystem:setColors(1, 0.9, 0.8, 0.5, 0.3, 0.1, 0, 0)
  psystem:setSizes(1, 1.5, 1, 0.75, 0.5, 0.25)

  particlesX, particlesY = 0
  particlesActive = false

  -- arena
  arenaWidth = 800
  arenaHeight = 600

  -- sizes
  shipRadius = 30
  aimRadius = 5
  bulletRadius = 5
  asteroidRadius = 50

  asteroidSpeed = 100

  asteroidStages = {  {image = image4},
                      {image = image3},
                      {image = image2},
                      {image = image1} }

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
    depletionRate = 80
    repletionRate = 30

    bullets = {}
    bulletsActive = true
    bulletTimer = 0

    math.randomseed(os.time())

    asteroids = { {x = math.random(0, 200), y = math.random(0, 200)},
                  {x = math.random(600, 800), y = math.random(0, 200)},
                  {x = math.random(0, 200), y = math.random(400, 600)},
                  {x = math.random(600, 800), y = math.random(400, 600)}
                }

    offset = 6 --offset used for spacing the draw function calls. You can vary this value.

    jump = false --state variables
    dir = 1
    timer = 0

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
  psystem:update(dt)
  bulletTimer = bulletTimer + dt

  timer = timer + dt

  --this if statement is in charge of the meter level logic. If you hold down space, then we drain the meter.  If not, we recharge the meter until max.
  if bulletsActive then
    if love.keyboard.isDown('space') and meterLevel > 0 then
      meterLevel = meterLevel - depletionRate * dt
      if meterLevel == 0 then
        bulletsActive = false
      end
      if bulletTimer >= 0.5 then
        bulletTimer = 0

        table.insert(bullets, {x = shipX + math.cos(shipAngle) * shipRadius, y = shipY + math.sin(shipAngle) * shipRadius, angle = shipAngle, timeLeft = 4})
      end
    elseif meterLevel < maxLevel then
      meterLevel = meterLevel + repletionRate * dt
    end
  end

  if meterLevel > maxLevel * 0.8 then
    bulletsActive = true
  end


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

      if areCirclesIntersecting(bullet.x, bullet.y, bulletRadius, asteroid.x, asteroid.y, asteroidRadius) then
        table.remove(bullets, bulletIndex)

        if asteroid.stage > 1 then
          local angle1 = math.random() * (2 * math.pi)
          local angle2 = (angle1 - math.pi) % (2 * math.pi)

          --table.insert(asteroids, {stage = asteroid.stage - 1})

          table.insert(asteroids, {x = asteroid.x, y = asteroid.y, angle = angle2, stage = asteroid.stage - 1})
        end

        if asteroid.stage == 0 then
          particlesActive = true
          particlesX = asteroid.x
          particlesY = asteroid.y
        end

        table.remove(asteroids, asteroidIndex)
        break
      end
    end
  end

  for asteroidIndex, asteroid in ipairs(asteroids) do
    local asteroidSpeed = 20
    asteroid.x = (asteroid.x + math.cos(asteroid.angle) * asteroidSpeed * dt) % arenaWidth
    asteroid.y = (asteroid.y + math.sin(asteroid.angle) * asteroidSpeed * dt) % arenaHeight

    if areCirclesIntersecting(shipX, shipY, shipRadius, asteroid.x, asteroid.y, asteroidRadius) then
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

        -- ship
        love.graphics.setColor(0.2, 0.2, 0.2)
        love.graphics.circle('fill', shipX, shipY, shipRadius)

        -- nozzle
        love.graphics.setColor(0, 1, 1, 0.8)
        love.graphics.circle('fill', shipX + math.cos(shipAngle) * 20, shipY + math.sin(shipAngle) * 20, aimRadius)

        -- bullets
        for bulletIndex, bullet in ipairs(bullets) do
          love.graphics.setColor(0, 1, 1, 0.8)
          love.graphics.circle('fill', bullet.x, bullet.y, bulletRadius)
        end

        --meter drawing section.  Keep in mind the variables for the maxLevel and meterLevel.
        love.graphics.setColor(1, 1, 1, 0.2)
        love.graphics.rectangle('fill', arenaWidth / 20, arenaHeight / 20, maxLevel, meterHeight)
        love.graphics.setColor(0, 1, 1, 0.8)
        love.graphics.rectangle('fill', arenaWidth / 20, arenaHeight / 20, meterLevel, meterHeight)
        love.graphics.setColor(1, 1, 1, 0.5)
        love.graphics.setLineWidth(2)
        love.graphics.rectangle('line', arenaWidth / 20, arenaHeight / 20, maxLevel, meterHeight)
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(englishScreenFont)
        love.graphics.print('water level', arenaWidth / 20, (arenaHeight / 20) + 38)

        -- draw enemies
        for asteroidIndex, asteroid in ipairs(asteroids) do
          love.graphics.setColor(1, 1, 1)
          love.graphics.draw(asteroidStages[asteroid.stage].image, asteroid.x, asteroid.y, asteroidRadius)
        end

        if particlesActive then
          love.graphics.draw(psystem, particlesX, particlesY)
          psystem:emit(120)
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
