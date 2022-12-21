TitleScreen = {}
TitleScreen.__index = TitleScreen

local newGame = "New Game"
local exit = "Exit"

function TitleScreen:create()
    local screen = {}
    setmetatable(screen, TitleScreen)
    screen.menu = Menu:create(MenuItem:create("newGame", "newGame", TitleScreen:goToMainGame()), 
                        MenuItem:create("Exit", "Exit", TitleScreen:exitGame()), 
                         1, 200, 300)
    screen.index = 1
    screen.menuWidth = 200
    screen.rowSize = 30
    screen.isKeyDownDown = false
    screen.isKeyUpDown = false
    screen.isKeyEnterDown = false
    screen.starsField = StarsField:create()
    return screen
end

function TitleScreen:update(dt)
    self.starsField:update(dt)

    local isKeyDownDown = love.keyboard.isDown("down")
    local isKeyUpDown = love.keyboard.isDown("up")
    if not(self.isKeyDownDown) and isKeyDownDown and self.index <= #self.menu then 
        self.isKeyDownDown = true
        self.index = self.index + 1
    elseif not(self.isKeyUpDown) and isKeyUpDown and self.index > 1 then    
        self.isKeyUpDown = true
        self.index = self.index - 1
    else
        self.isKeyDownDown = false
        self.isKeyUpDown = false    
    end

    local isKeyReturnDown = love.keyboard.isDown("return") 
    if not(self.isKeyReturnDown) and isKeyReturnDown then
--    self.isKeyEnterDown = true
        --print(self.menu[self.index])
        if self.menu[self.index] == newGame then
            gameState:setNewState(gameState.gameScreen) 
        else
            love.event.quit()    
        end
--    else
--        self.isKeyEnterDown = false    
    end

    self.isKeyDownDown = isKeyDownDown
    self.isKeyUpDown = isKeyUpDown
    self.isKeyReturnDown = isKeyReturnDown
end

function TitleScreen:draw()
    self.starsField:draw()

    for i = 1, #self.menu do
        local text = self.menu[i]

        if self.index == i then
            text = "> "..text
        end

        love.graphics.printf(text, (widthField - self.menuWidth) / 2, heightField * 2 / 3 + (i - 1) * self.rowSize, self.menuWidth, "center")
    end
end    

function TitleScreen:reset()
    self.index = 1
end

function TitleScreen:keyPressed(key)
    if key == 'down' then
        self.menu:next()
    elseif key == 'up' and self.index > 1 then    
        self.menu:previous()
    end

    if key == 'return' then
        self.menu:confirm()
    end
end

function TitleScreen:goToMainGame()
    gameState:setNewState(gameState.gameScreen) 
end

function TitleScreen:exitGame()
    love.event.quit() 
end