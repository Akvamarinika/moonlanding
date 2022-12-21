Star = {}
Star.__index = Star

function Star:create(isOnEdge, type, color, radius)
    local star = {}
    setmetatable(star, Star)
    star.indent = 5
    star.location = nil
	star.radius = radius or (0.5 + 5 * math.random() ^ 2)
    star.color = color or {0.5 + 0.5 * love.math.random() ^ 0.5, 
                0.5 + 0.5 * love.math.random() ^ 0.5, 0.5 + 0.5 * love.math.random() ^ 0.5 }
    star.velocityX = (-star.radius * 500) * (0.1 + 0.9 * math.random())
    star.radiance = 0
    star.depth = 0
    star.isOnEdge = isOnEdge or false
    star.type = type or 'line'
    star:init(isOnEdge)
    return star
end

function Star:init(isOnEdge)
    --print(self.type)
    if self.type == 'circle' then

        local x = love.math.random() * widthField  --+ 2000
        local y = love.math.random() * heightField
        self.radiance = love.math.random(1, 255) -- alpha
        self.depth = love.math.random() * 8 + 0.5
        self.location = Vector:create(x, y)
        self.radius = love.math.random() * 1.4 + 0.1
    else
        local x = love.math.random(self.indent, widthField - self.indent)	--"случайное" число по X
        local y = love.math.random(self.indent, heightField - self.indent)
    
        if isOnEdge then -- звезды на границе экрана
            x = widthField
        end
    
        self.location = Vector:create(x, y)
        self.location.x = self.location.x - (1 / 60) * self.velocityX
    end
end



