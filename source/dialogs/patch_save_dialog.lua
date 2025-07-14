local gfx <const> = playdate.graphics

class('PatchSaveDialog').extends()

function PatchSaveDialog:init()
		PatchSaveDialog.super.init(self)		
		self.backgroundSprite = gfx.sprite.new()
		self.textSprite = gfx.sprite.new()
		self.availableWidth = 400
end

function PatchSaveDialog:show()
	local dialogWidth = playdate.keyboard.left()	
	self.availableWidth = dialogWidth
	local image = gfx.image.new(dialogWidth, 240)
	gfx.pushContext(image)
	gfx.setColor(gfx.kColorWhite)
	gfx.fillRect(0, 0, dialogWidth, 240)
	gfx.setColor(gfx.kColorBlack)
	gfx.drawText("Patch name:::", 10, 10)
	gfx.popContext()
	self.backgroundSprite:setImage(image)
	self.backgroundSprite:moveTo(self.availableWidth/2, 120)
	self.backgroundSprite:add()
	
	self.textSprite:moveTo(self.availableWidth/2, 120)
	self.textSprite:add()
end

function PatchSaveDialog:setText(text)
	local textImage = gfx.imageWithText(text .. ".res", self.availableWidth, 240)
	self.textSprite:setImage(textImage)
end

function PatchSaveDialog:dismiss()
	self.backgroundSprite:remove()
	self.textSprite:remove()
end

function PatchSaveDialog:hide()
	self.backgroundSprite:remove()
	self.textSprite:remove()
end