import "CoreLibs/sprites"
import "CoreLibs/graphics"

local gfx <const> = playdate.graphics
local diam = 16

class('ActiveNodeLabel').extends()

function ActiveNodeLabel:init()
		ActiveNodeLabel.super.init(self)
		
		self.text = "--"
		self.supportsAccelerometer = false
		self.isPlayer = false
		
		local accelerometerImage = playdate.graphics.image.new("images/accel")
		assert(accelerometerImage)
		self.accelerometerSprite = playdate.graphics.sprite.new(accelerometerImage)
		self.accelerometerSprite:moveTo(13, 230)
end

function ActiveNodeLabel:updateNode(node)
	self.text = "" .. node.midiNote .. "/" .. midi:label(node.midiNote) .. " "  .. node.waveform .. " " .. math.floor(node.p.x) .. "." .. math.floor(node.p.y)
	
	self.isPlayer = false
	
	if node.waveform == "Phase" or node.waveform == "Digital" or node.waveform == "Vosim" then
		self.accelerometerSprite:add()
		self.supportsAccelerometer = true
	else
		self.accelerometerSprite:remove()
		self.supportsAccelerometer = false
	end
end

function ActiveNodeLabel:updatePlayer(player)
	self.accelerometerSprite:remove()
	self.isPlayer = true
	self.supportsAccelerometer = false
	self.text = "" .. math.floor(player.p.x) .. "." .. math.floor(player.p.y)
end
		