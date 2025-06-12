import "CoreLibs/sprites"
import "CoreLibs/graphics"
import "CoreLibs/ui"
import "presets"
import "user_patches"
import 'text_list'

local gfx <const> = playdate.graphics


class('PatchDialog').extends()

function PatchDialog:init()
		PatchDialog.super.init(self)	
end

function PatchDialog:show(onDismiss, onLoadUserPatch, onLoadPreset)
	
	self.onDismiss = onDismiss
	local background = gfx.image.new(200, 240, playdate.graphics.kColorWhite)
	self.backgroundSprite = gfx.sprite.new(background)
	self.backgroundSprite:moveTo(200, 120)
	self.backgroundSprite:add()
	
	local menuItems = {
		{
			label = "New"
		},
		{
			label = "Save"
		},
		{
			label = "Load patch"
		},
		{
			label = "Load preset"
		},
		{
			label = "Delete"
		},
	}
	
	self.menuList = TextList(menuItems, 105, 5, 200 - 10, 240  - 10, 20, nil, function(index, item)
		
		
		self:dismiss()
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

function PatchDialog:dismiss()
	playdate.inputHandlers.pop()
	self.menuList:removeAll()
	self.backgroundSprite:remove()
	self.onDismiss()
end