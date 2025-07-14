local gfx <const> = playdate.graphics

--[[
	Set velocity
]]
class('VelocityDialog').extends()

local dialogWidth = 180
local dialogHeight = 22

local velocityWidth = 173
local velocityHeight = 16

function VelocityDialog:init()
		VelocityDialog.super.init(self)	
		self.crankDelta = 0
end

function VelocityDialog:show(player, onDismiss, onVelocity)
	
	self.onDismiss = onDismiss
	
	local dialogY = 240 - (dialogHeight + 3)

	local background = gfx.image.new(dialogWidth, dialogHeight, playdate.graphics.kColorWhite)
	gfx.pushContext(background)
	gfx.setColor(gfx.kColorBlack)
	gfx.drawRoundRect(0, 0, dialogWidth, dialogHeight, 5) 
	gfx.popContext()
	self.backgroundSprite = gfx.sprite.new(background)
	self.backgroundSprite:moveTo(200, dialogY)
	self.backgroundSprite:add()
	
	self.velocity = player.velocity
	self.velocitySprite = gfx.sprite.new()
	self.velocitySprite:moveTo(200, dialogY)
	self.velocitySprite:add()
	self:drawVelocity()
	
	local inputHandler = {
		
		BButtonDown = function()
			self:dismiss()
		end,
		
		AButtonDown = function()
			self:dismiss()
		end,
		
		leftButtonDown = function()
		end,
		
		rightButtonDown = function()
		end,
		
		upButtonDown = function()
		end,
		
		downButtonDown = function()
		end,
		
		cranked = function(change, acceleratedChange)
			if change > 0 then
				self.velocity = math.min(self.velocity + 2.0, maxVelocity)
				self:drawVelocity()
				onVelocity(self.velocity)
			elseif change < 0 then
				self.velocity = math.max(self.velocity - 2.0, 0.25)
				self:drawVelocity()
				onVelocity(self.velocity)
			end
		end,
	}
	playdate.inputHandlers.push(inputHandler)
end

function VelocityDialog:drawVelocity()
	local velocityImage = gfx.image.new(velocityWidth, velocityHeight, playdate.graphics.kColorWhite)
	gfx.pushContext(velocityImage)
	gfx.setColor(gfx.kColorBlack)
	gfx.fillRoundRect(0, 0, self:map(self.velocity, 1, maxVelocity, 1, velocityWidth), velocityHeight, 3) 
	gfx.popContext()
	self.velocitySprite:setImage(velocityImage)
end

function VelocityDialog:map(value, start1, stop1, start2, stop2)
	return start2 + (stop2 - start2) * ((value - start1) / (stop1 - start1))
end

function VelocityDialog:dismiss()
	playdate.inputHandlers.pop()
	self.backgroundSprite:remove()
	self.velocitySprite:remove()
end