TitleScreen = {}
TitleScreen.__index = TitleScreen

local newGame = "New Game"
local exit = "Exit"


function TitleScreen:create()
    local screen = {}
    setmetatable(screen, TitleScreen)
    screen.menu = {newGame, exit}
    screen.index = 1
    screen.menuWidth = 280
    screen.rowSize = 65
    screen.isKeyDownDown = false
    screen.isKeyUpDown = false
    screen.isKeyEnterDown = false
    screen.starsField = StarsField:create(300)
    return screen
end

function TitleScreen:update(dt)
    SoundManager.stopSound(sounds['music_game'])
    SoundManager.playLoop(sounds['music_start'])
    self.starsField:update(dt)
    

    local isKeyDownDown = love.keyboard.isDown("down")
    local isKeyUpDown = love.keyboard.isDown("up")
    if not(self.isKeyDownDown) and isKeyDownDown and self.index <= #self.menu then
        SoundManager.playSound(sounds['menu_change']) 
        self.isKeyDownDown = true
        self.index = self.index + 1
    elseif not(self.isKeyUpDown) and isKeyUpDown and self.index > 1 then    
        SoundManager.playSound(sounds['menu_change'])
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
            SoundManager.playSound(sounds['menu_confirmed'])
            gameState:setNewState(gameState.gameScreen) 
        else
            SoundManager.playSound(sounds['menu_confirmed'])
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
        
        love.graphics.setFont(hugeFont)
        love.graphics.printf('moonlander v0.1', 0, 100, widthField, "center")
        love.graphics.setFont(gameFont)
        love.graphics.printf(text, (widthField - self.menuWidth) / 2, heightField * 2 / 3 + (i - 1) * self.rowSize, self.menuWidth, "center")
    end
end    

function TitleScreen:reset()
    self.index = 1
end

function TitleScreen:keyPressed(key)
end