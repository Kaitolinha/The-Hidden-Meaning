local map = {}

---------------------------------------------------------------------------
-- map load

local tileSize = 32
function map:load()
    self.mode = 0 
    self.tile = {}
    local tiledMap = {
      {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
      {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
      {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
      {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
      {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
      {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
      {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
      {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
      {1,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,1},
      {1,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,1},
      {1,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,1},
      {1,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,1},
      {1,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,1},
      {1,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,1},
      {1,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,1},
      {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}
    }
    
    
    local tileColors = {
      {1, 1, 1, 1},
      {1, 1, 1, 0},
      {1, 1, 1, 1},
      {1, 0, 0, 1}
    }
    
    local ox, oy = 0, 0
    for i = 1, #tiledMap do
      for j = 1, #tiledMap[i] do
        local tileType = tiledMap[i][j]
        if tileType ~= 0 then 
          local x = ox + (j - 1) * tileSize
          local y = oy + (i - 1) * tileSize
          local tile = {type = tileType, x = x, y = y, w = tileSize, h = tileSize, color = tileColors[tileType]}
          world:add(tile, x, y, tileSize, tileSize)
          
          local function insertTile(tileMap)
            tileMap[#tileMap+1] = tile
          end
          insertTile(self.tile)
        end
      end
    end
end

--[[

map modes:
    0 = visible
    1 = hidden

tile types:
    0 = air
    1 = normal tile
    2 = hidden tile
    3 = visible tile
    4 = spike

tile = {

]]

---------------------------------------------------------------------------
-- map update
 
function map:update(t)

end

---------------------------------------------------------------------------
-- map draw

local function drawTileMap(tileMap, tileSize)
    for _ = 1, #tileMap do
      local tile = tileMap[_]
      local tileType = tile.type
      
      -- draw tiles
      love.graphics.setColor(tile.color)
      love.graphics.rectangle('line', tile.x, tile.y, tileSize, tileSize)
      -- love.graphics.printf(_, tile.x, tile.y + tile.h/3, tile.w, 'center')
    end
end

local backgroundColors = {
  {0, 0, 0, 1},
  {0.5, 0, 0, 1}
}

function map:draw()
    -- change the background color
    love.graphics.setBackgroundColor(backgroundColors[self.mode+1])
    
    if self.mode == 0 or love.keyboard.isDown('f1') then
      drawTileMap(self.tile, tileSize)
    end
end

---------------------------------------------------------------------------

-- change map mode
function map:changeMode()
    local state = self.mode
    
    -- change map mode
    if state < 1 then state = state + 1 else state = 0 end
    
    -- add tile when map mode changes
    local function addTile(tile)
      if not world:hasItem(tile) then world:add(tile, tile.x, tile.y, tileSize, tileSize) end
    end
    
    -- remove tile when map mode changes
    local function removeTile(tile)
      world:remove(tile)  
    end
    
    for _ = 1, #self.tile do
      local tile = self.tile[_]
      if tile.type == 2 then
        if state == 0 then removeTile(tile) else addTile(tile) end
      elseif tile.type == 3 then
        if state == 0 then addTile(tile) else removeTile(tile) end
      end
    end
    
    self.mode = state
end

function map:getMode()
    return self.mode
 end

---------------------------------------------------------------------------

return map