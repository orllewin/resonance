import "CoreLibs/sprites"
import "CoreLibs/graphics"
import "CoreLibs/ui"
import "views/encoder"

local gfx <const> = playdate.graphics

class('EffectsDialog').extends()

function EffectsDialog:init()
		EffectsDialog.super.init(self)
end

function EffectsDialog:show(onDismiss)
	local background = gfx.image.new(400, 240, gfx.kColorWhite)
	gfx.pushContext(background)
	gfx.setColor(gfx.kColorBlack)
	gfx.drawRoundRect(0, 0, 400, 240, 12) 
	gfx.drawText("Delay", 10, 10)
	gfx.drawText("Time", 24, 88)
	gfx.drawText("Feedback", 78, 88)
	gfx.drawLine(5, 24, 400 - 10, 24)
	gfx.popContext()
	
	self.backgroundSprite = gfx.sprite.new(background)
	self.backgroundSprite:moveTo(200, 120)
	self.backgroundSprite:add()
	
	self.focusedView = nil
	self.focusedRow = 1
	
	self.delayTimeEncoder = Encoder(40, 60, 
		function(value) 
			--delayTime
		end
	)
	self.delayTimeEncoder:focus()
	self.focusedView = self.delayTimeEncoder
	
	self.feedbackEncoder = Encoder(115, 60, 
		function(value) 
			--delayFeedback
		end
	)
	
	self.inputHandler = {
		
		BButtonDown = function()
			self:dismiss()
			onDismiss()
		end,
		
		AButtonDown = function()
			self.confirmButton:click()
		end,
		
		leftButtonDown = function()
			if self.focusedRow == 1 then
				if self.feedbackEncoder.focused then
					self.feedbackEncoder:unfocus()
					self.delayTimeEncoder:focus()
					self.focusedView = self.delayTimeEncoder
				end
			end
		end,
		
		rightButtonDown = function()
			if self.focusedRow == 1 then
				if self.delayTimeEncoder.focused then
					self.delayTimeEncoder:unfocus()
					self.feedbackEncoder:focus()
					self.focusedView = self.feedbackEncoder
				end
			end
		end,
		
		upButtonDown = function()
		end,
		
		downButtonDown = function()
		end,
		
		cranked = function(change, acceleratedChange)
			self.focusedView:turn(change)
		end,
	}
	
	playdate.inputHandlers.push(self.inputHandler)
end

function EffectsDialog:dismiss()
	playdate.inputHandlers.pop()
	self.backgroundSprite:remove()
	self.delayTimeEncoder:remove()
	self.feedbackEncoder:remove()
end