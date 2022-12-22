FailScreen = {}
FailScreen.__index = FailScreen

function FailScreen:create()
    local screen = {}
    setmetatable(screen, FailScreen)
    screen.menu = {"restart", "exitToTitle"}
    screen.currentIndex = 1
    screen.menuWidth = 400
    screen.rowSize = 65
    screen.starsField = StarsField:create(100)
    return screen
end

function FailScreen:update(dt)
    self.starsField:update(dt)

    if love.keyboard.isDown("escape") then
        gameState:setNewState(gameState.titleScreen)
    end
end

function FailScreen:draw()
    self.starsField:draw()
    local string = Str['fail'] 
    r,g,b,a = love.graphics.getColor()   
    love.graphics.setColor(get_red_blue_gradient_color(0.05)) 
    love.graphics.setFont(hugeFont)
    love.graphics.printf(string, 0, heightField / 3, widthField, "center", 0, 1, 1)

    for i = 1, #self.menu do
        local menuItemString = Str[self.menu[i]] 

        if self.currentIndex == i then
            menuItemString = "> "..menuItemString
        end

        love.graphics.setFont(gameFont)
        love.graphics.printf(menuItemString, (widthField - self.menuWidth) / 2, heightField * 2 / 3 + (i - 1) * self.rowSize, self.menuWidth, "center")
    end

    local currentMenu = self.menu[self.currentIndex]
    if currentMenu == "restart"  then
        love.graphics.setColor(r,g,b,a)
    elseif currentMenu == "exitToTitle" then    
        love.graphics.setColor(r,g,b,a)
    end
end

function FailScreen:keyPressed(key)
    if key == "down" and self.currentIndex < #self.menu then
        SoundManager.playSound(sounds['menu_change']) 
        self.currentIndex = self.currentIndex + 1
    elseif key == "up" and self.currentIndex > 1 then
        SoundManager.playSound(sounds['menu_change']) 
        self.currentIndex = self.currentIndex - 1
    end

    if key ~= "return" then
        return
    end

    local currentMenu = self.menu[self.currentIndex]
--    print(key)
--    print(self.currentIndex)

    if currentMenu == "restart" then
        SoundManager.playSound(sounds['menu_confirmed'])
        gameState:setNewState(gameState.gameScreen)
    elseif currentMenu == "exitToTitle" then    
        SoundManager.playSound(sounds['menu_confirmed'])
        gameState:setNewState(gameState.titleScreen)
    end
end

function FailScreen:reset()
    self.starsField = StarsField:create(150)
end