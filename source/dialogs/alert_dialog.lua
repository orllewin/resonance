import "CoreLibs/sprites"
import "CoreLibs/graphics"
import "CoreLibs/ui"
import "views/button"

local gfx <const> = playdate.graphics

class('AlertDialog').extends()

local alertWidth = 200
local alertHeight = 85

function AlertDialog:init()
		AlertDialog.super.init(self)
		self.crankDelta = 0	
end

function AlertDialog:show(title, message, cancelText, confirmText, onDismiss, onConfirm)
	local background = gfx.image.new(alertWidth, alertHeight, gfx.kColorWhite)
	gfx.pushContext(background)
	gfx.setColor(gfx.kColorBlack)
	gfx.drawRoundRect(0, 0, alertWidth, alertHeight, 12) 
	
	gfx.drawText(title, 10, 10)
	gfx.drawLine(5, 24, alertWidth - 10, 24)
	
	--(text, x, y, [width, height], [leadingAdjustment], [wrapMode], [alignment]) 
	gfx.drawText(message, 10, 33, alertWidth - 20, 40, nil, gfx.kWrapWord, gfx.kAlignLeft)

	gfx.popContext()
	
	self.backgroundSprite = gfx.sprite.new(background)
	self.backgroundSprite:moveTo(200, 120)
	self.backgroundSprite:add()
	
	local confirmTextWidth, _ = gfx.getTextSizeForMaxWidth(confirmText, 400)
	local confirmButtonWidth = confirmTextWidth + 10
	
	local buttonY = 145
	if cancelText ~= nil then
		local cancelTextWidth, _ = gfx.getTextSizeForMaxWidth(confirmText, 400)
		local cancelTextButtonWidth = cancelTextWidth + 10
		self.cancelButton = Button(
			cancelText,
			(200 + (alertWidth/2)) - confirmButtonWidth - 20 - (cancelTextButtonWidth/2),--x
			buttonY,--y 
			function()
				--onClick
				self:dismiss()
				onDismiss()
			end
		)
	end
	
	self.confirmButton = Button(
		confirmText,
		(200 + (alertWidth/2))  - 10 - (confirmButtonWidth/2),--x
		buttonY,--y 
		function()
			--onClick
			self:dismiss()
			onConfirm()
		end
	)
	
	self.confirmButton:focus()
	
	self.patchLoadInputHandler = {
		
		BButtonDown = function()
			self:dismiss()
			onDismiss()
		end,
		
		AButtonDown = function()
			if self.confirmButton.focused then
				self.confirmButton:click()
			else
				if self.cancelButton ~= nil and self.cancelButton.focused then
					self.cancelButton:click()
				end
			end
		end,
		
		leftButtonDown = function()
			if self.cancelButton ~= nil then self.cancelButton:focus() end
			self.confirmButton:unfocus()
		end,
		
		rightButtonDown = function()
			if self.cancelButton ~= nil then self.cancelButton:unfocus() end
			self.confirmButton:focus()
		end,
		
		upButtonDown = function()
			if self.textList ~= nil then self.textList:goUp() end
		end,
		
		downButtonDown = function()
			if self.textList ~= nil then self.textList:goDown() end
		end,
		
		cranked = function(change, acceleratedChange)
		end,
	}
	
	playdate.inputHandlers.push(self.patchLoadInputHandler)
end

function AlertDialog:dismiss()
	playdate.inputHandlers.pop()
	self.confirmButton:remove()
	if self.cancelButton ~= nil then
		self.cancelButton:remove()
	end
	self.backgroundSprite:remove()
end