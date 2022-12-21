
--Константы влияющие на движение коробля:
GRAVITY = 0.9    --0.4        --Увеличивает вертикальную скорость корабля 
ANGLE_VELOCITY = 2   --Изменение угла при нажатии клавиш "поворота"
THRUST_FACTOR = 3      --Используется для расчета приложенной мощности тяги - см. Процесс космического корабля. (spaceship process)


--Отображаются на экране:

TOP_VELOCITY_Y = 0.6 ------- максимальная 60
TOP_VELOCITY_X = 0.6 ------- максимальная 60
DRAG_X = THRUST_FACTOR/TOP_VELOCITY_X  --трение о воздух (для упрощения игры)
DRAG_Y = THRUST_FACTOR/TOP_VELOCITY_Y

--Начальные значения:
INITIAL_FUEL = 1500   --топливо
INITIAL_VY = 0        --вертикальная скорость коробля ( при падении ==> положительная)
INITIAL_VX = 1800     --горизонтальная скорость коробля   ( при движении вправо ==> положительная)

--Значения для проверки успешной посадки коробля:
SAFE_ANGLE = 2 * ANGLE_VELOCITY   --Приземление выполнено вертикально +/- этот угол будет безопасным
GOOD_LANDING_SPEED = 6
HARD_LANDING_SPEED = 12
GOOD_ANGLE_VELOCITY = -math.pi/2

--Бонус к очкам и топливу:
GOOD_SCORE = 50         --за успешную посадку коробля
HARD_SCORE = 20         --за "жесткую" посадку
CRASH_PAD_SCORE = 5     --за «аварию» на посадочной площадке

FUEL_BONUS = 50         --бонус к топливу при успешной посадке
FUEL_PENALTY = -250    --за «аварию» вне посадочной площадки
FUEL_ABORT = -100    -- топливо при прерывании миссии


Spaceship = {}
Spaceship.__index = Spaceship

function Spaceship:create(location)
    local spaceship = {}
    setmetatable(spaceship, Spaceship)
    spaceship.width = 7 --12
    spaceship.height = 7 --12
    spaceship.angle = -math.pi/2  --угол, под которым движется кораль (-math.pi/2 == верх, math.pi/2 == вниз)
    spaceship.angleVelocity = ANGLE_VELOCITY  --0.8*math.pi  --скорость изменения угла, при нажатии клавиш влево или вправо
    spaceship.location = location
    spaceship.velocity = Vector:create(0, 0)
    spaceship.acceleration = Vector:create(0, 0)    --100
    --spaceship.weight = weight or 1
    --spaceship.size = 20  * spaceship.weight
    spaceship.fuel = INITIAL_FUEL
    spaceship.altitude = 0
    spaceship.isEngineActive = false
    spaceship.timer = ExtendedTimer:create() 
    spaceship.fire_color = {255, 198, 93} 

    spaceship.polygons = {}

    spaceship:init()

    spaceship.systemFire = nil
    spaceship.systemFire2 = nil

    spaceship.boost = nil





 --   spaceship.fireParticle = FireParticle:create(Vector:create(-spaceship.width - spaceship.width/2, 0))
      spaceship.fireParticles = {}



    spaceship.vx = INITIAL_VX               --Горизонтальная скорость космического корабля
    spaceship.vy = INITIAL_VY               --Вертикальная скорость космического корабля
    spaceship.thrust = 0          --Тяга (изменяется игроком)
    --spaceship.angle2            --Угол смещения космического корабля, используется, когда корабль находится в вертикальном положении (angle == 0)

    return spaceship
end



function Spaceship:update(dt)
       -- if self.timer then self.timer:update(dt) end





		----SHIP CONTROL   self.angle = self.angle - self.rv*dt ====left
		if love.keyboard.isDown('right') then
			self.angle = self.angle + (self.angleVelocity * dt)
			if math.deg(self.angle) > 0 then self.angle = 0 end
		end

		if love.keyboard.isDown('left') then
			self.angle = self.angle - (self.angleVelocity * dt)
			if math.deg(self.angle) < -180 then self.angle = -math.pi/2 * 2 end
		end

		if love.keyboard.isDown('up') and self.fuel > 0 then
          self.isEngineActive = true
          self.fuel = math.floor(self.fuel - (0.2 * THRUST_FACTOR))

          self.velocity.y = self.velocity.y + math.sin(self.angle) * THRUST_FACTOR * dt * (1 - math.min(dt * DRAG_Y, 1))
          self.velocity.x = self.velocity.x + math.cos(self.angle) * THRUST_FACTOR * dt * (1 - math.min(dt * DRAG_X, 1))
        end    


        --turbo acceleration:
        if love.keyboard.isDown('w') and self.fuel > 0 then
            self.isEngineActive = true
            self.fuel = self.fuel - (0.4 * THRUST_FACTOR)
  
            self.velocity.y = self.velocity.y + math.sin(self.angle) * THRUST_FACTOR * dt * (1 - math.min(dt * DRAG_Y, 1)) * 5
            self.velocity.x = self.velocity.x + math.cos(self.angle) * THRUST_FACTOR * dt * (1 - math.min(dt * DRAG_X, 1)) * 5
        end


        if love.keyboard.isDown('up') or love.keyboard.isDown('w') then
            self.systemFire = ParticleSystem:create(Vector:create(self.polygons[4][5] + self.location.x, self.polygons[4][6] + self.location.y), 20, FireParticle)
           
            if self.systemFire ~= nil then
                self.systemFire:update(dt)
            end
        else
            self.systemFire = nil
            self.isEngineActive = false
        end
          



        self.trail_color = {255, 198, 93}
        if self.isEngineActive then self.trail_color = {76, 195, 217} end





        self.velocity.y = self.velocity.y + (GRAVITY * dt) --- +гравитационное притяжение Луны, изменение вертикальной скорости
        self.velocity = self.velocity + self.acceleration * dt

		self.location.x = self.location.x + self.velocity.x
		self.location.y = self.location.y + self.velocity.y

        --выход за пределы экрана по X:
        if self.location.x > widthField then
            self.location.x = 0
        end

        if self.location.x < 0  then
            self.location.x = widthField
        end

        --ограничение скорости:
		if self.velocity.y < -TOP_VELOCITY_Y  then self.velocity.y = -TOP_VELOCITY_Y  end 
		if self.velocity.x < -TOP_VELOCITY_X  then self.velocity.x = -TOP_VELOCITY_X  end 
		if self.velocity.x > TOP_VELOCITY_X  then self.velocity.x = TOP_VELOCITY_X  end 

end


function Spaceship:draw()
    
    pushRotate(self.location.x, self.location.y, self.angle)  --поворот полигонов вокруг центра игрока
    --love.graphics.setColor(222, 222, 222)

    --рисование полигонов:
    local v = self.velocity;
    for _, polygon in ipairs(self.polygons) do 
        local points = map(polygon, function(k, v) 
        	if k % 2 == 1 then 
          		return self.location.x + v --+ love.math.random(-1, 1)  --нечетный индекс эл-та  ==>  для компонента x
        	else 
          		return self.location.y + v --+ love.math.random(-1, 1) 
        	end 
      	end)
        love.graphics.polygon('line', points)
    end

    love.graphics.circle("line", self.width/2 + self.location.x, self.location.y, 2)
    love.graphics.circle("line", -self.width/4 + self.location.x, self.location.y, 2)

    love.graphics.circle("fill", self.polygons[2][5] + self.location.x, self.polygons[2][6] + self.location.y, 2) --9
    love.graphics.circle("fill", self.polygons[3][7] + self.location.x, self.polygons[3][8] + self.location.y, 2) --15
    love.graphics.circle("fill", self.polygons[4][5] + self.location.x, self.polygons[4][6] + self.location.y, 2) --19
---    love.graphics.line(self.location.x, self.location.y, self.location.x + 2*self.width*math.cos(self.angle), self.location.y + 2*self.width*math.sin(self.angle))

--love.graphics.circle('fill', self.polygons[2][3] + self.location.x  + self.width, self.polygons[2][4] + self.location.y, 3)
--love.graphics.circle('fill', self.polygons[3][9] + self.location.x + self.width, self.polygons[3][10] + self.location.y, 3)
--love.graphics.circle('fill', self.polygons[2][5] + self.location.x, self.polygons[2][6] + self.location.y, 3) ------------------
--love.graphics.circle('fill', self.polygons[3][7] + self.location.x, self.polygons[3][8] + self.location.y, 3)

    if self.isEngineActive and self.systemFire ~= nil then
        self.systemFire:draw()
    end
    



    love.graphics.pop() -- удаляет полигоны
end




function Spaceship:init()
    self.polygons[1] = {
        self.width, 0, -- 1
        self.width/2, -self.width/2, -- 2
        -self.width/2, -self.width/2, -- 3
        -self.width, 0, -- 4
        -self.width/2, self.width/2, -- 5
        self.width/2, self.width/2, -- 6
    }
    
    self.polygons[2] = {
        self.width/2, -self.width/2, -- 7
        0, -self.width, -- 8
        -self.width - self.width/2, -self.width, -- 9
        -3*self.width/4, -self.width/4, -- 10
        -self.width/2, -self.width/2, -- 11
    }
    
    self.polygons[3] = {
        self.width/2, self.width/2, -- 12
        -self.width/2, self.width/2, -- 13
        -3*self.width/4, self.width/4, -- 14
        -self.width - self.width/2, self.width, -- 15
        0, self.width, -- 16
    }

    self.polygons[4] = {
        -3*self.width/4, -self.width/4, -- 17
        -3*self.width/4, self.width/4, -- 18
        -self.width - self.width/2, 0  -- 19
    }


    -----------Boost----------------------------------------------------------------------------------------------------------------------------------
    self.fire_color = {76, 195, 217}
    self.timer:every(0.01, function()

    if self.spaceship then
        local locationFireParticle = Vector:create( self.location.x - 0.9*self.width*math.cos(self.angle) + 0.2*self.width*math.cos(self.angle - math.pi/2), 
                                    self.location.y - 0.9*self.width*math.sin(self.angle) + 0.2*self.width*math.sin(self.angle - math.pi/2))
     --   table.insert(self.fireParticles, 
     self.boost =  FireParticle:create(Vector:create(locationFireParticle), {radius = love.math.random(2, 4), duration = love.math.random(0.15, 0.25), color = self.trail_color})
        
      --  )
            --print(#self.fireParticles)

    end       
--           self.x - 0.9*self.width*math.cos(self.angle) + 0.2*self.width*math.cos(self.angle + math.pi/2), 
--           self.y - 0.9*self.width*math.sin(self.angle) + 0.2*self.width*math.sin(self.angle + math.pi/2), 
--           {parent = self, angle = random(2, 4), d = random(0.15, 0.25), color = self.fire_color})

    end)
end


function Spaceship:intersectsWithLine(pointA, pointB)
    r,g,b,a = love.graphics.getColor()

    love.graphics.setColor(get_red_blue_gradient_color(0.5))    
    --верх лево 8
--    if  (math.abs(math.deg(self.angle)) >= 150) and (math.abs(math.deg(self.angle)) >= 15) and
        if self:isPointUnderLine(pointA, pointB, Vector:create(self.polygons[2][3] + self.location.x, self.polygons[2][4] + self.location.y)) then
            
        return true
    end

    --верх право 16
 --   if (math.abs(math.deg(self.angle)) >= 150) and (math.abs(math.deg(self.angle)) >= 15) and
   if self:isPointUnderLine(pointA, pointB, Vector:create(self.polygons[3][9] + self.location.x, self.polygons[3][10] + self.location.y)) then
    
        return true
   end

    --низ лево 9
 --   if  (math.abs(math.deg(self.angle)) <= 150) and (math.abs(math.deg(self.angle)) >= 15) and
if self:isPointUnderLine(pointA, pointB, Vector:create(self.polygons[2][5] + self.location.x, self.polygons[2][6] + self.location.y + self.height)) then
    
        return true
    end

    --низ право 15
 --   if (math.abs(math.deg(self.angle)) <= 150) and (math.abs(math.deg(self.angle)) >= 15) and
if  self:isPointUnderLine(pointA, pointB, Vector:create(self.polygons[3][7] + self.location.x, self.polygons[3][8] + self.location.y + self.height)) then
    
        return true
    end

    love.graphics.setColor(r,g,b,a)

    --1
   if self:isPointUnderLine(pointA, pointB, Vector:create(self.polygons[1][1] + self.location.x, self.polygons[1][2] + self.location.y)) then
        return true
   end

    --19
    if (math.abs(math.deg(self.angle)) <= 150) and (math.abs(math.deg(self.angle)) >= 15) and
        self:isPointUnderLine(pointA, pointB, Vector:create(self.polygons[4][5] + self.location.x, self.polygons[4][6] + self.location.y + self.height)) then
        return true
    end

    return false
end

--Проверить, находится ли точка под линией:
function Spaceship:isPointUnderLine(left, right, point)
    --координаты каждой точки на линии ( функ-ия линии: y = dx * x + y0)
    if ((point.x < left.x) or (point.x > right.x)) then
        return false
    end

    --приращение для X
    local dx = (right.y - left.y) / (right.x - left.x)
    local y0 = left.y

    --смещение точки по по оси X относительно начала линии (x = 0)
    local newX = point.x - left.x

    
    local alt = 9999999999999
    self.altitude = (dx * newX + y0) - (point.y - self.height)  --Vector:create(dx * newX + y0)




    --когда точка под линией
    return (point.y > (dx * newX + y0));
end




function Spaceship:isGoodAngle()
    return ((math.abs(math.deg(self.angle)) <= 100) and (math.abs(math.deg(self.angle)) >= 80))
end

function Spaceship:isMainPointsOnStraightLine()
end

