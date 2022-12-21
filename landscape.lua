local cr = require "utils/corner-rounder"
local size = 100
--2147483647
Landscape = {}
Landscape.__index = Landscape

function Landscape:create()
    local landscape = {}
    setmetatable(landscape, Landscape)
    landscape.vectorsTable = {}
    landscape.pointsTable = {}
    landscape.stripsTable = {}
    landscape.RAND_MAX = 2147483647 --32767
    landscape.totalHeight = 200
    landscape.stripWidth = 60
   -- landscape:init()
    landscape:generate()
    return landscape
end


function Landscape:init()
--[[   for i = 1, size, 1 do
        local height = 0
        for j = 1, 5, 1 do
            height = height + love.math.random(0, self.RAND_MAX) % 50 + 540
        end

        height = height / 5
        table.insert(self.vectorsTable, Vector:create(widthField/size, height))
        table.insert(self.pointsTable, widthField/size)
        table.insert(self.pointsTable, height)

        print(Vector:create(widthField/size, height))
    end]] 
end


function Landscape:generate()
  --table.insert(self.vectorsTable, Vector:create(0, self.totalHeight + 30))
    local w = -500 -- -2000     -- 20
    local h = 0

    while w <= widthField +500 do --+ 2000 do
        h = love.math.random(0, self.totalHeight) --* love.math.noise( w, h )--* love.math.cos(love.math.rad(30))
--        h = 10 + 10 * love.math.noise(h)
        table.insert(self.vectorsTable, Vector:create(w, h+heightField/2 )) --- heightField/10
 --       table.insert(self.pointsTable, w)
--        table.insert(self.pointsTable, h+heightField/2 )
--        print(Vector:create(w, h))
        w = w + love.math.random(0, 100) + 40
    end

    local landingsCount = love.math.random(1, 5) + 5
    for i = 1, landingsCount, 1 do
        local index = love.math.random(1, #self.vectorsTable-2) 
        local strip = Vector:create(self.vectorsTable[index].x + self.stripWidth, self.vectorsTable[index].y)
        table.insert(self.vectorsTable, index+1, strip)
        table.insert(self.stripsTable,strip)
 --       table.insert( self.pointsTable, index+1, self.pointsTable[index] + self.stripWidth)
--        table.insert( self.pointsTable, index+1, self.pointsTable[index])
    end
 
   h = love.math.random(0, self.totalHeight)
   table.insert(self.vectorsTable, Vector:create(widthField+500, h+heightField/2 ))      --self.totalHeight + 30)) end landscape

      local min = math.huge
      for i = 1, #self.vectorsTable  do
         min = min < self.vectorsTable[i].y and min or self.vectorsTable[i].y
      end

 --     print(min)
      for i = 1, #self.vectorsTable do
        self.vectorsTable[i] = Vector:create(self.vectorsTable[i].x, heightField - (self.vectorsTable[i].y - min) )
      end


--table.sort(self.vectorsTable, function (left, right)
--    return left.x < right.x
--end)


      for i = 1, #self.vectorsTable do
        table.insert(self.pointsTable, self.vectorsTable[i].x)
        table.insert(self.pointsTable, self.vectorsTable[i].y)
      end
 
end

function Landscape:draw()
  -- for i = 1, #self.pointsTable do
        
  --  end

--  local points = cr.tranform_line_points(self.pointsTable)
 
  --[[установили рисование на канвас , теперь всё последующие рисование будет произходить на канвасе]]
--print(#self.vectorsTable)
--print(#self.pointsTable)
  --if #self.vectorsTable * 2 == #self.pointsTable then

--    curve = love.math.newBezierCurve( self.pointsTable )
--    coordinates = curve:render(2)
    
  
--love.graphics.setCanvas(canvas)  --рисуем прямоугольник на канвасе


--love.graphics.line(self.pointsTable)
--love.graphics.line(coordinates)
love.graphics.push()
r,g,b,a = love.graphics.getColor()


--for i = 1, #self.stripsTable do
--    love.graphics.line(self.stripsTable[i].x - 40, self.stripsTable[i].y, self.stripsTable[i].x, self.stripsTable[i].y)
--end

for i = 1, #self.vectorsTable - 1 do
    if self.vectorsTable[i].y == self.vectorsTable[i + 1].y then
        --print()
        love.graphics.setColor(get_red_blue_gradient_color(0.1))
        love.graphics.setLineWidth(4)
    else
        love.graphics.setColor(get_red_blue_gradient_color(0.8))    
        love.graphics.setLineWidth(2)
    end

    
--    love.graphics.polygon('line', self.pointsTable)
    love.graphics.line(self.vectorsTable[i].x, self.vectorsTable[i].y, self.vectorsTable[i + 1].x, self.vectorsTable[i + 1].y)
end

love.graphics.setLineWidth(1)
love.graphics.setColor(r,g,b,a)
love.graphics.pop()
--print(#self.pointsTable)
--love.graphics.polygon('line', self.pointsTable)

--love.graphics.setCanvas()   -- вновь установили рисование на игровое окно
--love.graphics.draw(canvas,0,0)  -- рисуем наш канвас



--end
 --[[   --рисование полигонов:
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
     end]] 
end