import "CoreLibs/sprites"
import "CoreLibs/graphics"
import "CoreLibs/ui"
import "presets"
import "user_patches"
import 'text_list'
import 'string_utils'

local gfx <const> = playdate.graphics

class('UserPatchesDialog').extends()

function UserPatchesDialog:init()
		UserPatchesDialog.super.init(self)	
		
		self.crankDelta = 0
end

function UserPatchesDialog:show(onDismiss, onLoadPatch)
	self.onDismiss = onDismiss
	local background = gfx.image.new(gDialogWidth, gDialogHeight, gfx.kColorWhite)
	gfx.pushContext(background)
	gfx.setColor(gfx.kColorBlack)
	gfx.drawRoundRect(0, 0, gDialogWidth, gDialogHeight, 12) 		
	gfx.popContext()
	
	self.backgroundSprite = gfx.sprite.new(background)
	self.backgroundSprite:moveTo(400 - (gDialogWidth/2), 120)
	self.backgroundSprite:add()
		
	local userPatchesRepository = UserPatches()
	local userPatches = userPatchesRepository:patchesMenu()
	
	self.patchList = TextList(userPatches, 400 - (gDialogWidth - 10), 120 - (gDialogHeight/2) + 10, 200 - 20, 240  - 10, 20, nil, function(index, item)
			onLoadPatch(item)
			self:dismiss()
		end, 29000)
	
	self.patchLoadInputHandler = {
		
		BButtonDown = function()
			self:dismiss()
		end,
		
		AButtonDown = function()
			if self.patchList ~= nil then self.patchList:tapA() end
		end,
		
		leftButtonDown = function()
	
		end,
		
		rightButtonDown = function()
	
		end,
		
		upButtonDown = function()
			if self.patchList ~= nil then self.patchList:goUp() end
		end,
		
		downButtonDown = function()
			if self.patchList ~= nil then self.patchList:goDown() end
		end,
		
		cranked = function(change, acceleratedChange)
			if self.patchList ~= nil then 
				self.crankDelta += change
				if self.crankDelta < -20 then
					self.crankDelta = 0.0
					self.patchList:goUp()
				elseif self.crankDelta > 20 then
					self.crankDelta = 0.0
					self.patchList:goDown()
				end
			end
		end,
	}
	
	playdate.inputHandlers.push(self.patchLoadInputHandler)
end

function UserPatchesDialog:dismiss()
	playdate.inputHandlers.pop()
	if self.patchList ~= nil then self.patchList:removeAll() end
	self.backgroundSprite:remove()
	self.onDismiss()
end

function UserPatchesDialog:draw()

end