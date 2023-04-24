w, h = love.graphics.getDimensions()

---------------------------------------------------------------------------
-- game load

function love.load()
    local bump = require('THM/SRC/LIBRARIES/bump')
    world = bump.newWorld(50)
    
		hud = require('THM/SRC/UI/hud')
		hud:load()
		
		map = require('THM/SRC/map')
		map:load()
		
		local playerSpr = love.graphics.newImage('THM/ASSETS/player.png')
		local classPlayer = require('THM/SRC/ENTITIES/player')
		player = classPlayer.new('player', playerSpr, w/2-150, h/2, 32, 48, 5)
		
    -- -- camera load
    local camera = require('THM/SRC/LIBRARIES/camera')
    cam = camera(player.x, player.y)
end

---------------------------------------------------------------------------
-- game update

local t = 0
function love.update(dt)
    t = lerp(t, dt*60, 0.1) 
    
    local dx = (player:getX() - cam.x) * 0.1 * t
    local dy = (player:getY() - cam.y) * 0.1 * t
    cam:move(dx, dy)
    
		hud:update(t)
		map:update(t)
		player:update(t)
end

---------------------------------------------------------------------------
-- game draw
function drawDebug(table, x)
  local i = 1
  for key, value in pairs(table) do
    if type(value) ~= 'table' then
      love.graphics.print(key .. ": " .. tostring(value), x, 15*i)
      i = i + 1
    end
  end
end

function love.draw()
    cam:attach()
      map:draw()
      player:draw()
    cam:detach()
		hud:draw()
		
		love.graphics.print('timer: '..t..'\nfps: '..love.timer.getFPS()..'\nmap mode: '..map.mode, w*0.8, h*0.1)
		-- love.graphics.print(w..' '..h, w*0.8, h*0.3)
    
    drawDebug(player, w*0.01)
end

---------------------------------------------------------------------------

-- retorns linear interpolation
function lerp(p1, p2, t)
		return p1 + (p2 - p1) * t
end

-- returns distace of two points
function distance(x1, y1, x2, y2)
    local dx = x1 - x2
    local dy = y1 - y2
    return math.sqrt(dx*dx + dy*dy)
end

---------------------------------------------------------------------------