import "CoreLibs/sprites"
import "CoreLibs/graphics"

local gfx <const> = playdate.graphics
local diam = 16

class('ActiveNodeLabel').extends()

function ActiveNodeLabel:init()
		ActiveNodeLabel.super.init(self)
		
		self.text = "--"
end

function ActiveNodeLabel:updateNode(node)
	self.text = "" .. node.midiNote .. "/" .. midi:label(node.midiNote) .. " "  .. node.waveform .. " " .. math.floor(node.p.x) .. "." .. math.floor(node.p.y)
end

function ActiveNodeLabel:updatePlayer(player)
	self.text = player
end
		