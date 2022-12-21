require("screens/gamestate")
require("screens/gamescreen")
require("screens/titlescreen")
require("screens/winscreen")
require("screens/failscreen")
require("screens/strings")
require("screens/menu")
require("stars/star")
require("stars/starsfield")


--require("utils/extendedTimer")
--require("utils/corner-rounder")
require("utils/utilsfunc")
require("utils/vector")
require("landscape")
require("spaceship")
require("fireParticle")
require("particle")
require("particlesystem")

--Timer = require 'utils/extendedTimer'
Camera = require 'utils/camera'

widthField = love.graphics.getWidth()
heightField = love.graphics.getHeight()

--local currentScreen
gameState = GameState:create()

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

        --шрифты:
    --gameFont = love.graphics.newFont('.ttf', 14)
    --love.graphics.setFont(gameFont)

    --таблица со звуковыми файлами:
    sounds = {
        ['point'] = love.audio.newSource('assets/audio/point.wav', 'static'),
        ['jump'] = love.audio.newSource('assets/audio/jump.wav', 'static'),
        ['collision'] = love.audio.newSource('assets/audio/collision.wav', 'static'),
        ['die'] = love.audio.newSource('assets/audio/die.wav', 'static'),
        ['music_start'] = love.audio.newSource('assets/audio/menu8bit.mp3', 'static'),
        ['music_game'] = love.audio.newSource('assets/audio/vesna8bit.mp3', 'static')
    }

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