Particle = {}
Particle.__index = Particle

function Particle:create(position, pointsPolygon)
    local particle = {}
    setmetatable(particle, Particle)

    particle.position = position
    particle.acceleration = Vector:create(0, 0.01)
    particle.velocity = Vector:create(math.random(75, 180) / 10, math.random(75, 180) / 10)

    particle.lifespan = 100
    particle.pointsPolygon = pointsPolygon

   -- particle.texture = love.graphics.newImage("assets/coin.png")
    particle.r = random(0, -2*math.pi) + 1
    self.s = random(2, 3) 

    return particle
end


function Particle:update(dt)
    self.velocity:add(self.acceleration)
   -- self.position:add(self.velocity)
   -- self.lifespan = self.lifespan - 1

    self.position.x = self.position.x + self.velocity.x*math.cos(self.r)*dt 
    self.position.y = self.position.y + self.velocity.y*math.sin(self.r)*dt 
    --self.velocity.x = self.velocity.x + self.velocity.x*math.cos(self.r)*dt
    --self.velocity.y = self.velocity.y + self.velocity.y*math.sin(self.r)*dt

--[[    local v = Vector:create(self.velocity.x, self.velocity.y)
    print(self.position.x )
    self.pointsPolygon = map(self.pointsPolygon, function(k, v) 
         if k % 2 == 1 then 
                 return self.position.x + v + love.math.random(-1, 1)
         else 
                 return self.position.y + v + love.math.random(-1, 1) 
         end 
     end)
]]
  
end

function Particle:isDead()
    if self.lifespan < 0 then
        return true
    end

    return false
end

function Particle:draw()
   pushRotate(self.position.x, self.position.y, self.r)   -- запоминаем текущее состояние графической системы.
   local r, g, b, a = love.graphics.getColor()



   
   love.graphics.setLineWidth(2)
  -- love.graphics.polygon('line', self.pointsPolygon)
   love.graphics.setColor(255, 255, 255, self.lifespan / 100)
   love.graphics.line(self.position.x - self.s, self.position.y, self.position.x + self.s, self.position.y)
   love.graphics.line(self.position.x - self.s, self.position.y-10, self.position.x + self.s, self.position.y-10)
   --love.graphics.circle("line", self.position.x, self.position.y, 3)
   

   --love.graphics.circle("line", self.position.x, self.position.y, 3)
   -- love.graphics.polygon('line', self.pointsPolygon)
 --  love.graphics.line(self.pointsPolygon)
    --print(#self.pointsPolygon)


   local zigzagLine = {0.5, 355.55, 5.45, 355.55, 6.45, 359.4, 11.15, 359.4, 12.1, 363.65, 14.6, 363.65, 15.95, 375.75, 19.25, 388, 596.85, 355.55}


--[[    love.graphics.draw(self.texture, 
        self.position.x - 0.1 * self.texture:getWidth() / 2,
        self.position.y - 0.1 * self.texture:getHeight() / 2,
       0.1,        --scale
       0.1
    )
]]
--love.graphics.circle("fill", self.position.x, self.position.y, 5)
--    love.graphics.line(self.pointsPolygon[1], self.pointsPolygon[2], self.pointsPolygon[3], self.pointsPolygon[4])
   -- love.graphics.polygon('line', self.pointsPolygon)
    --print(self.pointsPolygon[1])
    --print(self.pointsPolygon[2])
    love.graphics.setLineWidth(1)
    love.graphics.setColor(r, g, b, a)
	love.graphics.pop() --возвращаем топологию в исходное состояние 
end


function Particle:applyForce(force)
    self.acceleration:add(force)
end