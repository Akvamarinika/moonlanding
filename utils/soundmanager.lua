SoundManager = {}

SoundManager.playSound = function(sound)
    if sound ~= nil then
        sound:play()
    end    
end

SoundManager.playLoop = function(loop)
    
end

SoundManager.getSound = function(soundName)
    return love.audio.newSource(soundName, "stream")
end

SoundManager.stopSound = function(sound)
    if sound ~= nil then
        sound:stop()
    end
end
