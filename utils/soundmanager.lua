SoundManager = {}

SoundManager.playSound = function(sound)
    if sound ~= nil then
        sound:play()
    end    
end

SoundManager.playLoop = function(sound)
    if sound ~= nil then
        sound:play(true)
    end  
end

SoundManager.getSound = function(soundName)
    print(soundName)
    return love.audio.newSource(soundName, "static")
end

SoundManager.stopSound = function(sound)
    if sound ~= nil then
        sound:stop()
    end
end
