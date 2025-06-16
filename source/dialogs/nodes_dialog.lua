import "CoreLibs/sprites"
import "CoreLibs/graphics"
import "CoreLibs/ui"

import 'text_list'
import "dialogs/waveform_dialog"

local gfx <const> = playdate.graphics

--[[
	
	Various node helpers
	
]]
class('NodesDialog').extends()

local menuOptionAddNoteNode = "New note node"
local menuOptionAddPlayerNode = "New player node"
local menuOptionSetWaveform = "Set waveform"
local menuOptionOctaveUp = "Octave up"
local menuOptionOctaveDown = "Octave down"
local menuOptionRndPositions = "Randomise positions"
local menuOptionRndPositions = "Randomise positions"
local menuOptionRndNotes = "Randomise notes"

local menuItems = {
	{label = "Nodes:::", type = "category_title"},
	{label = menuOptionAddNoteNode},
	{label = menuOptionAddPlayerNode},
	{type = "divider"},
	{label = "Global:::", type = "category_title"},
	{label = menuOptionSetWaveform},
	{label = menuOptionOctaveUp},
	{label = menuOptionOctaveDown},
	{label = menuOptionRndPositions},
	{label = menuOptionRndNotes},
}

function NodesDialog:init()
		NodesDialog.super.init(self)	
		self.crankDelta = 0
end

function NodesDialog:show(
	onDismiss,
	onAddPlayerNode, 
	onRandomisePositions, 
	onRandomiseNotes,
	onWaveform,
	onAddNoteNode,
	onOctaveUp,
	onOctaveDown
)
	
	self.onDismiss = onDismiss

	local background = gfx.image.new(gDialogWidth, gDialogHeight, playdate.graphics.kColorWhite)
	gfx.pushContext(background)
	gfx.setColor(gfx.kColorBlack)
	gfx.drawRoundRect(0, 0, gDialogWidth, gDialogHeight, 12) 
	gfx.popContext()
	self.backgroundSprite = gfx.sprite.new(background)
	self.backgroundSprite:moveTo(400 - (gDialogWidth/2), 120)
	self.backgroundSprite:add()

	self.menuList = TextList(menuItems, 400 - (gDialogWidth - 10), 120 - (gDialogHeight/2) + 10, gDialogWidth - 20, gDialogHeight  - 10, 20, nil, function(index, item)
		if item.label == menuOptionAddPlayerNode then
			self:dismiss()
			onAddPlayerNode()
		elseif item.label == menuOptionSetWaveform then
			self:dismiss()
			self:showWaveformDialog(onWaveform)
		elseif item.label == menuOptionOctaveUp then
			self:dismiss()
			onOctaveUp()
		elseif item.label == menuOptionOctaveDown then
			self:dismiss()
			onOctaveDown()
		elseif item.label == menuOptionAddNoteNode then
			self:dismiss()
			onAddNoteNode()
		elseif item.label == menuOptionRndPositions then
			self:dismiss()
			onRandomisePositions()
		elseif item.label == menuOptionRndNotes then
			self:dismiss()
			onRandomiseNotes()
		end
	end, 29000)
	
	self.menuInputHandler = {
		
		BButtonDown = function()
			self:dismiss()
			self.onDismiss()
		end,
		
		AButtonDown = function()
			self.menuList:tapA()
		end,
		
		leftButtonDown = function()
	
		end,
		
		rightButtonDown = function()
	
		end,
		
		upButtonDown = function()
			self.menuList:goUp()
		end,
		
		downButtonDown = function()
			self.menuList:goDown()
		end,
		
		cranked = function(change, acceleratedChange)
			self.crankDelta += change
			if self.crankDelta < -20 then
				self.crankDelta = 0.0
				self.menuList:goUp()
			elseif self.crankDelta > 20 then
				self.crankDelta = 0.0
				self.menuList:goDown()
			end
		end,
	}
	playdate.inputHandlers.push(self.menuInputHandler)
end

function NodesDialog:showWaveformDialog(onWaveform)
	WaveformDialog():show(
		"Select waveform:::", 
		function() 
			--onDismiss
		end,
		function(waveform)
			--onWaveform
			onWaveform(waveform)
		end
	)
end

function NodesDialog:dismiss()
	playdate.inputHandlers.pop()
	self.menuList:removeAll()
	self.backgroundSprite:remove()
end