function map(table, func, ...)
    local _tableNew = {}
    for index, value in pairs(table) do
      local k, kv, v = index, func(index, value,...)
      _tableNew[v and kv or k] = v or kv
    end
    return _tableNew
  end

  function pushRotate(x, y, angle)
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(angle or 0)
    love.graphics.translate(-x, -y)
end

function random(min, max)
    local min, max = min or 0, max or 1
    return (min > max and (love.math.random()*(min - max) + max)) or (love.math.random()*(max - min) + min)
end




function get_red_blue_gradient_color (t) -- t is between 0 as red to 1 as blue
	local r = 2-4*t
	local g = t < 1/2 and 4*t or 4-4*t
	local b = -2 + 4*t
	r = math.min(math.max(0, r), 1)
	g = math.min(math.max(0, g), 1)
	b = math.min(math.max(0, b), 1)
	return {r^0.5,g^0.5,b^0.5,1}
end



