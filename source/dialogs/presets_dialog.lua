import "presets"
import "user_patches"
import 'text_list'
import 'string_utils'

local gfx <const> = playdate.graphics

class('PresetsDialog').extends()

function PresetsDialog:init()
		PresetsDialog.super.init(self)	
		self.crankDelta = 0
end

function PresetsDialog:show(isSynths, onDismiss, onLoadPatch)
	self.onDismiss = onDismiss
	local background = gfx.image.new(gDialogWidth, gDialogHeight, gfx.kColorWhite)
	gfx.pushContext(background)
	gfx.setColor(gfx.kColorBlack)
	gfx.drawRoundRect(0, 0, gDialogWidth, gDialogHeight, 12) 	
	gfx.popContext()
	
	self.backgroundSprite = gfx.sprite.new(background)
	self.backgroundSprite:moveTo(400 - (gDialogWidth/2), 120)
	self.backgroundSprite:add()
	
	local menuItems = {}
	local menuIndex = 1

	local presetMenuItems = {}
	local presets = Presets()
	
	if isSynths then
		self.presets = presets:synths()
	else
		self.presets = presets:sequencers()
	end
	
		self.textList = TextList(self.presets, 400 - (gDialogWidth - 10), 120 - (gDialogHeight/2) + 10, 200 - 20, gDialogHeight - 44, 20, nil, function(index, item)
			self:dismiss()
			onLoadPatch(item)
			
		end, 29000)
	
	self.inputHandler = {
		
		BButtonDown = function()
			self:dismiss()
		end,
		
		AButtonDown = function()
			if self.textList ~= nil then self.textList:tapA() end
		end,
		
		leftButtonDown = function()
	
		end,
		
		rightButtonDown = function()
	
		end,
		
		upButtonDown = function()
			if self.textList ~= nil then self.textList:goUp() end
		end,
		
		downButtonDown = function()
			if self.textList ~= nil then self.textList:goDown() end
		end,
		
		cranked = function(change, acceleratedChange)
			if self.textList ~= nil then 
				self.crankDelta += change
				if self.crankDelta < -20 then
					self.crankDelta = 0.0
					self.textList:goUp()
				elseif self.crankDelta > 20 then
					self.crankDelta = 0.0
					self.textList:goDown()
				end
			end
		end,
	}
	
	playdate.inputHandlers.push(self.inputHandler)
end

function PresetsDialog:dismiss()
	playdate.inputHandlers.pop()
	if self.textList ~= nil then self.textList:removeAll() end
	self.backgroundSprite:remove()
end
