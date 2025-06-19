import "CoreLibs/sprites"
import "CoreLibs/graphics"
import "CoreLibs/ui"

local gfx <const> = playdate.graphics

class('Encoder').extends()

local encoderDiam = 50

local focusImage = gfx.image.new(encoderDiam, encoderDiam)
gfx.pushContext(focusImage)
gfx.setColor(gfx.kColorBlack)
gfx.setLineWidth(4)
gfx.drawCircleAtPoint(encoderDiam/2, encoderDiam/2, encoderDiam/2 - 2)
gfx.drawLine(encoderDiam/2, encoderDiam/2, 11, encoderDiam - 11)
gfx.popContext()

local unfocusImage = gfx.image.new(encoderDiam, encoderDiam)
gfx.pushContext(unfocusImage)
gfx.setColor(gfx.kColorBlack)
gfx.drawCircleAtPoint(encoderDiam/2, encoderDiam/2, encoderDiam/2 - 2)
gfx.drawLine(encoderDiam/2, encoderDiam/2, 7, encoderDiam - 7)
gfx.popContext()

function Encoder:init(x, y, value, onChange)
		Encoder.super.init(self)
		self.onChange = onChange
		self.value = value
		self.focused = false
		
		self.sprite = gfx.sprite.new()
		self.sprite:moveTo(x, y)
		self.sprite:setImage(unfocusImage)
		self.sprite:add()
		
		self:redraw()
end

function Encoder:focus()
	self.sprite:setImage(focusImage)
	self.focused = true
end

function Encoder:unfocus()
	self.sprite:setImage(unfocusImage)
	self.focused = false
end

function Encoder:map(value, start1, stop1, start2, stop2)
	return start2 + (stop2 - start2) * ((value - start1) / (stop1 - start1))
end

function Encoder:redraw()
	local rotation = self:map(self.value, 0.0, 100.0, 0.0, 271.5)
	self.sprite:setRotation(rotation)
end

function Encoder:turn(change)
	if not self.focused then
		return
	end
	self.value += change
	if self.value <  0 then
		self.value = 0
	elseif self.value > 100 then
		self.value = 100
	end
	
	self:redraw()
	self.onChange(self.value)
end

function Encoder:remove()
	self.sprite:remove()
end