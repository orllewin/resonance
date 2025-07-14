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
	gfx.popContext()
	
	self.backgroundSprite = gfx.sprite.new(background)
	self.backgroundSprite:moveTo(400 - (gDialogWidth/2), 120)
	self.backgroundSprite:add()
		
	local userPatchesRepository = UserPatches()
	local userPatches = userPatchesRepository:patchesMenu()
	
	self.textList = TextList(userPatches, 400 - (gDialogWidth - 10), 120 - (gDialogHeight/2) + 10, gDialogWidth - 20, gDialogHeight  - 10, 20, nil, function(index, item)
		AlertDialog():show(
			"Confirm",
			"Are you sure you want to delete " .. item.name .. "?",
			"Cancel",
			"Delete",
			function()  
				--onDismiss
			end,
			function()
				--onConfirm
				local file = replace(item.file, ".json", "")
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