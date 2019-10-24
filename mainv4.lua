-- game start
gamestart = true

function love.load()
  -- requirements
  require "text" -- for readout info
  require "image" -- for images

  -- map
  arenaWidth = 800
  arenaHeight = 600

  -- measurements
  totoroRadius = 30
  waterRadius = 5
  mitesRadius = 5

  -- stages of the mites
  mitesStages = { {speed = 20, clean = 25},
                  {speed = 40, clean = 50},
                  {speed = 60, clean = 75},
                  {speed = 10, clean = 100}
                  }

  -- reset all of the changing variables
  function reset()

    -- totoro's location
    totoroX = arenaWidth / 2
    totoroY = arenaHeight / 2

    -- totoro's directions
    totoroAngle = 0
    totoroSpeedX = 0
    totoroSpeedY = 0
    totoroSpeed = 200

    -- waterspray
    water = {}
    waterTimer = 0

    math.randomseed(os.time())

    -- Mites locations
    mites = { {x = 50, y = 50, angle = 360 * (2 * math.pi)},
              {x = 750, y = 50, angle = 2.45},
              {x = 50, y = 550, angle = 5.60},
              {x = 750, y = 550, angle = 3.60},
            }
    --[[
    mites = { {x = math.random(0, arenaWidth * 0.25), y = math.random(0, arenaHeight * 0.25)},
              {x = math.random(arenaWidth * 0.75, arenaWidth), y = math.random(arenaHeight * 0.75, arenaHeight)},
              {x = math.random(0, arenaWidth * 0.25), y = math.random(arenaHeight * 0.75, arenaHeight)},
              {x = math.random(arenaWidth * 0.75, arenaWidth), y = math.random(0, arenaHeight * 0.25)},
            } ]]--

    for mitesIndex, mites in ipairs(mites) do
        --mites.angle = math.random() * (2 * math.pi)
        mites.stage = #mitesStages
    end

  end -- end reset function

  reset()

end

-----------------------------------------------------------------------------
function love.update(dt)

  local turnSpeed = 10

  waterTimer = waterTimer + dt

  -- spraying water
  if love.keypressed('space') then
    if waterTimer >= 0.5 then
      waterTimer = 0
      table.insert(water, {x = totoroX + math.cos(totoroAngle) * totoroRadius, y = totoroY + math.sin(totoroAngle) * totoroRadius, angle = totoroAngle, timeLeft = 4})
    end
  end

  -- moving the turret
  if love.keyboard.isDown('right') then
    totoroAngle = (totoroAngle + turnSpeed * dt) % (2 * math.pi)
  end

  if love.keyboard.isDown('left') then
    totoroAngle = (totoroAngle - turnSpeed * dt) % (2 * math.pi)
  end

  if love.keyboard.isDown('up') then
    totoroSpeedX = totoroSpeedX + math.cos(totoroAngle) * totoroSpeed * dt
    totoroSpeedY = totoroSpeedY + math.sin(totoroAngle) * totoroSpeed * dt
  end

  if love.keyboard.isDown('down') then
    totoroSpeedX = totoroSpeedX - math.cos(totoroAngle) * totoroSpeed * dt
    totoroSpeedY = totoroSpeedY - math.sin(totoroAngle) * totoroSpeed * dt
  end

  totoroX = (totoroX + totoroSpeedX * dt) % arenaWidth
  totoroY = (totoroY + totoroSpeedY * dt) % arenaHeight

  --[[ moving totoro
  if love.keyboard.isDown('up') then
    local totoroSpeed = 100
    totoroSpeedX = totoroSpeedX + math.cos(totoroAngle) * totoroSpeed * dt
    totoroSpeedY = totoroSpeedY - math.sin(totoroAngle) * totoroSpeed * dt
  elseif totoroSpeedX > 0 or totoroSpeedY > 0 then
    totoroSpeedX = totoroSpeedX - 50 * dt
    totoroSpeedY = totoroSpeedY - 50 * dt
  end ]]--




  -- keep totoro inside
  if totoroX > arenaWidth then
    totoroX = arenaWidth
  elseif totoroX < 1 then
    totoroX = 1
  elseif totoroY > arenaHeight then
    totoroY = arenaHeight
  elseif totoroY < 1 then
    totoroY = 1
  end

    -- check bullet collision with asteroids
    --[[ for asteroidIndex = #asteroids, 1, -1 do
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
    end ]]--

    -- setting position of mites

  for mitesIndex, mites in ipairs(mites) do
    local mitesSpeed = 10

    -- makes asteroids go towards the player
    -- asteroid.angle = math.atan2(shipY - asteroid.y, shipX - asteroid.x)

    mites.x = (mites.x + math.cos(mites.angle) * mitesStages[mites.stage].speed * dt) % arenaWidth
    mites.y = (mites.y + math.sin(mites.angle) * mitesStages[mites.stage].speed * dt) % arenaHeight
  end -- end for loop

    -- check collision function
    --[[
    if areCirclesIntersecting(shipX, shipY, shipRadius, asteroid.x, asteroid.y, asteroidStages[asteroid.stage].radius) then
      reset()
      break
    end
    ]]--\

end -- end love.update

-----------------------------------------------------------------------------
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

        -- the player
        love.graphics.setColor(0.8, 0.8, 0.8, 0.9)
        love.graphics.circle('fill', totoroX, totoroY, totoroRadius)

        -- the nozzle
        love.graphics.setColor(0.8, 0.8, 0.8, 0.9)
        local totoroCircleDistance = 30
        love.graphics.circle('fill', totoroX + math.cos(totoroAngle) * totoroCircleDistance, totoroY + math.sin(totoroAngle) * totoroCircleDistance, 5)

        -- drawing the bullets
        for waterIndex, water in ipairs(water) do
          love.graphics.setColor(1, 0, 0)
          love.graphics.circle('fill', water.x, water.y, waterRadius)
        end

        -- draw the mites
        for mitesIndex, mites in ipairs(mites) do
          love.graphics.setColor(1, 1, 1)
          love.graphics.draw(miteImage, mites.x, mites.y, mitesStages[mites.stage].radius)
        end

          --printStats()

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

function love.keyreleased(key)
  if key == "up" or key == "down" then
    totoroSpeedX, totoroSpeedY = 0, 0
  end
end
