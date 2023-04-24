local entity = require('THM/SRC/ENTITIES/entity')
local player = {}
player.__index = player
setmetatable(player, entity)

---------------------------------------------------------------------------
-- create the player class

function player.new(name, spr, x, y, w, h, speed)
		local self = entity.new('player', name, spr, x, y, w, h, speed)
		setmetatable(self, player)
		
		self.lastX = self.x
		self.lastY = self.y
		
		return self
end

---------------------------------------------------------------------------
-- player movement system

local jumpForce = -12
local gravityForce = 0.6

local function updateMove(self, t)
    -- movement in x
		local leftMove, rightMove = 0, 0
		if hud:down('left') then leftMove = -1 end
		if hud:down('right') then rightMove = 1 end
		local movement = leftMove + rightMove
    
		self.vx = lerp(self.vx, movement * self.speed, 0.2 * t)
    
    -- movement in y
    self.vy = self.vy + gravityForce
    
    -- movement system
		self:move(self.vx, self.vy, t) 
		
		-- jump system
		if hud:pressed('jump') then self:jump(jumpForce) end
		
		-- direction system
    if movement ~= 0 then self.dir = movement end
end

function player:jump(force)
    -- player jump
    if self.vy == 0 then self.vy = force end
end

---------------------------------------------------------------------------
-- player change mode system

local function changeMode(self, t)
    -- change map mode
    map:changeMode()
    
    -- checks if the player is inside the map
    local goalX = self.x + self.vx * t
    local goalY = self.y + self.vy * t
    local _, _, cols, len = world:check(self, goalX, goalY)
    
    for _ = 1, len do
      local col = cols[_]
      if col.normal.x ~= 0 then
        self:setPosition(self.lastX, self.lastY)
      end
    end
    
    -- saves the last position
    self.lastX, self.lastY = self.x, self.y
end

local function updateMode(self, t)
    -- change map mode
    if hud:pressed('mode') then changeMode(self, t) end
end

---------------------------------------------------------------------------
-- player update

function player:update(t)
    updateMove(self, t)
    updateMode(self, t)
end

---------------------------------------------------------------------------

return player