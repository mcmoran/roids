-- game start
gamestart = false

  function love.load()
  -- requirement
  require "text" -- for readout info

  -- splash screen background
  splashBG = love.graphics.newImage("splash-bg.png")

  -- map
  arenaWidth = 800
  arenaHeight = 600

  -- radius measurements
  aimRadius = 5
  shipRadius = 30
  bulletRadius = 5

  -- stages of the asteroids
  asteroidStages = {{speed = 120, radius = 15},
                    {speed = 70, radius = 25},
                    {speed = 50, radius = 35},
                    {speed = 20, radius = 50}
                  }

  -- reset all of the changing variables
  function reset()
    -- ship varriables
    shipX = arenaWidth / 2
    shipY = arenaHeight / 2
    shipAngle = 0
    shipSpeedX = 0
    shipSpeedY = 0

    -- bullets
    bullets = {}
    bulletTimer = 0

    -- Mites
    mites = {x = 50, y = 50}

    -- asteroids
    asteroids = { {x = 100, y = 100},
                  {x = arenaWidth - 100, y = 100},
                  {x = arenaWidth / 2, y = arenaHeight - 100}
                }

    math.randomseed(os.time())

    -- random location for asteroids
    for asteroidIndex, asteroid in ipairs(asteroids) do
      asteroid.angle = math.random() * (2 * math.pi)
      asteroid.stage = #asteroidStages
    end

  end -- end reset function

  reset()

end

-----------------------------------------------------------------------------
function love.update(dt)

  local turnSpeed = 5

  bulletTimer = bulletTimer + dt

  -- shooting bullets
  if love.keyboard.isDown('space') then
    if bulletTimer >= 0.5 then
      bulletTimer = 0
      table.insert(bullets, {x = shipX + math.cos(shipAngle) * shipRadius, y = shipY + math.sin(shipAngle) * shipRadius, angle = shipAngle, timeLeft = 4})
    end
  end

  -- moving the turret
  if love.keyboard.isDown('right') then
    shipAngle = (shipAngle + turnSpeed * dt) % (2 * math.pi)
  end

  if love.keyboard.isDown('left') then
    shipAngle = (shipAngle - turnSpeed * dt) % (2 * math.pi)
  end

-- moving the ship
  if love.keyboard.isDown('up') then
    local shipSpeed = 100
    shipSpeedX = shipSpeedX + math.cos(shipAngle) * shipSpeed * dt
    shipSpeedY = shipSpeedY + math.sin(shipAngle) * shipSpeed * dt
  end

  -- keeps the ship looping around the box
  shipX = (shipX + shipSpeedX * dt) % arenaWidth
  shipY = (shipY + shipSpeedY * dt) % arenaHeight

  -- adjusts the bullet over time (delete old ones and move current ones)
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

    -- check bullet collision with asteroids
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


  -- setting position of asteroid
  for asteroidIndex, asteroid in ipairs(asteroids) do
    local asteroidSpeed = 20
      asteroid.x = (asteroid.x + math.cos(asteroid.angle) * asteroidStages[asteroid.stage].speed * dt) % arenaWidth
      asteroid.y = (asteroid.y + math.sin(asteroid.angle) * asteroidStages[asteroid.stage].speed * dt) % arenaHeight

    -- check collision function
    if areCirclesIntersecting(shipX, shipY, shipRadius, asteroid.x, asteroid.y, asteroidStages[asteroid.stage].radius) then
      reset()
      break
    end
  end

end

-----------------------------------------------------------------------------
function love.draw()

  if not gamestart then
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(splashBG)
    love.graphics.setFont(titleScreenFont)
    love.graphics.setColor(0.2, 0.2, 0.2)
    love.graphics.print("トトロ vs. まっ黒黒すき。", 30, 50)
    love.graphics.setFont(defaultFont)
    love.graphics.print("Totoro vs. the Dust Mites", 40, 100)

    love.graphics.setFont(titleScreenCommand)
    love.graphics.print("スタートを押して開始します。", 30, 150)
    love.graphics.setFont(defaultFont)
    love.graphics.print("Press start to begin.", 40, 180)

  elseif gamestart then

    for y = -1, 1 do
      for x = -1, 1 do
        love.graphics.origin()
        love.graphics.translate(x * arenaWidth, y * arenaHeight)

        -- the player
        love.graphics.setColor(0, 1, 1)
        love.graphics.circle('line', shipX, shipY, shipRadius)

        -- the turret
        love.graphics.setColor(0, 1, 1)
        local shipCircleDistance = 40
        love.graphics.circle('fill', shipX + math.cos(shipAngle) * shipCircleDistance, shipY + math.sin(shipAngle) * shipCircleDistance, 5)

        -- drawing the bullets
        for bulletIndex, bullet in ipairs(bullets) do
          love.graphics.setColor(1, 0, 0)
          love.graphics.circle('fill', bullet.x, bullet.y, bulletRadius)
        end

        -- drawing the asteroids
        for asteroidIndex, asteroid in ipairs(asteroids) do
          love.graphics.setColor (1, 1, 1)
          love.graphics.circle('line', asteroid.x, asteroid.y, asteroidStages[asteroid.stage].radius)
        end

          printStats()
      end -- end first for
    end -- end second for

  end -- ending if loop

end

-- collision detection function
function areCirclesIntersecting(aX, aY, aRadius, bX, bY, bRadius)
  return (aX - bX)^2 + (aY - bY)^2 <= (aRadius + bRadius)^2
end

-- escape end
function love.keypressed(key)
  if key == "escape" then
    love.event.push("quit")
  end

  if key == "return" then
    gamestart = true
  end
end
