local gfx <const> = playdate.graphics

class('PatchName').extends()

function PatchName:init()
		PatchName.super.init(self)
		
		self.label = gfx.sprite.spriteWithText("--", 400, 24)
		self.label:moveTo(self.label.width/2 + 5, 10)
		self.label:add()
end

function PatchName:update(text)
	local image = gfx.imageWithText(text, 400, 24)
	self.label:setImage(image)
	self.label:moveTo(image.width/2 + 5, 10)
end