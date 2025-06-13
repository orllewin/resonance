import "CoreLibs/sprites"
import "CoreLibs/graphics"
import "CoreLibs/ui"
import "presets"
import "user_patches"
import 'text_list'
import 'midi'
import "patch_load_dialog"
import "patch_save_dialog"
import "CoreLibs/keyboard"

local gfx <const> = playdate.graphics

--[[
	
	Mutate a node
	
]]
class('NodeDialog').extends()

function NodeDialog:init()
		NodeDialog.super.init(self)	
		self.crankDelta = 0
end

local dialogHeight = 170
local dialogWidth = 200

function NodeDialog:show(node, onDismiss, onWaveform)
	
	self.onDismiss = onDismiss

	local label = "" .. node.midiNote .. "/" .. midi:label(node.midiNote) .. " "
	 .. node.waveform .. " " .. math.floor(node.p.x) .. "." .. math.floor(node.p.y)
	local background = gfx.image.new(dialogWidth, dialogHeight, playdate.graphics.kColorWhite)
	gfx.pushContext(background)
	gfx.setColor(gfx.kColorBlack)
	gfx.drawRoundRect(0, 0, 200, dialogHeight, 12) 
	gfx.drawText(label, 10, 15)
	gfx.popContext()
	self.backgroundSprite = gfx.sprite.new(background)
	self.backgroundSprite:moveTo(200, 120)
	self.backgroundSprite:add()
	
	local menuItems = {
		{
			label = "Sine"
		}, 
		{
			label = "Square"
		},
		{
			label = "Sawtooth"
		}, 
		{
			label = "Triangle"
		}, 
		{
			label = "Phase"
		}, 
		{
			label = "Digital"
		}, 
		{
			label = "Vosim"
		}, 
		{
			label = "Noise"
		}
	}
	--(items, xx, yy, w, h, rH, onChange, onSelect, zIndex)
	local x = 110
	local y = 120 - (dialogHeight/2) + 35
	local w = 200 - 50
	local h = dialogHeight - 45
	self.menuList = TextList(menuItems, x, y, w, h, 20, nil, function(index, item)
		--if(item.label == "Randomise all") then
			self:dismissNoCallback()
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

function NodeDialog:showSaveDialog(onSavePatch)
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

function NodeDialog:showPatchMenu(showPatches, showPresets, isDelete, onDismiss, onLoadPatch, onDeletePatch)
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

function NodeDialog:dismissNoCallback()
	playdate.inputHandlers.pop()
	self.menuList:removeAll()
	self.backgroundSprite:remove()
end

function NodeDialog:dismiss()
	playdate.inputHandlers.pop()
	self.menuList:removeAll()
	self.backgroundSprite:remove()
	self.onDismiss()
end