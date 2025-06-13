import "CoreLibs/sprites"
import "CoreLibs/graphics"

local gfx <const> = playdate.graphics
local diam = 16

class('ActiveNodeLabel').extends()

function ActiveNodeLabel:init()
		ActiveNodeLabel.super.init(self)
		
		self.sprite = gfx.sprite.spriteWithText("--", 400, 20)
		self.sprite:moveTo(self.sprite.width/2 + 5, 240 - (self.sprite.height/2))
		self.sprite:add()
		
end

function ActiveNodeLabel:updateNode(node)
	local image = gfx.imageWithText("NODE", 400, 20)
	self.sprite:setImage(image)
	self.sprite:moveTo(self.sprite.width/2 + 5, 240 - (self.sprite.height/2))
end

function ActiveNodeLabel:updatePlayer(player)
	local image = gfx.imageWithText("PLAYER", 400, 20)
	self.sprite:setImage(image)
	self.sprite:moveTo(self.sprite.width/2 + 5, 240 - (self.sprite.height/2))
end
		