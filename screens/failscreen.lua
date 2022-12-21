FailScreen = {}
FailScreen.__index = FailScreen

function FailScreen:create()
    local screen = {}
    setmetatable(screen, FailScreen)
    screen.menu = {"restart", "exitToTitle"}
    screen.currentIndex = 1
    screen.menuWidth = 200
    screen.rowSize = 30
    return screen
end

function FailScreen:update()
    if love.keyboard.isDown("escape") then
        gameState:setNewState(gameState.titleScreen)
    end
end

function FailScreen:draw()
    local string = Str['fail']    
    love.graphics.printf(string, 0, heightField / 3, widthField, "center", 0, 1, 1)

    for i = 1, #self.menu do
        local menuItemString = Str[self.menu[i]] 

        if self.currentIndex == i then
            menuItemString = "> "..menuItemString
        end

        love.graphics.printf(menuItemString, (widthField - self.menuWidth) / 2, heightField * 2 / 3 + (i - 1) * self.rowSize, self.menuWidth, "center")
    end
end

function FailScreen:keyPressed(key)
    if key == "down" and self.currentIndex < #self.menu then
        self.currentIndex = self.currentIndex + 1
    elseif key == "up" and self.currentIndex > 1 then
        self.currentIndex = self.currentIndex - 1
    end

    if key ~= "return" then
        return
    end

    local currentMenu = self.menu[self.currentIndex]
--    print(key)
--    print(self.currentIndex)

    if currentMenu == "restart" then
        gameState:setNewState(gameState.gameScreen)
    elseif currentMenu == "exitToTitle" then    
        gameState:setNewState(gameState.titleScreen)
    end
end

function FailScreen:reset()
end