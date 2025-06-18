import "CoreLibs/sprites"
import "CoreLibs/graphics"
import "CoreLibs/ui"

local gfx <const> = playdate.graphics

class('Button').extends()

function Button:init(text, x, y, onClick)
		Button.super.init(self)
		
		self.text = text
		self.x = x
		self.y = y
		self.onClick = onClick
		
		local textWidth, textHeight = gfx.getTextSizeForMaxWidth(text, 400)
		local buttonWidth = textWidth + 15
		local buttonHeight = textHeight + 12
		
		local unfocusedImage = gfx.image.new(buttonWidth, buttonHeight, gfx.kColorWhite)
		gfx.pushContext(unfocusedImage)
		gfx.setColor(gfx.kColorBlack)
		gfx.drawRoundRect(1, 1, buttonWidth-1, buttonHeight-1, 5) 
		gfx.drawText(text, 8, 7)
		gfx.popContext()
		self.unfocusedImage = unfocusedImage
		
		local focusedImage = gfx.image.new(buttonWidth, buttonHeight, gfx.kColorWhite)
		gfx.pushContext(focusedImage)
		gfx.setColor(gfx.kColorBlack)
		gfx.setLineWidth(2)
		gfx.drawRoundRect(2, 2, buttonWidth - 3, buttonHeight - 3, 5) 
		gfx.drawText(text, 8, 7)
		gfx.popContext()
		self.focusedImage = focusedImage
		
		self.sprite = gfx.sprite.new(unfocusedImage)
		self.sprite:moveTo(x, y)
		self.sprite:add()
		
		self.focused = false
		
		print("x: " .. x .. " y: " .. y)
end

function Button:focus()
	self.focused = true
	self.sprite:setImage(self.focusedImage)
end

function Button:unfocus()
	self.focused = false
	self.sprite:setImage(self.unfocusedImage)
end

function Button:click()
	--todo - how about a little animation?
	self.onClick()
end

function Button:remove()
	self.sprite:remove()
end