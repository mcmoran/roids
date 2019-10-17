function love.load()
  meterHeight = 32
  maxLevel = 256
  meterLevel = maxLevel
  depletionRate = 30
  repletionRate = 90
end

function love.update(dt)

  if love.keyboard.isDown('space') and meterLevel > 0 then
    meterLevel = meterLevel - depletionRate * dt
  elseif meterLevel < maxLevel then
    meterLevel = meterLevel + repletionRate * dt
  end

end

function love.draw()
  love.graphics.setColor(0, 1, 1)
  love.graphics.rectangle('fill', love.graphics.getWidth() / 20, love.graphics.getHeight() / 20, meterLevel, meterHeight)
  love.graphics.setColor(1, 1, 1)
  love.graphics.setLineWidth(4)
  love.graphics.rectangle('line', (love.graphics.getWidth() / 20), (love.graphics.getHeight() / 20), maxLevel, meterHeight)
  love.graphics.setFont(love.graphics.newFont(24))
  love.graphics.print('Water Level', (love.graphics.getWidth() / 20), (love.graphics.getHeight() / 20) + 48)
end
