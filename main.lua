require("screens/gamestate")
require("screens/gamescreen")
require("screens/titlescreen")
require("screens/winscreen")
require("screens/failscreen")
require("screens/strings")
require("stars/star")
require("stars/starsfield")


--require("utils/extendedTimer")
require("utils/soundmanager")
require("utils/utilsfunc")
require("utils/vector")
require("landscape")
require("spaceship")
require("fireParticle")
require("particle")
require("particlesystem")

Camera = require 'utils/camera'

widthField = love.graphics.getWidth()
heightField = love.graphics.getHeight()

--local currentScreen
gameState = GameState:create()

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

        --таблица со звуковыми файлами:
        sounds = {                    
            ['menu_change'] = love.audio.newSource("assets/menu_change.wav", 'static'),
            ['menu_confirmed'] = love.audio.newSource("assets/menu_confirmed.wav", 'static'),
            ['music_start'] = love.audio.newSource("assets/menu_teleport.wav", 'static'),
            ['collision'] = love.audio.newSource('assets/explode.wav', 'static'),
            ['win'] = love.audio.newSource('assets/win.wav', 'static'),
            ['pause-off'] = love.audio.newSource('assets/pause-off.ogg', 'static'),
            ['pause-on'] = love.audio.newSource('assets/pause-on.ogg', 'static'),
            ['engine'] = love.audio.newSource('assets/engine.wav', 'static'),
            ['music_game'] = love.audio.newSource('assets/magic.mp3', 'static')
        }
    
        --шрифты:
        smallFont = love.graphics.newFont('assets/fonts/SpaceExplorer.ttf', 8)
        mediumFont = love.graphics.newFont('assets/fonts/SpaceExplorer.ttf', 14)
        gameFont = love.graphics.newFont('assets/fonts/SpaceExplorer.ttf', 28)
        hugeFont = love.graphics.newFont('assets/fonts/SpaceExplorer.ttf', 64)

        love.graphics.setFont(gameFont)

--    currentScreen = screens.titleScreen
    gameState:setState(gameState.titleScreen)
    gameState.currentState:reset()

    --создание таблицы для хранения нажатых клавиш(в одном кадре):
    love.keyboard.keysPressed = {}
end

function love.update(dt)
    gameState.currentState:update(dt)

    if gameState.newState ~= gameState.currentState then
        gameState:setState(gameState.newState)
        gameState.currentState:reset()
    end

    --очищаем таблицу нажатых клавиш:
    love.keyboard.keysPressed = {}
end

function love.draw()
    gameState.currentState:draw()
end

function love.keypressed(key)
    --нажата клавиша в текущем кадре:
    love.keyboard.keysPressed[key] = true

    gameState.currentState:keyPressed(key)
end

--проверка таблицы нажатых клавиш:
function love.keyboard.wasPressed(key)  
    return love.keyboard.keysPressed[key] --true/false
end