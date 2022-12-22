--Режим отображения:
local MODE_2X = false --С двукратным увеличением
local GAME_STATE = {PLAY = 0, PAUSED = 1, CRASHED = 2, LANDED = 3}
--игровая 1 секунда:
local COUNTDOWN_TIME = 0.65
local r, g, b, a = love.graphics.getColor()

GameScreen = {}
GameScreen.__index = GameScreen

function GameScreen:create()
    local location = Vector:create(widthField/2, heightField/2 - 100) 
    local screen = {}
    setmetatable(screen, GameScreen)
    screen.landscape = Landscape:create()
    screen.starsField = StarsField:create(500, 'circle', screen.landscape)
    screen.camera = Camera()
    screen.spaceshipPlayer = Spaceship:create(location)
    screen.systemParticlesCrash = nil
    screen.isPaused = false
    screen.state = 0
    screen.score = 0 --игровой счет
    screen.countSeconds = 10
    screen.timer = 0
 --   screen.particleTimer = ExtendedTimer:create() 
--    screen.circle1 = {radius = 24}
 --   screen.particleTimer:tween(6, circle1, {radius = 96}, 'in-out-cubic')
    return screen
end

function GameScreen:update(dt)
    SoundManager.stopSound(sounds['music_start'])
    SoundManager.playLoop(sounds['music_game']) 

    if love.keyboard.wasPressed('p') and (self.state == GAME_STATE['PLAY'] or self.state == GAME_STATE['PAUSED']) then   
        self.isPaused = not self.isPaused

        if self.state == GAME_STATE['PLAY'] then
            SoundManager.playSound(sounds['pause-on']) 
        else
            SoundManager.playSound(sounds['pause-off'])     
        end
    end

    if not self.isPaused then
        self.spaceshipPlayer:update(dt)
        self.camera:lookAt(self.spaceshipPlayer.location.x, self.spaceshipPlayer.location.y)
    end   

    if ((not MODE_2X) and (self.spaceshipPlayer.altitude <= 200)) then
        self.camera:zoomTo(2)
        MODE_2X = true
    elseif MODE_2X and (self.spaceshipPlayer.altitude >= 220) then    
        self.camera:zoomTo(1)
        MODE_2X = false
    end
    
    if (self.camera.x < widthField/2) and (not MODE_2X) then
        self.camera.x = widthField/2 
    end

    if self.camera.y < heightField/2 then
       self.camera.y = heightField/2
    end

    if (self.camera.x > 0) and (not MODE_2X) then
        self.camera.x = widthField/2
    end

    if (self.camera.y > 0) and (not MODE_2X) then
        self.camera.y = heightField/2
    end

    if self.state == GAME_STATE['CRASHED'] then
        if self.systemParticlesCrash == nil then
            self.systemParticlesCrash = ParticleSystem:create(self.spaceshipPlayer.location, 12)
            self.systemParticlesCrash:createParticles() --self.spaceshipPlayer.polygons
        else
            self.systemParticlesCrash:updateOne(dt)    
        end

        self.timer = self.timer + dt
        self:crushedCountDown()

--print(self.timer)

    else
        self:checkCollisions()
    end
end

function GameScreen:reset()
    SoundManager.stopSound(sounds['music_start'])
    SoundManager.playLoop(sounds['music_game']) 
    self.landscape = Landscape:create()
    self.starsField = StarsField:create(500, 'circle', self.landscape)
    self.systemParticlesCrash = nil
    local location = Vector:create(widthField/2, heightField/2 - 100) 
    self.spaceshipPlayer = Spaceship:create(location)
    self.camera = Camera()
    self.isPaused = false
    self.countSeconds = 10
    self.state = 0
end


function GameScreen:draw()
  --  love.graphics.circle('fill', 400, 300, circle1.radius)

    self.camera:attach()
    self.landscape:draw()
    self.starsField:drawCircleStars()
    

    if self.state == GAME_STATE['CRASHED'] then
        if self.systemParticlesCrash then
           self.systemParticlesCrash:draw()
        end
    else
        self.spaceshipPlayer:draw()
    end


    self.camera:detach()
    love.graphics.setFont(mediumFont)
    love.graphics.print("Angle:  ".. math.floor(math.abs(math.deg(self.spaceshipPlayer.angle))), 15, 30)
    love.graphics.print("Velocity_X:  "..  math.floor(self.spaceshipPlayer.velocity.x * 100), 15, 60)
    love.graphics.print("Velocity_Y:  "..  math.floor(self.spaceshipPlayer.velocity.y * 100), 15, 90)
    love.graphics.print("Fuel:  ".. self.spaceshipPlayer.fuel, 15, 120)
    --love.graphics.print("Altitude:".. math.ceil(self.spaceshipPlayer.altitude), 15, 150)
    

    if self.spaceshipPlayer.fuel < 400 and math.floor(love.timer.getTime()) % 2 == 0 then
        love.graphics.setFont(hugeFont)
        local hFont = 20
        love.graphics.printf('LOW ON FUEL', 0, heightField / 2 - hFont, widthField, "center")
    end

    
    if self.isPaused and (self.state == GAME_STATE['PLAY'] or self.state == GAME_STATE['PAUSED']) then
        love.graphics.setFont(hugeFont)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf('PAUSE', 0, heightField / 2 - 100, widthField, "center")
        love.graphics.setColor(0, 0, 0, 0.2)
    else
        love.graphics.setColor(r, g, b, a)
    end

    
end

function GameScreen:keyPressed(key)
end

function GameScreen:checkCollisions()
    for i = 1, #self.landscape.vectorsTable-1 do
        if self.spaceshipPlayer:intersectsWithLine(self.landscape.vectorsTable[i], self.landscape.vectorsTable[i + 1]) then
            self.isPaused = true
            self.state = GAME_STATE['CRASHED']
            --print("crashed ")
            SoundManager.playSound(sounds['collision']) 
      
            if self.landscape.vectorsTable[i].y == self.landscape.vectorsTable[i + 1].y and self:checkPointOnLine(i) then
                if (self.spaceshipPlayer.velocity.x < TOP_VELOCITY_X) and (self.spaceshipPlayer.velocity.y < TOP_VELOCITY_Y) and (self.spaceshipPlayer:isGoodAngle()) then -- угол допустим +-10 градусов
                    self.state = GAME_STATE['LANDED']
                    --print("Landed... ")
                    SoundManager.playSound(sounds['win']) 
                    gameState:setNewState(gameState.winScreen)
                end
            end
        end
    end
end


function GameScreen:checkPointOnLine(i) -- крайние шасси корабля должны быть в пределах посадочной площадке
    if (self.landscape.vectorsTable[i].x <= self.spaceshipPlayer.polygons[2][5] + self.spaceshipPlayer.location.x) and
     (self.landscape.vectorsTable[i + 1].x >= self.spaceshipPlayer.polygons[3][7] + self.spaceshipPlayer.location.x) then
        return true
    end

    return false
end

function GameScreen:crushedCountDown()
    if self.timer > COUNTDOWN_TIME then
        self.timer = self.timer % COUNTDOWN_TIME
        self.countSeconds = self.countSeconds - 1

        if self.countSeconds == -1 then
            gameState:setNewState(gameState.failScreen)
        end
    end
end