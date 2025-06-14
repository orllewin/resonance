import "CoreLibs/sprites"
import "CoreLibs/graphics"
import "CoreLibs/ui"

import 'text_list'
import "dialogs/waveform_dialog"

local gfx <const> = playdate.graphics

--[[
	
	Various code helpers
	
]]
class('NodesDialog').extends()

local menuOptionSetWaveform = "Set waveform (all)"
local menuOptionAddNew = "Add new node"
local menuOptionRndPositions = "Randomise positions"
local menuOptionRndNotes = "Randomise notes"

local menuItems = {
	{label = menuOptionSetWaveform},
	{label = menuOptionAddNew},
	{label = menuOptionRndPositions},
	{label = menuOptionRndNotes},
}

local dialogHeight = 120

function NodesDialog:init()
		NodesDialog.super.init(self)	
		self.crankDelta = 0
end

function NodesDialog:show(
	onDismiss, 
	onRandomisePositions, 
	onRandomiseNotes,
	onWaveform,
	onAddNew
)
	
	self.onDismiss = onDismiss

	local background = gfx.image.new(200, dialogHeight, playdate.graphics.kColorWhite)
	gfx.pushContext(background)
	gfx.setColor(gfx.kColorBlack)
	gfx.drawRoundRect(0, 0, 200, dialogHeight, 12) 
	gfx.popContext()
	self.backgroundSprite = gfx.sprite.new(background)
	self.backgroundSprite:moveTo(200, 120)
	self.backgroundSprite:add()
	

	
	self.menuList = TextList(menuItems, 110, 120 - (dialogHeight/2) + 10, 200 - 20, 240  - 10, 20, nil, function(index, item)
		if item.label == menuOptionSetWaveform then
			self:dismissNoCallback()
			self:showWaveformDialog(onWaveform)
		elseif item.label == menuOptionAddNew then
			self:dismissNoCallback()
			onAddNew()
		elseif item.label == menuOptionRndPositions then
			self:dismissNoCallback()
			onRandomisePositions()
		elseif item.label == menuOptionRndNotes then
			self:dismissNoCallback()
			onRandomiseNotes()
		end
	end, 29000)
	
	self.menuInputHandler = {
		
		BButtonDown = function()
			self:dismiss()
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
		"Select waveform:", 
		function() 
			
			
		end,
		function(waveform)
			onWaveform(waveform)
		end
	)
end

function NodesDialog:dismissNoCallback()
	playdate.inputHandlers.pop()
	self.menuList:removeAll()
	self.backgroundSprite:remove()
end

function NodesDialog:dismiss()
	playdate.inputHandlers.pop()
	self.menuList:removeAll()
	self.backgroundSprite:remove()
	self.onDismiss()
end