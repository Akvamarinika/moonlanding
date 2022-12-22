FireParticle = {}
FireParticle.__index = FireParticle

function FireParticle:create(location, args)
    local particle = {}
    setmetatable(particle, FireParticle)
    particle.location = location
    particle.dead = false
    particle.radius = args.radius or random(2, 6)
    particle.lifespan = 100
    particle.color = args.color
    particle.acceleration = Vector:create(0, 0.08)
    particle.velocity = Vector:create(math.random(-2, -300) / 10, math.random(2, 10) / 10)
    return particle
end

function FireParticle:update(dt)
    self.velocity:add(self.acceleration)
    self.location:add(self.velocity)
    self.lifespan = self.lifespan - 1
end

function FireParticle:draw()
    local r, g, b, a = love.graphics.getColor()
    love.graphics.setBlendMode("alpha")
    love.graphics.setColor(get_red_blue_gradient_color(random(0.1, 0.2)), love.math.random(1, 255))
    love.graphics.circle('fill', self.location.x, self.location.y, self.radius)
    love.graphics.setColor(255, 255, 255)
    love.graphics.setColor(r, g, b, a)
end

function FireParticle:isDead()
    if self.lifespan < 0 then
        return true
    end

    return false
end