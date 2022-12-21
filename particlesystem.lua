ParticleSystem = {}
ParticleSystem.__index = ParticleSystem

function ParticleSystem:create(origin, n, cls) --n кол-во, cls - класс частица
    local system = {}
    setmetatable(system, ParticleSystem)
    system.origin = origin
    system.n = n or 20
    system.args = {radius = love.math.random(1, 4), duration = love.math.random(0.15, 0.25), color = {76, 195, 217}}
    system.particles = {}
    system.cls = cls or Particle
    system.index = 1

    return system
end

function ParticleSystem:createParticle()
    return self.cls:create(self.origin:copy() + Vector:create(0, 0), self.args)
end

function ParticleSystem:update(dt)
   -- print(#self.particles)
    if #self.particles < self.n then -- len 
        self.particles[self.index] = self:createParticle()
        self.index = self.index + 1
    end

--    table.sort(self.particles, function(a, b)
 --       return a.radius > b.radius
--    end)

    for key, value in pairs(self.particles) do
        if value:isDead() then
            value = self:createParticle() --генерир-ет постоянно частицы
            self.particles[key] = value
        end
        value:update(dt)
    end
end

function ParticleSystem:draw()
    local r, g, b, a = love.graphics.getColor()

    for key, value in pairs(self.particles) do
        value:draw(self.args)
    end

    love.graphics.setColor(r, g, b, a)

end




--создает частицы 1 раз:
function ParticleSystem:createParticles() --polygons
    --print(self.origin)
--    for i = 1, #polygons, 1 do 
       -- print('pol '..polygons[i][2])
--        self.particles[i] = self.cls:create(self.origin:copy(), polygons[i])
        --end
        --self.n = #polygons
        for i = 1, self.n, 1 do  --4 полигона
       --      print('pol '..polygons[i][3])
             self.particles[i] = self.cls:create(self.origin:copy()) --, polygons[i]

        end
       -- self.particles[i] = self.cls:create(self.origin:copy())
    
    
end

function ParticleSystem:updateOne(dt)
    --print(self.origin)
     for i = 1, self.n do
       self.particles[i]:update(dt)
    end
end

function ParticleSystem:setNewPosition(position)
    self.origin = position
end


function ParticleSystem:applyForce(force)
    for key, value in pairs(self.particles) do
        value:applyForce(force)
    end
end

function ParticleSystem:applyRepeller(repeller)
    for key, value in pairs(self.particles) do
        value:applyForce(repeller:repel(value))
    end 
end