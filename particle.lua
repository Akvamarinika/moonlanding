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

    particle.r = random(0, -2*math.pi) + 1
    self.s = random(2, 3) 

    return particle
end


function Particle:update(dt)
    self.velocity:add(self.acceleration)

    self.position.x = self.position.x + self.velocity.x*math.cos(self.r)*dt 
    self.position.y = self.position.y + self.velocity.y*math.sin(self.r)*dt 
    --self.velocity.x = self.velocity.x + self.velocity.x*math.cos(self.r)*dt
    --self.velocity.y = self.velocity.y + self.velocity.y*math.sin(self.r)*dt
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
   --print(#self.pointsPolygon)
    love.graphics.setLineWidth(1)
    love.graphics.setColor(r, g, b, a)
	love.graphics.pop() --возвращаем топологию в исходное состояние 
end


function Particle:applyForce(force)
    self.acceleration:add(force)
end