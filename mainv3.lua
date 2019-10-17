function love.load()

  gameWidth = 800
  gameHeight = 600

  totoroX = gameWidth / 2
  totoroY = gameHeight / 2

  totoroAngle = 0
  totoroSpeedX = 0
  totoroSpeedY = 0
  totoroSpeed = totoroSpeedX + totoroSpeedY
  totoroRadius = 50
  speedDepletion = 200
  speedIncreaseRate = 100
  isTotoroMovingX = false
  isTotoroMovingY = false

  spray = {} -- an array for each spray
  sprayLength = 0 -- the length of the current spray
  sprayTimer = 0 -- how long the spray is going
  sprayMax = 100 -- maximum spray capacity
  sprayNow = 0 -- current spray amount
  sprayActive = 0

end

-- =============================================================

function love.update(dt)
  local turnSpeed = 10

  sprayTimer = sprayTimer + dt
  totoroSpeed = totoroSpeedX + totoroSpeedY

  if love.keyboard.isDown('space') then
    sprayActive = 1

    for sprayIndex = #spray, 1, -1 do

      table.insert(spray, {length = 0, remaining = 100})

      --if sprayTimer >= 0.5 then
        --sprayTimer = 0

      --table.insert(spray, {x = totoroX + math.cos(totoroAngle) * totoroRadius, y = totoroY + math.sin(totoroAngle) * totoroRadius, angle = totoroAngle, timeLeft = 4})

          --spray is being depleted
      while sprayActive == 1 do
        spray[sprayIndex].remaining = spray[sprayIndex].remaining - 10

        -- if depleted then no more spraying
        if spray[sprayIndex].remaining == 0 then
          sprayActive = 0
        end -- end if
      end -- end while
    end -- end for
  end -- end if for space

  --[[
  if love.keyboard.isDown('right') then
    totoroAngle = (totoroAngle + turnSpeed * dt) % (2 * math.pi)
  end

  if love.keyboard.isDown('left') then
    totoroAngle = (totoroAngle - turnSpeed * dt) % (2 * math.pi)
  end
  ]]--

  --[[
  if love.keyboard.isDown('up') then
    local totoroSpeed = 100
    totoroSpeedX = totoroSpeedX + math.cos(totoroAngle) * totoroSpeed * dt
    totoroSpeedY = totoroSpeedY + math.sin(totoroAngle) * totoroSpeed * dt
  end 
  ]]--

  if love.keyboard.isDown('up') then
    isTotoroMoving = true
    totoroSpeedX = totoroSpeedX + math.cos(totoroAngle) * speedIncreaseRate * dt
    totoroSpeedY = totoroSpeedY + math.sin(totoroAngle) * speedIncreaseRate * dt 
  elseif totoroSpeed > 0 then
    totoroSpeedX = totoroSpeedX - speedDepletion * dt
    totoroSpeedY = totoroSpeedY - speedDepletion * dt
  end

  --[[
  if love.keyboard.isDown('down') then
    local totoroSpeed = 100
    totoroSpeedX = totoroSpeedX - math.cos(totoroAngle) * totoroSpeed * dt
    totoroSpeedY = totoroSpeedY - math.sin(totoroAngle) * totoroSpeed * dt
  end
  ]]--

  if love.keyboard.isDown('down') then
    totoroSpeedX = totoroSpeedX - math.cos(totoroAngle) * speedIncreaseRate * dt
    totoroSpeedY = totoroSpeedY - math.sin(totoroAngle) * speedIncreaseRate * dt 
  elseif totoroSpeed > 0 then
    totoroSpeedX = totoroSpeedX - speedDepletion * dt
    totoroSpeedY = totoroSpeedY - speedDepletion * dt
  end

--[[
  while totoroX < totoroRadius or totoroY < totoroRadius do
    if totoroX < totoroRadius then 
      totoroX = totoroRadius 
      totoroSpeedX = 0
    end
    if totoroY < totoroRadius then 
      totoroY = totoroRadius 
      totoroSpeedY = 0
    end
  end

  --[[if totoroX < totoroRadius then
    totoroX = totoroRadius
  elseif totoroX > gameWidth - totoroRadius then
    totoroX = gameWidth - totoroRadius
  elseif totoroY < 0 then
    totoroY = totoroRadius
  elseif totoroY > gameHeight - totoroRadius then
    totoroY = gameHeight - totoroRadius
  end ]]--

  for sprayIndex = #spray, 1, -1 do
    local spray = spray
  end

  -- if keys are released then totoro speed is zero

  function love.keyreleased(key)
    if key == 'up' or key == 'down' or key == 'right' or key == 'left' then
      while totoroSpeedX > 0 or totoroSpeedY > 0 do
        totoroSpeedX = totoroSpeedX / 2
        totoroSpeedY = totoroSpeedY / 2
      end
    end

    if key == 'space' then
      if spray[sprayIndex].remaining > 0 then
        while sprayActive == 0 do
          while spray[sprayIndex].remaining < 100 do
          spray[sprayIndex].remaining = spray[sprayIndex].remaining + 10
          end -- end while
        end -- while
      end
    end
  end -- end function

  -- keypress actions
  function love.keypressed(key)

    if key == "escape" then
      love.event.push("quit")
    end

  end

  totoroX = totoroX + totoroSpeedX * dt
  totoroY = totoroY + totoroSpeedY * dt

end -- end update function

-- =============================================================

function love.draw()

  love.graphics.setColor(0, 1, 1)
  love.graphics.circle('fill', totoroX, totoroY, 30)

  --[[ this creates a mouse pointer style line
  love.graphics.setColor(1,1,1, 0.5)
  love.graphics.setLineWidth(1)
  love.graphics.setLineStyle('rough')
  mx, my = love.mouse.getPosition()
  love.graphics.line(totoroX, totoroY, mx, my)
  ]]--

  love.graphics.setColor(1, 0.4, 0.6)
  local totoroCircleDistance = 20
  love.graphics.circle('fill', totoroX + math.cos(totoroAngle) * totoroCircleDistance, totoroY + math.sin(totoroAngle) * totoroCircleDistance, 5)
end

-- escape end
function love.keypressed(key)

  if key == "escape" then
    love.event.push("quit")
  end

end
