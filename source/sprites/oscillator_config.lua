import "CoreLibs/sprites"
import "CoreLibs/graphics"

local gfx <const> = playdate.graphics
local focusIndicator = gfx.image.new("images/focus_indicator")

class('OscillatorConfig').extends()

function OscillatorConfig:init()
		OscillatorConfig.super.init(self)	

		local label1 = "Point A"
		local originLabelWidth,originLabelHeight = gfx.getTextSizeForMaxWidth(label1, 200)
		local oOWidth = originLabelWidth + 6 + 16
		local oOHeight = originLabelHeight + 6 + 6
		local orbitOriginImage = gfx.image.new(oOWidth, oOHeight)
		gfx.pushContext(orbitOriginImage)
			gfx.setColor(gfx.kColorBlack)
			gfx.fillRoundRect(0, 0, originLabelWidth + 6, oOHeight - 6, 5)
			
			gfx.setImageDrawMode(playdate.graphics.kDrawModeFillWhite)
			
			gfx.drawText(label1, 3, 4)
			gfx.setImageDrawMode(playdate.graphics.kDrawModeFillBlack)
			focusIndicator:draw(originLabelWidth + 6, 5)
		gfx.popContext()
		self.originSprite = gfx.sprite.new(orbitOriginImage)
		self.originSprite:moveTo(200, 120)
		self.orbitOriginLeftBound = -((self.originSprite.width/2) - 16)
		self.orbitOriginRightBound = 400 - (self.originSprite.width/2)
		self.orbitOriginTopBound = oOHeight/2 - 16
		self.orbigOriginBottomBound = 240 - 16
		
		local label2 = "Point B"
		local orbitLabelWidth,orbitLabelHeight = gfx.getTextSizeForMaxWidth(label2, 200)
		local orbitSpriteWidth = orbitLabelWidth + 6 + 16
		local orbitSpriteHeight = orbitLabelHeight + 6 + 6
		local orbitImage = gfx.image.new(orbitSpriteWidth, orbitSpriteHeight)
		gfx.pushContext(orbitImage)
			gfx.setColor(gfx.kColorBlack)
			gfx.fillRoundRect(16, 0, orbitLabelWidth + 6, orbitSpriteHeight - 6, 5)
			
			gfx.setImageDrawMode(playdate.graphics.kDrawModeFillWhite)
			
			gfx.drawText(label2, 19, 4)
			
			gfx.setImageDrawMode(playdate.graphics.kDrawModeFillBlack)
			focusIndicator:draw(0, 5)
		gfx.popContext()
		self.orbitSprite = gfx.sprite.new(orbitImage)
		self.orbitSprite:moveTo(210, 120)
		self.orbitLeftBound = -((self.orbitSprite.width/2) - 16)
		self.orbitRightBound = 400 + self.orbitSprite.width/2
		self.orbitTopBound = orbitSpriteHeight/2 - 16
		self.orbitBottomBound = 240 - 16
		
		self.lineSprite = gfx.sprite.new()
		self.lineSprite:moveTo(200, 120)
		
		
		self.showing = false
end

function OscillatorConfig:show(onCancel, onSetOrbit)
	
	self.leftDown = false
	self.rightDown = false
	self.upDown = false
	self.downDown = false
	
	self.showing = true
	
	self.isOriginSet = false
	self.isOrbitSet = false
	
	self.originX = 200
	self.originY = 120
	
	self.orbitX = 300
	self.orbitY = 120
	
	local inputHandler = {
		AButtonDown = function()
			if not self.isOriginSet then
				self.originX = self.originSprite.x + (self.originSprite.width/2)
				self.originY = self.originSprite.y + 16
				self.isOriginSet = true
				self.orbitSprite:moveTo(self.originSprite.x + (self.originSprite.width/2) + 25, self.originSprite.y)
				self.orbitSprite:add()
				self:redrawLine()
				self.lineSprite:add()
			elseif not self.isOrbitSet then				
				self:dismiss()
				onSetOrbit(self.originX, self.originY, self.orbitX, self.orbitY)
			end
		end,
		
		AButtonUp = function()
		end,
		
		BButtonDown = function()
			--cancel
			self:dismiss()
			onCancel()
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
	
	self.originSprite:add()
	
	playdate.inputHandlers.push(inputHandler)
end

function OscillatorConfig:redrawLine()	
	self.originX = self.originSprite.x + (self.originSprite.width/2) - 8
	self.originY = self.originSprite.y + 9
	self.orbitX = self.orbitSprite.x - (self.orbitSprite.width/2) + 8
	self.orbitY = self.originY
	
	local length = math.abs(self.originX - self.orbitX)
	local lineHeight = 7
	local lineImage = gfx.image.new(length, lineHeight)
	gfx.pushContext(lineImage)
		gfx.setLineWidth(4)
		gfx.setLineCapStyle(gfx.kLineCapStyleRound)
		gfx.drawLine(8, lineHeight/2, length - 8, lineHeight/2)
	gfx.popContext()
	
	self.lineSprite:setImage(lineImage)
	self.lineSprite:moveTo((self.originX + self.orbitX)/2, self.originY)
end

function OscillatorConfig:moveBy(x, y)
	if not self.isOriginSet then
		self.originSprite:moveBy(x, y)

		if self.originSprite.x < self.orbitOriginLeftBound then
			self.originSprite:moveTo(self.orbitOriginLeftBound, self.originSprite.y)
		elseif self.originSprite.x > self.orbitOriginRightBound then
			self.originSprite:moveTo(self.orbitOriginRightBound, self.originSprite.y)
		end
		
		if self.originSprite.y < self.orbitOriginTopBound then
			self.originSprite:moveTo(self.originSprite.x, self.orbitOriginTopBound)
		elseif self.originSprite.y > self.orbigOriginBottomBound then
			self.originSprite:moveTo(self.originSprite.x, self.orbigOriginBottomBound)
		end
	elseif not self.isOrbitSet then
		self.orbitSprite:moveBy(x, 0)--no vertical movement for orbit sprite
		
		if self.orbitSprite.x < self.orbitLeftBound then
			self.orbitSprite:moveTo(self.orbitLeftBound, self.orbitSprite.y)
		elseif self.orbitSprite.x > self.orbitRightBound then
			self.orbitSprite:moveTo(self.orbitRightBound, self.orbitSprite.y)
		end
		
		if self.orbitSprite.y < self.orbitTopBound then
			self.orbitSprite:moveTo(self.orbitSprite.x, self.orbitTopBound)
		elseif self.orbitSprite.y > self.orbitBottomBound then
			self.orbitSprite:moveTo(self.orbitSprite.x, self.orbitBottomBound)
		end
		self:redrawLine()
	end
end

function OscillatorConfig:dismiss()
	self.originSprite:remove()
	self.orbitSprite:remove()
	self.lineSprite:remove()
	self.showing = false
	playdate.inputHandlers.pop()
end

function OscillatorConfig:checkKeys()
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