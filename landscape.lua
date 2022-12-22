

Landscape = {}
Landscape.__index = Landscape

function Landscape:create()
    local landscape = {}
    setmetatable(landscape, Landscape)
    landscape.vectorsTable = {}
    landscape.RAND_MAX = 2147483647 --32767
    landscape.totalHeight = 200
    landscape.stripWidth = 60
    landscape:generate()
    return landscape
end

function Landscape:generate()
  --table.insert(self.vectorsTable, Vector:create(0, self.totalHeight + 30))
    local w = -500 -- -2000     -- 20
    local h = 0

    while w <= widthField +500 do --+ 2000 do
        h = love.math.random(0, self.totalHeight) 
        table.insert(self.vectorsTable, Vector:create(w, h+heightField/2 )) --- heightField/10
--        print(Vector:create(w, h))
        w = w + love.math.random(0, 100) + 40
    end

    local landingsCount = love.math.random(1, 5) + 5
    for i = 1, landingsCount, 1 do
        local index = love.math.random(1, #self.vectorsTable-2) 
        local strip = Vector:create(self.vectorsTable[index].x + self.stripWidth, self.vectorsTable[index].y)
        table.insert(self.vectorsTable, index+1, strip)
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
 
end

function Landscape:draw()
--print(#self.vectorsTable)

love.graphics.push()
r,g,b,a = love.graphics.getColor()

for i = 1, #self.vectorsTable - 1 do
    if self.vectorsTable[i].y == self.vectorsTable[i + 1].y then

        love.graphics.setColor(get_red_blue_gradient_color(0.1))
        love.graphics.setLineWidth(4)
    else
        love.graphics.setColor(get_red_blue_gradient_color(0.8))    
        love.graphics.setLineWidth(2)
    end

    love.graphics.line(self.vectorsTable[i].x, self.vectorsTable[i].y, self.vectorsTable[i + 1].x, self.vectorsTable[i + 1].y)
end

love.graphics.setLineWidth(1)
love.graphics.setColor(r,g,b,a)
love.graphics.pop()

end