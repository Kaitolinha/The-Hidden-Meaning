local hud = {}

---------------------------------------------------------------------------
-- load hud

function hud:load()
    -- fast function to create a new button
    local function createButton(id, x, y, sz, style)
      local button = require('THM/SRC/UI/buttons')
      local windowWidth, windowHeight = love.graphics.getDimensions()
      return button.new(id, x*windowWidth, y*windowHeight, sz*windowWidth, style)
    end
    
    -- buttons styles
    local styleButtons = {}
    styleButtons[1] = {1, 1, 1, 0.5}
    styleButtons[2] = {1, 1, 1, 0.3}
    
    -- all hud buttons
    self.buttons = {}
    self.buttons.left = createButton('left', 0.1, 0.9, 0.04, styleButtons)
    self.buttons.right = createButton('right', 0.2, 0.9, 0.04, styleButtons)
    self.buttons.mode = createButton('mode', 0.75, 0.9, 0.04, styleButtons)
    self.buttons.jump = createButton('jump', 0.85, 0.9, 0.04, styleButtons)
end

---------------------------------------------------------------------------
-- update hud

function hud:update(t)
    for _, button in pairs(self.buttons) do
      button:update(t)
    end 
    
    -- keybord 
    if love.keyboard.isDown('left') then self.buttons.left:enable() end
    if love.keyboard.isDown('right') then self.buttons.right:enable() end
    if love.keyboard.isDown('e') then self.buttons.mode:enable() end
    if love.keyboard.isDown('space') then self.buttons.jump:enable() end
end

---------------------------------------------------------------------------
-- draw hud

function hud:draw()
    for _, button in pairs(self.buttons) do
      button:draw()
    end 
end

---------------------------------------------------------------------------

-- returns if the button is being pressed
function hud:down(id)
		return self.buttons[id].down
end

-- returns if button is pressed
function hud:pressed(id)
    local button = self.buttons[id]
		return button.down and not button.last
end

-- returns if the button stops being pressed
function hud:released(id)
    local button = self.buttons[id]
		return not button.down and button.last
end

---------------------------------------------------------------------------

return hud