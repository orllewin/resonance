import "CoreLibs/sprites"
import "CoreLibs/graphics"
import "CoreLibs/ui"
import "presets"
import "user_patches"
import 'text_list'
import "patch_load_dialog"
import "patch_save_dialog"
import "CoreLibs/keyboard"

local gfx <const> = playdate.graphics

--[[
	
	Various code helpers
	
]]
class('NodesDialog').extends()

function NodesDialog:init()
		NodesDialog.super.init(self)	
		self.crankDelta = 0
end

local dialogHeight = 120

function NodesDialog:show(onDismiss, onRandomise)
	
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
			label = "Randomise all"
		},
	}
	
	self.menuList = TextList(menuItems, 110, 120 - (dialogHeight/2) + 10, 200 - 20, 240  - 10, 20, nil, function(index, item)
		if(item.label == "Randomise all") then
			self:dismissNoCallback()
			onRandomise()
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

function NodesDialog:showSaveDialog(onSavePatch)
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

function NodesDialog:showPatchMenu(showPatches, showPresets, isDelete, onDismiss, onLoadPatch, onDeletePatch)
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