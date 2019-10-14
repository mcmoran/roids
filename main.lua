-- game start
gamestart = false

function love.load()
  -- requirement
  require "text" -- for readout info
  require "image" -- for images

  -- map
  arenaWidth = 800
  arenaHeight = 600

  -- measurements
  totoroRadius = 30
  waterRadius = 5
  mitesRadius = 5

  -- radius measurements
  --aimRadius = 5
  --shipRadius = 30
  --bulletRadius = 5

  -- stages of the asteroids
  --[[asteroidStages = {{speed = 120, radius = 15},
                    {speed = 70, radius = 25},
                    {speed = 50, radius = 35},
                    {speed = 20, radius = 50}
                  } ]]--

  -- reset all of the changing variables
  function reset()
    -- totoro's location
    totoroX = arenaWidth / 2
    totoroY = arenaHeight / 2
    -- totoro's directions
    totoroAngle = 0
    totoroSpeedX = 0
    totoroSpeedY = 0

    -- waterspray
    water = {}
    waterTimer = 0

    -- Mites Data
    mites = {x = 50, y = 50}

    -- asteroids
    --[[ asteroids = { {x = 100, y = 100},
                  {x = arenaWidth - 100, y = 100},
                  {x = arenaWidth / 2, y = arenaHeight - 100}
                } ]]--

    math.randomseed(os.time())

    -- random location for mites
    for mitesIndex, mites in ipairs(mites) do
      mites.x = math.random()
      mitex.y = math.random()
    end


    -- random location for asteroids
    --for asteroidIndex, asteroid in ipairs(asteroids) do
    --  asteroid.angle = math.random() * (2 * math.pi)
    --  asteroid.stage = #asteroidStages
    --end

  end -- end reset function

  reset()

end

-----------------------------------------------------------------------------
function love.update(dt)

  local turnSpeed = 5

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

  -- moving totoro
  if love.keypressed('up') then
    local totoroSpeed = 100
    totoroSpeedX = totoroSpeedX + math.cos(totoroAngle) * totoroSpeed * dt
    totoroSpeedY = totoroSpeedY + math.sin(totoroAngle) * totoroSpeed * dt
  end

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



  -- setting position of asteroid
  --[[for asteroidIndex, asteroid in ipairs(asteroids) do
    local asteroidSpeed = 20
      asteroid.x = (asteroid.x + math.cos(asteroid.angle) * asteroidStages[asteroid.stage].speed * dt) % arenaWidth
      asteroid.y = (asteroid.y + math.sin(asteroid.angle) * asteroidStages[asteroid.stage].speed * dt) % arenaHeight

    -- check collision function
    if areCirclesIntersecting(shipX, shipY, shipRadius, asteroid.x, asteroid.y, asteroidStages[asteroid.stage].radius) then
      reset()
      break
    end
  end ]]--

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
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.circle('fill', totoroX, totoroY, totoroRadius)

        -- the nozzle
        love.graphics.setColor(0, 1, 1)
        local totoroCircleDistance = 40
        love.graphics.circle('fill', totoroX + math.cos(totoroAngle) * totoroCircleDistance, totoroY + math.sin(totoroAngle) * totoroCircleDistance, 5)

        -- drawing the bullets
        for waterIndex, water in ipairs(water) do
          love.graphics.setColor(1, 0, 0)
          love.graphics.circle('fill', water.x, water.y, waterRadius)
        end

        -- drawing the asteroids
        --[[for asteroidIndex, asteroid in ipairs(asteroids) do
          love.graphics.setColor (1, 1, 1)
          love.graphics.draw(mites)
          --love.graphics.circle('line', asteroid.x, asteroid.y, asteroidStages[asteroid.stage].radius)
        end ]]--

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
