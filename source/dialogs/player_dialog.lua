import "CoreLibs/sprites"
import "CoreLibs/graphics"
import "CoreLibs/ui"
import 'text_list'

local gfx <const> = playdate.graphics

--[[
	
	Mutate a player
	
]]
class('PlayerDialog').extends()

local menuOptionSetOrbit = "Set orbit"
local menuOptionSetOscillator = "Set oscillator"
local menuOptionSetVelocity = "Set velocity"
local menuOptionReset = "Reset"

local menuItems = {
	{label = menuOptionSetOrbit}, 
	{label = menuOptionSetOscillator},
	{label = menuOptionSetVelocity},
	{label = menuOptionReset},
}

function PlayerDialog:init()
		PlayerDialog.super.init(self)	
		self.crankDelta = 0
end

local dialogHeight = 170
local dialogWidth = 200

function PlayerDialog:show(
	player, 
	playerIndex, 
	onDismiss, 
	onSetOrbit, 
	onSetOscillator, 
	onSetVelocity,
	onReset
)
	
	self.onDismiss = onDismiss
	
	self.entryState = true

	local label = "Player " .. playerIndex
	local background = gfx.image.new(dialogWidth, dialogHeight, playdate.graphics.kColorWhite)
	gfx.pushContext(background)
	gfx.setColor(gfx.kColorBlack)
	gfx.drawRoundRect(0, 0, 200, dialogHeight, 12) 
	gfx.drawText(label, 10, 15)
	gfx.popContext()
	self.backgroundSprite = gfx.sprite.new(background)
	self.backgroundSprite:moveTo(200, 120)
	self.backgroundSprite:add()
	
	local x = 110
	local y = 120 - (dialogHeight/2) + 35
	local w = 200 - 50
	local h = dialogHeight - 45
	self.menuList = TextList(menuItems, x, y, w, h, 20, nil, function(index, item)
		if(item.label == menuOptionSetOrbit) then
			self:dismissNoCallback()
			onSetOrbit()
		elseif item.label == menuOptionSetOscillator then
			self:dismissNoCallback()
			onSetOscillator()
		elseif item.label == menuOptionSetVelocity then
			self:dismissNoCallback()
			onSetVelocity()
		elseif item.label == menuOptionReset then
			self:dismissNoCallback()
			onReset()
		end
	end, 29000)
	
	self.menuInputHandler = {
		
		BButtonDown = function()
			self:dismiss()
		end,
		
		AButtonHeld = function() end,
		AButtonDown = function() end,
		AButtonUp = function()
			if self.entryState then
				self.entryState = false
			else
				self.menuList:tapA()
			end
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

function PlayerDialog:dismissNoCallback()
	playdate.inputHandlers.pop()
	self.menuList:removeAll()
	self.backgroundSprite:remove()
end

function PlayerDialog:dismiss()
	playdate.inputHandlers.pop()
	self.menuList:removeAll()
	self.backgroundSprite:remove()
	self.onDismiss()
end