--if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
--    require("lldebugger").start()
--end

--Timer = require 'utils/extendedTimer'
require("utils/corner-rounder")
require("utils/timer")
require("utils/extendedTimer")
require("utils/utilsfunc")
require("vector")
require("landscape")
require("spaceship")
require("fireParticle")
require("particle")
require("particlesystem")

Timer = require 'utils/extendedTimer'
Camera = require 'utils/camera'

--Режим отображения:
MODE_2X = false --С двукратным увеличением

GAME_STATE = {PLAY = 0, PAUSED = 1, CRASHED = 2, LANDED = 3}

function love.load(arg)




    camera = Camera()

    --Параметры игры:
    isPaused = false
    state = 0
    score = 0 --игровой счет
--    mode = NORMAL -- зум
--    time_sec -- время миссии - Мин + сек
--    time_min --Рассчитывается на процессе «часы»
--    restart_flag -- После крушения или успешной посадки => перезапуск миссии
--    end_of_game_flag  --флаг конец  игры
--    glob_count


--    canvas = love.graphics.newCanvas(widthField, heightField)


starfield = require 'starfield'
-- create a new starfield with 50k stars.
sf = starfield:new(500)
-- and we initialize it (generate the stars)
sf:load()

    landscape = Landscape:create()
    

   -- timer = Timer.new()

 --   utils = Utils:create()

    local location = Vector:create(widthField/2, heightField/2 - 100) 
    spaceshipPlayer = Spaceship:create(location)
    systemCrash = nil

    

    --timer1 = require 'utils/timer'
-- --timer1 = Timer.new()
timer1 = ExtendedTimer:create() 
    print(timer1)
    circle1 = {radius = 24}
    timer1:tween(6, circle1, {radius = 96}, 'in-out-cubic')
    --Timer.tween(6, circle1, {radius = 96}, 'in-out-cubic')



    --создание таблицы для хранения нажатых клавиш(в одном кадре):
    love.keyboard.keysPressed = {}

    
end

function love.update(dt)

--    sf:update(dt, 0, 0)
    --нажата клавиша паузы
    --print(love.keyboard.wasPressed('p'))
    if love.keyboard.wasPressed('p') and (state == GAME_STATE['PLAY'] or state == GAME_STATE['PAUSED']) then   
        isPaused = not isPaused
    end

    if not isPaused then
        spaceshipPlayer:update(dt)
        camera:lookAt(spaceshipPlayer.location.x, spaceshipPlayer.location.y)
    end    


    
    timer1:update(dt)
   -- Timer.update(dt)
    

   -- print("Good Angle:".. math.deg(GOOD_ANGLE_VELOCITY))
   -- print("Angle:".. math.deg(spaceshipPlayer.angle))

    

    if ((not MODE_2X) and (spaceshipPlayer.altitude <= 150)) then
        camera:zoomTo(2)
        MODE_2X = true
    elseif MODE_2X and (spaceshipPlayer.altitude >= 200) then    
        camera:zoomTo(1)
        MODE_2X = false
    end
    

    if (camera.x < widthField/2) and (not MODE_2X) then
        camera.x = widthField/2
    end

    if camera.y < heightField/2 then
        camera.y = heightField/2
    end

    if camera.y < heightField/2 - landscape.totalHeight then
        camera.y = heightField/2 - landscape.totalHeight
    end


    if state == GAME_STATE['CRASHED'] then
        if systemCrash == nil then
            systemCrash = ParticleSystem:create(spaceshipPlayer.location:copy(), 12)
            systemCrash:createParticles(spaceshipPlayer.polygons)
        else
            systemCrash:updateOne(dt)    
        end

        
    else
        checkCollisions()
    end
    
    --очищаем таблицу нажатых клавиш:
    love.keyboard.keysPressed = {}
end

function love.draw(dt)
    camera:attach()
        sf:draw()
        --bg
        --love.graphics.setColor ( .14 , .36 , .46 )
        --love.graphics.rectangle ( 'fill' , 0 , 0 , widthField, heightField) --w=300, h=388
        landscape:draw()

        if state == GAME_STATE['CRASHED'] then
            if systemCrash then
                systemCrash:draw()
            end
        else
            spaceshipPlayer:draw()
        end

        

    -- love.graphics.circle('fill', 400, 300, circle1.radius)



       
    camera:detach()
    love.graphics.print("Angle:".. math.abs(math.deg(spaceshipPlayer.angle)), 15, 30)
    love.graphics.print("Velocity_X:"..  math.abs(spaceshipPlayer.velocity.x) * 100, 15, 60)
    love.graphics.print("Velocity_Y:"..  math.abs(spaceshipPlayer.velocity.y) * 100, 15, 90)
    love.graphics.print("Altitude:".. spaceshipPlayer.altitude, 15, 120)
end




function love.keypressed(key)
    --нажата клавиша в текущем кадре:
    love.keyboard.keysPressed[key] = true

    --exit game:
    if key == "escape" then
        love.event.push("quit")
      end

end

--проверка таблицы нажатых клавиш:
function love.keyboard.wasPressed(key)  
    return love.keyboard.keysPressed[key] --true/false
end

function checkCollisions()
    for i = 1, #landscape.vectorsTable-1 do
        if spaceshipPlayer:intersectsWithLine(landscape.vectorsTable[i], landscape.vectorsTable[i + 1]) then
            isPaused = true
            state = GAME_STATE['CRASHED']
            print("crashed ")





            if landscape.vectorsTable[i].y == landscape.vectorsTable[i + 1].y and checkPointOnLine(i) then
                if (spaceshipPlayer.velocity.x < TOP_VELOCITY_X) and (spaceshipPlayer.velocity.y < TOP_VELOCITY_Y) and (spaceshipPlayer:isGoodAngle()) then -- угол допустим +-10 градусов
                    state = GAME_STATE['LANDED']
                    print("Landed... ")
                end
            end
        end
    end
end


function checkPointOnLine(i) -- крайние шасси корабля должны быть в пределах посадочной площадке
    if (landscape.vectorsTable[i].x <= spaceshipPlayer.polygons[2][5] + spaceshipPlayer.location.x) and
     (landscape.vectorsTable[i + 1].x >= spaceshipPlayer.polygons[3][7] + spaceshipPlayer.location.x) then
        return true
    end

    return false
end