local entity = {}
entity.__index = entity

---------------------------------------------------------------------------
-- create the entity class

function entity.new(class, name, spr, x, y, w, h, speed)
		local self = setmetatable({}, entity)
    
		self.class = class
		self.name = name
		self.spr = spr
		self.x = x
		self.y = y
		self.w = w
		self.h = h
		self.vx = 0
		self.vy = 0
		self.dir = 1
		self.speed = speed
		self.isDead = false
		world:add(self, x, y, w, h) -- collider create
		
		return self
end

---------------------------------------------------------------------------
-- info

function entity:getX()
		return self.x
end

function entity:getY()
		return self.y
end

function entity:getWidth()
		return self.w
end

function entity:getHeight()
		return self.h
end

---------------------------------------------------------------------------
-- retorns collisions

function entity:isColl(x, y, w, h)
    return self.x < x + w and x < self.x + self.w and self.y < y + h and y < self.y + self.h
end

---------------------------------------------------------------------------
-- entity movement

function entity:move(dx, dy, t)
    -- move the entity
    local goalX = self.x + dx * t
    local goalY = self.y + dy * t
    local actualX, actualY, cols, len = world:move(self, goalX, goalY)
    self.x, self.y = actualX, actualY
    
    -- stops moving if colliding with the map
    for _ = 1, len do
      local col = cols[_]
      if col.normal.x ~= 0 then self.vx = 0 end
      if col.normal.y ~= 0 then self.vy = 0 end
      if col.other.type == 4 then self:die() end
    end
end

function entity:setPosition(x, y)
    -- set position
    world:update(self, x, y)
    self.x, self.y = x, y
end

---------------------------------------------------------------------------
-- life system

function entity:die()
    self.isDead = true
    love.event.quit('restart')  
end

---------------------------------------------------------------------------
-- entity draw

-- draws the blocks in the player's reach area
local lightRange = 150

local function drawLight(self, range)
    local items, len = world:queryRect(self.x-range, self.y-range, self.w+range*2, self.y+range*2)
    for _ = 1, len do
      local col = items[_]
      local alpha = distance(self.x, self.y, col.x, col.y)/range
      love.graphics.setColor(1, 1, 1, 1-alpha)
      love.graphics.rectangle('fill', col.x, col.y, col.w, col.h)
    end
end

function entity:draw()
    -- draws the blocks in the player's reach area
    if map:getMode() == 1 then drawLight(self, lightRange) end
    
    -- draw the entity
		love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle('line', self.x, self.y, self.w, self.h)
		-- love.graphics.draw(self.spr, self.x + self.w/2, self.y + self.h/2, self.angle, self.dir, 1, self.w/2, self.h/2)
end

---------------------------------------------------------------------------

return entity