StarsField = {}
StarsField.__index = StarsField


function StarsField:create(count, typeS, landscape)
    local stars = {}
    setmetatable(stars, StarsField)
    stars.count = count or 100
	stars.fieldTable = {}
    stars.typeS = typeS or 'line'
    stars.landscape = landscape
    stars:generateField()
    return stars
end

-- создание звезд:
function StarsField:generateField() -- координаты звезд
  --  print(landscape)
  if self.landscape ~= nil then
    for i=1, self.count do	
        for i = 1, #self.landscape.vectorsTable-1 do
            local star = Star:create(false, self.typeS)
            local minL = math.min(self.landscape.vectorsTable[i].y, self.landscape.vectorsTable[i+1].y)

            if self.landscape.vectorsTable[i].x < star.location.x and self.landscape.vectorsTable[i+1].x > star.location.x then
                if star.location.y < minL then
                    table.insert(self.fieldTable, star)	 
                end
                
            end
        end
	end
    else
        for i=1, self.count do	
            local star = Star:create(false, self.typeS)
            table.insert(self.fieldTable, star)	 
        end
  end

end

function StarsField:update(dt)
	for i, star in pairs(self.fieldTable) do
		star.location.x = star.location.x + dt * star.velocityX
       -- print(star.location)
		if (star.location.x < 0) then
			self.fieldTable[i] = Star:create(true, self.typeS) -- замена звезд, когда за экраном 
		end
	end
end

function StarsField:draw()
    love.graphics.push()
    r,g,b,a = love.graphics.getColor()

	for i, star in pairs (self.fieldTable) do
		love.graphics.setColor(star.color)
		love.graphics.setLineWidth( star.radius / 2 )
		love.graphics.line(star.location.x, star.location.y,
                         star.location.x - (star.velocityX ^ 2) * 0.00002, star.location.y)
	end

    love.graphics.setColor(r,g,b,a)
    love.graphics.pop()
end

function StarsField:drawCircleStars()
    r,g,b,a = love.graphics.getColor()

	for i, star in pairs (self.fieldTable) do
		love.graphics.setColor(star.color, star.radiance)
		love.graphics.circle('fill', star.location.x, star.location.y, star.radius)
	end

    love.graphics.setColor(r,g,b,a)
end

--Проверить, находится ли точка под линией:
function StarsField:isPointUnderLine(left, right, point)
    --координаты каждой точки на линии ( функ-ия линии: y = dx * x + y0)
    if ((point.x < left.x) or (point.x > right.x)) then
        return false
    end

    --приращение для X
    local dx = (right.y - left.y) / (right.x - left.x)
    local y0 = left.y

    --смещение точки по по оси X относительно начала линии (x = 0)
    local newX = point.x - left.x

    --когда точка под линией
    return (point.y > (dx * newX + y0));
end



