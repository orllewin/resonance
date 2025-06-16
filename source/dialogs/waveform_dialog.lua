import "CoreLibs/sprites"
import "CoreLibs/graphics"
import "CoreLibs/ui"
import 'text_list'

local gfx <const> = playdate.graphics

--[[
	Choose a waveform
]]
class('WaveformDialog').extends()

local menuItems = {
	{label = "Waveform:::", type="category_title"},
	{label = "Sine"}, 
	{label = "Square"},
	{label = "Sawtooth"}, 
	{label = "Triangle"}, 
	{label = "Phase"}, 
	{label = "Digital"}, 
	{label = "Vosim"}, 
	{label = "Noise"}
}

function WaveformDialog:init()
		WaveformDialog.super.init(self)	
		self.crankDelta = 0
end

function WaveformDialog:show(title, onDismiss, onWaveform)
	
	self.onDismiss = onDismiss

	local background = gfx.image.new(gDialogWidth, gDialogHeight, playdate.graphics.kColorWhite)
	gfx.pushContext(background)
	gfx.setColor(gfx.kColorBlack)
	gfx.drawRoundRect(0, 0, gDialogWidth, gDialogHeight, 12) 
	gfx.popContext()
	self.backgroundSprite = gfx.sprite.new(background)
	self.backgroundSprite:moveTo(400 - (gDialogWidth/2), gDialogHeight/2)
	self.backgroundSprite:add()
	

	--(items, xx, yy, w, h, rH, onChange, onSelect, zIndex)
	local x = 400 - (gDialogWidth - 10)
	local y = 120 - (gDialogHeight/2) + 10
	local w = gDialogWidth - 20
	local h = gDialogHeight - 10
	self.menuList = TextList(menuItems, x, y, w, h, 20, nil, function(index, item)
		--if(item.label == "Randomise all") then
			self:dismiss()
			onWaveform(item.label)
		--end
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

function WaveformDialog:dismiss()
	playdate.inputHandlers.pop()
	self.menuList:removeAll()
	self.backgroundSprite:remove()
end