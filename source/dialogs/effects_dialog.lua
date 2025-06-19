import "CoreLibs/sprites"
import "CoreLibs/graphics"
import "CoreLibs/ui"
import "views/encoder"

local gfx <const> = playdate.graphics

class('EffectsDialog').extends()

local effectDialogWidth = 230

function EffectsDialog:init()
		EffectsDialog.super.init(self)
end

function EffectsDialog:show(onDismiss)
	local background = gfx.image.new(effectDialogWidth, 240, gfx.kColorWhite)
	gfx.pushContext(background)
	gfx.setColor(gfx.kColorBlack)
	gfx.drawRoundRect(0, 0, effectDialogWidth, 240, 12) 
	gfx.drawText("Delay", 10, 10)
	gfx.drawLine(5, 24, 400 - 10, 24)
	gfx.drawText("Time", 24, 95)
	gfx.drawText("Feedback", 78, 95)
	gfx.drawText("Volume", 163, 95)
	
	gfx.drawText("Low Pass", 10, 125)
	gfx.drawLine(5, 139, 400 - 10, 139)
	gfx.drawText("Freq.", 22, 210)
	gfx.drawText("Resonance", 78, 210)
	gfx.drawText("Mix", 180, 210)
	
	gfx.popContext()
	
	self.backgroundSprite = gfx.sprite.new(background)
	self.backgroundSprite:moveTo(400 - (effectDialogWidth/2), 120)
	self.backgroundSprite:add()
	
	self.focusedView = nil
	self.focusedRow = 1
	self.focusedColumn = 1
	
	local row1EncoderY = 65
	local delayTimeValue = self:map(gDelayTime, 0.0, gDelayMax, 0.0, 100.0)
	self.delayTimeEncoder = Encoder(400 - (effectDialogWidth) + 40, row1EncoderY, delayTimeValue,
		function(value) 
			--delayTime 0.0 to 100.0
			gDelayMax = self:map(value, 0.0, 100.0, 0.0, gDelayMax)
			print("Delay time: " .. gDelayMax)
			gDelayTap1:setDelay(gDelayMax)
		end
	)
	self.focusedView = self.delayTimeEncoder
	
	self.feedbackEncoder = Encoder(400 - (effectDialogWidth) + 115, row1EncoderY, gDelayFeedback * 100.0, 
		function(value) 
			--delayFeedback 0.0 to 100.0
			gDelayFeedback = value/100.0
			print("Delay feedback: " .. gDelayFeedback)
			gDelay:setFeedback(gDelayFeedback)
		end
	)
	
	self.delayVolumeEncoder = Encoder(400 - (effectDialogWidth) + 190, row1EncoderY, gDelayVolume * 100.0,
		function(value) 
			--delayVolume 0.0 to 100.0
			gDelayVolume = value/100.0
			print("Delay volume: " .. gDelayVolume)
			gDelayTap1:setVolume(gDelayVolume)
		end
	)
	
	local row2EncoderY = 175
	local lowPassFreqValue = self:map(gLowPassFreq, gLowPassFreqMin, gLowPassFreqMax, 0.0, 100.0)
	self.lowPassFreqEncoder = Encoder(400 - (effectDialogWidth) + 40, row2EncoderY, lowPassFreqValue,
		function(value) 
			--delayTime 0.0 to 100.0
			gLowPassFreq = self:map(value, 0.0, 100.0, gLowPassFreqMin, gLowPassFreqMax)
			print("Low pass freq: " .. gLowPassFreq)
			gLowPass:setFrequency(gLowPassFreq)
		end
	)
	
	self.lowPassResonanceEncoder = Encoder(400 - (effectDialogWidth) + 115, row2EncoderY, gLowPassRes * 100.0,
		function(value) 
			--delayTime 0.0 to 100.0
			gLowPassRes= value/100.0
			print("Low pass resonance: " .. gLowPassRes)
			gLowPass:setResonance(gLowPassRes)
		end
	)
	
	self.lowPassMixEncoder = Encoder(400 - (effectDialogWidth) + 190, row2EncoderY, gLowPassMix * 100.0,
		function(value) 
			--delayTime 0.0 to 100.0
			gLowPassMix = value/100.0
			print("Low pass mix: " .. gLowPassMix)
			gLowPass:setMix(gLowPassMix)
		end
	)
	
	self.inputHandler = {
		
		BButtonDown = function()
			self:dismiss()
			onDismiss()
		end,
		
		AButtonDown = function()
			self:dismiss()
			onDismiss()
		end,
		
		leftButtonDown = function()
			if self.focusedRow == 1 then
				self.focusedColumn = math.max(1, self.focusedColumn - 1)
				if self.focusedColumn == 1 then
					self.focusedView:unfocus()
					self.focusedView = self.delayTimeEncoder
					self.focusedView:focus()
				elseif self.focusedColumn == 2 then
					self.focusedView:unfocus()
					self.focusedView = self.feedbackEncoder
					self.focusedView:focus()
				elseif self.focusedColumn == 3 then
					self.focusedView:unfocus()
					self.focusedView = self.delayVolumeEncoder
					self.focusedView:focus()
				end
			elseif self.focusedRow == 2 then
				self.focusedColumn = math.max(1, self.focusedColumn - 1)
				if self.focusedColumn == 1 then
					self.focusedView:unfocus()
					self.focusedView = self.lowPassFreqEncoder
					self.focusedView:focus()
				elseif self.focusedColumn == 2 then
					self.focusedView:unfocus()
					self.focusedView = self.lowPassResonanceEncoder
					self.focusedView:focus()
				elseif self.focusedColumn == 3 then
					self.focusedView:unfocus()
					self.focusedView = self.lowPassMixEncoder
					self.focusedView:focus()
				end
			end
		end,
		
		rightButtonDown = function()
			if self.focusedRow == 1 then
				self.focusedColumn = math.min(3, self.focusedColumn + 1)
				if self.focusedColumn == 1 then
					self.focusedView:unfocus()
					self.focusedView = self.delayTimeEncoder
					self.focusedView:focus()
				elseif self.focusedColumn == 2 then
					self.focusedView:unfocus()
					self.focusedView = self.feedbackEncoder
					self.focusedView:focus()
				elseif self.focusedColumn == 3 then
					self.focusedView:unfocus()
					self.focusedView = self.delayVolumeEncoder
					self.focusedView:focus()
				end
			elseif self.focusedRow == 2 then
				self.focusedColumn = math.min(3, self.focusedColumn + 1)
				if self.focusedColumn == 1 then
					self.focusedView:unfocus()
					self.focusedView = self.lowPassFreqEncoder
					self.focusedView:focus()
				elseif self.focusedColumn == 2 then
					self.focusedView:unfocus()
					self.focusedView = self.lowPassResonanceEncoder
					self.focusedView:focus()
				elseif self.focusedColumn == 3 then
					self.focusedView:unfocus()
					self.focusedView = self.lowPassMixEncoder
					self.focusedView:focus()
				end
			end
		end,
		
		upButtonDown = function()
			self.focusedRow = 1
if self.focusedColumn == 1 then
				self.focusedView:unfocus()
				self.focusedView = self.delayTimeEncoder
				self.focusedView:focus()
			elseif self.focusedColumn == 2 then
				self.focusedView:unfocus()
				self.focusedView = self.feedbackEncoder
				self.focusedView:focus()
			elseif self.focusedColumn == 3 then
				self.focusedView:unfocus()
				self.focusedView = self.delayVolumeEncoder
				self.focusedView:focus()
			end
		end,
		
		downButtonDown = function()
			self.focusedRow = 2
			if self.focusedColumn == 1 then
				self.focusedView:unfocus()
				self.focusedView = self.lowPassFreqEncoder
				self.focusedView:focus()
			elseif self.focusedColumn == 2 then
				self.focusedView:unfocus()
				self.focusedView = self.lowPassResonanceEncoder
				self.focusedView:focus()
			elseif self.focusedColumn == 3 then
				self.focusedView:unfocus()
				self.focusedView = self.lowPassMixEncoder
				self.focusedView:focus()
			end
		end,
		
		cranked = function(change, acceleratedChange)
			self.focusedView:turn(change)
		end,
	}
	
	playdate.inputHandlers.push(self.inputHandler)
	
	self.focusedView:focus()
end

function EffectsDialog:map(value, start1, stop1, start2, stop2)
	return start2 + (stop2 - start2) * ((value - start1) / (stop1 - start1))
end

function EffectsDialog:dismiss()
	playdate.inputHandlers.pop()
	self.backgroundSprite:remove()
	self.delayTimeEncoder:remove()
	self.feedbackEncoder:remove()
	self.delayVolumeEncoder:remove()
	self.lowPassFreqEncoder:remove()
	self.lowPassResonanceEncoder:remove()
	self.lowPassMixEncoder:remove()
end