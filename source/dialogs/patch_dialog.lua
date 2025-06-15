import "CoreLibs/sprites"
import "CoreLibs/graphics"
import "CoreLibs/ui"
import "presets"
import "user_patches"
import 'text_list'
import "dialogs/patch_load_dialog"
import "dialogs/user_patches_dialog"
import "dialogs/patch_save_dialog"
import "CoreLibs/keyboard"

local gfx <const> = playdate.graphics

--[[
	
	The entry point to the dialogs
	
]]
class('PatchDialog').extends()

local menuItems = {
	{name = "User:",type = "category_title"},
	{label = "New"},
	{label = "Save"},
	{label = "Open"},
	{label = "Delete"},
	{type = "divider"},
	{name = "Presets:", type = "category_title"},
	{label = "Synths"},
	{label = "Sequencers"}
}

function PatchDialog:init()
		PatchDialog.super.init(self)	
		self.crankDelta = 0
end

function PatchDialog:show(onDismiss, onLoadPatch, onSavePatch, onDeletePatch)
	
	self.onDismiss = onDismiss

	local background = gfx.image.new(gDialogWidth, gDialogHeight, playdate.graphics.kColorWhite)
	gfx.pushContext(background)
	gfx.setColor(gfx.kColorBlack)
	gfx.drawRoundRect(0, 0, gDialogWidth, gDialogHeight, 12) 
	gfx.popContext()
	self.backgroundSprite = gfx.sprite.new(background)
	self.backgroundSprite:moveTo(400 - (gDialogWidth/2), 120)
	self.backgroundSprite:add()
	
	--(items, xx, yy, w, h, rH, onChange, onSelect, zIndex)
	self.menuList = TextList(menuItems, 400 - (gDialogWidth - 10), 120 - (gDialogHeight/2) + 10, 200 - 20, 240  - 10, 20, nil, function(index, item)
		if(item.label == "New") then
			self:dismiss()
			onLoadPatch(Presets():newPatch())
		elseif(item.label == "Save") then
			self:dismiss()
			self:showSaveDialog(onSavePatch)
		elseif(item.label == "Open") then
			self:dismiss()
			UserPatchesDialog():show(
				function()
					--onDismiss
				end,
				function(patch)
					--onLoadPatch
					onLoadPatch(patch)
				end
			)
		elseif(item.label == "Presets") then
			self:showPatchMenu(false, true, false, onDismiss, onLoadPatch, nil)
		elseif(item.label == "Delete") then
			self:showPatchMenu(true, false, true, onDismiss, onLoadPatch, onDeletePatch)
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

function PatchDialog:showSaveDialog(onSavePatch)
	self:dismiss()
	local patchSaveDialog = PatchSaveDialog()
	playdate.keyboard.keyboardDidShowCallback = function()
		patchSaveDialog:show()
	end
	playdate.keyboard.textChangedCallback = function()
		patchSaveDialog:setText(playdate.keyboard.text)
	end
	playdate.keyboard.keyboardWillHideCallback = function(doSave)
		if(doSave) then
			local saveName = playdate.keyboard.text
			playdate.keyboard.text = ""--reset for next time
			onSavePatch(saveName)
		end
		
		patchSaveDialog:dismiss()
	end
	
	playdate.keyboard.show("")
	
end

function PatchDialog:showPatchMenu(showPatches, showPresets, isDelete, onDismiss, onLoadPatch, onDeletePatch)
	self:dismiss()
	PatchLoadDialog():show(
		showPatches, 
		showPresets,
		isDelete,
		function()
			onDismiss()
		end, 
		function (patch)
			onLoadPatch(patch)
		end,
		function (patch)
			onDeletePatch(patch)
		end
	)
end

function PatchDialog:dismiss()
	playdate.inputHandlers.pop()
	self.menuList:removeAll()
	self.backgroundSprite:remove()
end