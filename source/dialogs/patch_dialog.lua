import "CoreLibs/sprites"
import "CoreLibs/graphics"
import "CoreLibs/ui"
import "presets"
import "user_patches"
import 'text_list'
import "dialogs/patch_load_dialog"
import "dialogs/patch_save_dialog"
import "CoreLibs/keyboard"

local gfx <const> = playdate.graphics

--[[
	
	The entry point to the dialogs
	
]]
class('PatchDialog').extends()

function PatchDialog:init()
		PatchDialog.super.init(self)	
		self.crankDelta = 0
end

local dialogHeight = 120

function PatchDialog:show(onDismiss, onLoadPatch, onSavePatch, onDeletePatch)
	
	self.onDismiss = onDismiss

	
	local background = gfx.image.new(200, dialogHeight, playdate.graphics.kColorWhite)
	gfx.pushContext(background)
	gfx.setColor(gfx.kColorBlack)
	gfx.drawRoundRect(0, 0, 200, dialogHeight, 12) 
	gfx.popContext()
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
			label = "Open"
		},
		{
			label = "Presets"
		},
		{
			label = "Delete"
		},
	}
	
	self.menuList = TextList(menuItems, 110, 120 - (dialogHeight/2) + 10, 200 - 20, 240  - 10, 20, nil, function(index, item)
		if(item.label == "New") then
			self:dismissNoCallback()
			onLoadPatch(Presets():new())
		elseif(item.label == "Save") then
			self:dismissNoCallback()
			self:showSaveDialog(onSavePatch)
		elseif(item.label == "Open") then
			self:showPatchMenu(true, false, false, onDismiss, onLoadPatch, nil)
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
	self:dismissNoCallback()
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
		
		patchSaveDialog:dismissNoCallback()
	end
	
	playdate.keyboard.show("")
	
end

function PatchDialog:showPatchMenu(showPatches, showPresets, isDelete, onDismiss, onLoadPatch, onDeletePatch)
	self:dismissNoCallback()
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

function PatchDialog:dismissNoCallback()
	playdate.inputHandlers.pop()
	self.menuList:removeAll()
	self.backgroundSprite:remove()
end

function PatchDialog:dismiss()
	playdate.inputHandlers.pop()
	self.menuList:removeAll()
	self.backgroundSprite:remove()
	self.onDismiss()
end