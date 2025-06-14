import "CoreLibs/sprites"
import "CoreLibs/graphics"

local gfx <const> = playdate.graphics
local focusIndicator = gfx.image.new("images/focus_indicator")

class('OrbitConfig').extends()

function OrbitConfig:init()
		OrbitConfig.super.init(self)	

		local labelWidth,labelHeight = gfx.getTextSizeForMaxWidth("Orbit origin", 200, nil, resFont)
		local oOWidth = labelWidth + 6 + 16
		local oOHeight = labelHeight + 6 + 6
		local orbitOriginImage = gfx.image.new(oOWidth, oOHeight)
		gfx.pushContext(orbitOriginImage)
			gfx.setColor(gfx.kColorBlack)
			gfx.fillRoundRect(0, 0, labelWidth + 6, oOHeight - 6, 5)
			
			gfx.setFont(resFont)
			gfx.setImageDrawMode(playdate.graphics.kDrawModeFillWhite)
			
			gfx.drawText("Orbit origin", 3, 4)
			gfx.setImageDrawMode(playdate.graphics.kDrawModeFillBlack)
			focusIndicator:draw(labelWidth + 6, 5)
		gfx.popContext()
		self.orbitOriginSprite = gfx.sprite.new(orbitOriginImage)
		self.orbitOriginSprite:moveTo(200, 120)
		
		self.showing = false
		
end

function OrbitConfig:show()
	
	self.leftDown = false
	self.rightDown = false
	self.upDown = false
	self.downDown = false
	
	self.showing = true
	
	local inputHandler = {
		AButtonDown = function()
			playdate.inputHandlers.pop()
		end,
		
		AButtonUp = function()
		end,
		
		BButtonDown = function()
			playdate.inputHandlers.pop()
		end,
		
		BButtonUp = function()
		end,
		

		leftButtonDown = function()
			self.leftDown = true
		end,
		leftButtonUp = function()
			self.leftDown = false
		end,
		
		rightButtonDown = function()
			self.rightDown = true
		end,
		rightButtonUp = function()
			self.rightDown = false
		end,
		
		upButtonDown = function()
			self.upDown = true
		end,
		upButtonUp = function()
			self.upDown = false
		end,
		
		downButtonDown = function()
			self.downDown = true
		end,
		downButtonUp = function()
			self.downDown = false
		end
	}
	
	self.orbitOriginSprite:add()
	
	playdate.inputHandlers.push(inputHandler)
end

function OrbitConfig:moveBy(x, y)
	self.orbitOriginSprite:moveBy(x, y)
end

function OrbitConfig:checkKeys()
	if self.leftDown then
		self:moveBy(-2, 0)
	end
	if self.rightDown then
		self:moveBy(2, 0)
	end
	if self.upDown then
		self:moveBy(0, -2)
	end
	if self.downDown then
		self:moveBy(0, 2)
	end
end