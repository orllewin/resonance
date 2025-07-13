import "CoreLibs/sprites"
import "CoreLibs/graphics"

local gfx <const> = playdate.graphics
local focusIndicator = gfx.image.new("images/focus_indicator")

class('OscillatorConfig').extends()

function OscillatorConfig:init()
		OscillatorConfig.super.init(self)	
		
		local layerImage = gfx.image.new(400, 240, gfx.kColorClear)
		gfx.pushContext(layerImage)
			local black = gfx.image.new(400, 240, gfx.kColorWhite)
			black:drawFaded(0, 0, 0.75, gfx.image.kDitherTypeDiagonalLine)
		gfx.popContext()
		self.layerSprite = gfx.sprite.new(layerImage)
		self.layerSprite:moveTo(200, 120)
		
		--focusIndicator:setInverted(true)
		self.arrowSprite = gfx.sprite.new(focusIndicator)
		self.arrowSprite:moveTo(200, 120)

		local label1 = "Point A"
		local originLabelWidth,originLabelHeight = gfx.getTextSizeForMaxWidth(label1, 200)
		local oOWidth = originLabelWidth + 6
		local oOHeight = originLabelHeight + 6 + 6
		local orbitOriginImage = gfx.image.new(oOWidth, oOHeight)
		gfx.pushContext(orbitOriginImage)
			gfx.setColor(gfx.kColorBlack)
			gfx.fillRoundRect(0, 0, originLabelWidth + 6, oOHeight - 6, 5)
			gfx.setImageDrawMode(playdate.graphics.kDrawModeFillWhite)
			gfx.drawText(label1, 3, 4)
		gfx.popContext()
		self.originSprite = gfx.sprite.new(orbitOriginImage)
		self.originSprite:moveTo(200, 120)
		
		local label2 = "Point B"
		local orbitLabelWidth, orbitLabelHeight = gfx.getTextSizeForMaxWidth(label2, 200)
		local orbitSpriteWidth = orbitLabelWidth + 6
		local orbitSpriteHeight = orbitLabelHeight + 6 + 6
		local orbitImage = gfx.image.new(orbitSpriteWidth, orbitSpriteHeight)
		gfx.pushContext(orbitImage)
			gfx.setColor(gfx.kColorBlack)
			gfx.fillRoundRect(0, 0, orbitLabelWidth + 6, orbitSpriteHeight - 6, 5)
			gfx.setImageDrawMode(playdate.graphics.kDrawModeFillWhite)
			gfx.drawText(label2, 3, 4)
		gfx.popContext()
		self.orbitSprite = gfx.sprite.new(orbitImage)
		self.orbitSprite:moveTo(200, 120)
		
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
				self.originX = self.arrowSprite.x
				self.originY = self.arrowSprite.y + 16
				self.isOriginSet = true
				self.orbitSprite:moveTo(200, self.arrowSprite.y)
				self.arrowSprite:moveTo(200, self.arrowSprite.y)
				self.orbitSprite:add()
				self.arrowSprite:add()
				self:redrawLine()
				self.lineSprite:add()
				self:moveBy(0, 0)
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
	
	self:moveBy(0, 0)
	self.layerSprite:add()
	self.originSprite:add()
	self.arrowSprite:add()
	
	playdate.inputHandlers.push(inputHandler)
end

function OscillatorConfig:redrawLine()	
	
	self.orbitX = self.arrowSprite.x
	self.orbitY = self.originY
	
	local length = math.abs(self.originX - self.orbitX)
	if length > 0 then
		local lineHeight = 7
		local lineImage = gfx.image.new(length, lineHeight)
		gfx.pushContext(lineImage)
			gfx.setLineWidth(4)
			gfx.setLineCapStyle(gfx.kLineCapStyleRound)
			gfx.drawLine(10, lineHeight/2, length - 10, lineHeight/2)
		gfx.popContext()
		
		self.lineSprite:setImage(lineImage)
		self.lineSprite:moveTo((self.originX + self.orbitX)/2, self.originY)
	end
end

function OscillatorConfig:moveBy(x, y)
	if not self.isOriginSet then
		self.arrowSprite:moveBy(x, y)
		local originLabelWidth = self.originSprite.width
		local originLabelX = self.arrowSprite.x - (originLabelWidth/2) - 8
		if originLabelX < originLabelWidth/2 then
			originLabelX = self.arrowSprite.x + (originLabelWidth/2) + 8
		end
		self.originSprite:moveTo(originLabelX, self.arrowSprite.y)
	elseif not self.isOrbitSet then
		self.arrowSprite:moveBy(x, 0)
		local orbitLabelWidth = self.orbitSprite.width
		local orbitLabelX = self.arrowSprite.x + (orbitLabelWidth/2) + 8
		if orbitLabelX > 400 - (orbitLabelWidth/2) then
			orbitLabelX = self.arrowSprite.x - (orbitLabelWidth/2) - 8
		end
		self.orbitSprite:moveTo(orbitLabelX, self.arrowSprite.y)
		self:redrawLine()
	end
	
	if self.arrowSprite.x < 0 then 
		self.arrowSprite:moveTo(0, self.arrowSprite.y) 
	elseif self.arrowSprite.x > 400 then 
		self.arrowSprite:moveTo(400, self.arrowSprite.y) 
	end
	if self.arrowSprite.y > 240 then 
		self.arrowSprite:moveTo(self.arrowSprite.x, 240) 
	elseif self.arrowSprite.y < 0 then 
		self.arrowSprite:moveTo(self.arrowSprite.x, 0) 
	end
end

function OscillatorConfig:dismiss()
	self.originSprite:remove()
	self.orbitSprite:remove()
	self.lineSprite:remove()
	self.arrowSprite:remove()
	self.layerSprite:remove()
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