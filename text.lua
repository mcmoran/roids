-- setting the fonts

--mainFont = love.graphics.newFont("Quantum.otf", 30)
--bigFont = love.graphics.newFont("Quantum.otf", 60)
--smallFont = love.graphics.newFont("KeepCalm.ttf", 15)

function printStats()
    love.graphics.setColor(1, 1, 1, .5)

    love.graphics.print('ShipAngle: ' ..shipAngle, 10, 10)
    love.graphics.print('shipSpeedX: ' ..shipSpeedX, 10, 30)
    love.graphics.print('shipSpeedY: ' ..shipSpeedY, 10, 50)
    love.graphics.print('#bullets: ' ..#bullets, 10, 70)
    love.graphics.print('#asteroids: ' ..#asteroids, 10, 90)

end -- end printStats function