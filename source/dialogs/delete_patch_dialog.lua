import "CoreLibs/sprites"
import "CoreLibs/graphics"
import "CoreLibs/ui"
import "user_patches"
import 'text_list'
import 'string_utils'
import 'dialogs/alert_dialog'

local gfx <const> = playdate.graphics

class('DeletePatchDialog').extends()

function DeletePatchDialog:init()
		DeletePatchDialog.super.init(self)	
end

function DeletePatchDialog:show(onDismiss)
	self.onDismiss = onDismiss
	local background = gfx.image.new(gDialogWidth, gDialogHeight, gfx.kColorWhite)
	gfx.pushContext(background)
	gfx.setColor(gfx.kColorBlack)
	gfx.drawRoundRect(0, 0, gDialogWidth, gDialogHeight, 12) 
	
	gfx.drawText("User patches", 10, 10)
	
	self.crankDelta = 0
	
	gfx.drawLine(5, 24, gDialogWidth - 10, 24)
	
	gfx.popContext()
	
	self.backgroundSprite = gfx.sprite.new(background)
	self.backgroundSprite:moveTo(400 - (gDialogWidth/2), 120)
	self.backgroundSprite:add()
	
	local menuItems = {}
	local menuIndex = 1
	
	local showList = true
	
	local userPatchesRepository = UserPatches()
	
	local userPatchMenuItems = {}
	local userPatches = userPatchesRepository:patches()
	if #userPatches == 0 then
	
	end
	
	self.textList = TextList(userPatches, 400 - (gDialogWidth - 10), 120 - (gDialogHeight/2) + 30, 200 - 20, 240  - 10, 20, nil, function(index, item)
		AlertDialog():show(
			"Confirm",
			"Are you sure you want to delete " .. userPatches[index].name .. "?",
			"Cancel",
			"Delete",
			function()  
				--onDismiss
			end,
			function()
				--onConfirm
				local selectedUserPatch = userPatches[index]
				local file = replace(selectedUserPatch.file, ".json", "")
				playdate.datastore.delete(file)
				playdate.inputHandlers.pop()
				self.textList:removeAll()
				self.backgroundSprite:remove()
				self:show(onDismiss)
			end
		)
		end)
	
	self.patchLoadInputHandler = {
		
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
	
	playdate.inputHandlers.push(self.patchLoadInputHandler)
end

function DeletePatchDialog:dismiss()
	playdate.inputHandlers.pop()
	if self.textList ~= nil then self.textList:removeAll() end
	self.backgroundSprite:remove()
	self.onDismiss()
end