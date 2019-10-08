--setting the fonts
--statsFont = love.graphics.newFont("courier.tff", 15)

titleScreenFont = love.graphics.newFont("chihaya.ttf", 50)
titleScreenCommand = love.graphics.newFont("chihaya.ttf", 30)

defaultFont = love.graphics.newFont(14)

-- printing out various stats for the game
function printStats()
    love.graphics.setColor(1, 1, 1, .5)
    --love.graphics.setFont(statsFont)
    love.graphics.print('ShipAngle: ' ..shipAngle, 10, 10)
    love.graphics.print('shipSpeedX: ' ..shipSpeedX, 10, 30)
    love.graphics.print('shipSpeedY: ' ..shipSpeedY, 10, 50)
    love.graphics.print('#bullets: ' ..#bullets, 10, 70)
    love.graphics.print('#asteroids: ' ..#asteroids, 10, 90)

end -- end printStats function
