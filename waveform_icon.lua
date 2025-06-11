import "CoreLibs/sprites"
import "CoreLibs/graphics"

local gfx <const> = playdate.graphics

class('WaveformIcon').extends()

function WaveformIcon:init()
		WaveformIcon.super.init(self)
		
		local accelImage = playdate.graphics.image.new("images/accel")
		self.accelSprite = gfx.sprite.new(accelImage)
		self.accelSprite:moveTo(self.accelSprite.width, 240 - 16)
		
		
		self.sineImage = playdate.graphics.image.new("images/sine_icon")
		self.sawImage = playdate.graphics.image.new("images/saw_icon")
		self.squareImage = playdate.graphics.image.new("images/square_icon")
		self.triangleImage = playdate.graphics.image.new("images/triangle_icon")
		self.phaseImage = playdate.graphics.image.new("images/po_1")
		self.digitalImage = playdate.graphics.image.new("images/po_2")
		self.vosimImage = playdate.graphics.image.new("images/po_3")
		
		self.sprite = gfx.sprite.new(self.sineImage)
		self.sprite:moveTo(400 - self.sprite.width, 240 - 16)
		self.sprite:add()
		
end

function WaveformIcon:setWaveform(waveform)
	if waveform == "Sine" then
		self.sprite:setImage(self.sineImage)
		self.accelSprite:remove()
	elseif waveform == "Square" then
		self.sprite:setImage(self.squareImage)
		self.accelSprite:remove()
	elseif waveform == "Triangle" then
		self.sprite:setImage(self.triangleImage)
		self.accelSprite:remove()
	elseif waveform == "Sawtooth" then
		self.sprite:setImage(self.sawImage)
		self.accelSprite:remove()
	elseif waveform == "Phase" then
		self.sprite:setImage(self.phaseImage)
		self.accelSprite:add()
	elseif waveform == "Digital" then
		self.sprite:setImage(self.digitalImage)
		self.accelSprite:add()
	elseif waveform == "Vosim" then
		self.sprite:setImage(self.vosimImage)
		self.accelSprite:add()
	end
	self.sprite:moveTo(400 - self.sprite.width, 240 - 16)
	
end