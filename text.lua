--setting the fonts

titleScreenFont = love.graphics.newFont("chihaya.ttf", 50)
titleScreenCommand = love.graphics.newFont("chihaya.ttf", 30)
englishScreenFont = love.graphics.newFont("chihaya.ttf", 25)
--defaultFont = love.graphics.newFont(14)

-- splash Screen Text function

function splashText()

  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(splashBG)
  love.graphics.setFont(titleScreenFont)
  love.graphics.setColor(0.2, 0.2, 0.2)
  love.graphics.print("トトロ vs. まっ黒黒すき。", 30, 50)
  love.graphics.setFont(englishScreenFont)
  love.graphics.print("Totoro vs. the Dust Mites", 40, 100)

  love.graphics.setFont(titleScreenCommand)
  love.graphics.print("スタートを押して開始します。", 30, 150)
  love.graphics.setFont(englishScreenFont)
  love.graphics.print("Press return to begin.", 40, 180)

end -- end function


function counterText()

  love.graphics.setColor(1, 1, 1)
  love.graphics.setFont(englishScreenFont)
  love.graphics.print("Dust Mites Cleaned: ", 450, 50)
  love.graphics.setFont(titleScreenCommand)
  love.graphics.print(miteCounter, 700, 50)

end -- end function
