import "CoreLibs/sprites"
import "CoreLibs/graphics"
import "CoreLibs/ui"
import "presets"
import "user_patches"
import 'text_list'

local gfx <const> = playdate.graphics


class('PatchLoadDialog').extends()

function PatchLoadDialog:init()
		PatchLoadDialog.super.init(self)	
end

function PatchLoadDialog:show(onDismiss, onLoadUserPatch, onLoadPreset)
	self.onDismiss = onDismiss
	local background = gfx.image.new(200, 240, playdate.graphics.kColorWhite)
	self.backgroundSprite = gfx.sprite.new(background)
	self.backgroundSprite:moveTo(200, 120)
	self.backgroundSprite:add()
	
	print("load patches")
	local menuItems = {}
	local menuIndex = 1
	
	local userPatchMenuItems = {}
	local userPatches = UserPatches():patches()
	for u = 1, #userPatches, 1 do
		local userPatch = userPatches[u]
		userPatchMenuItems[u] = {
			label = userPatch.name
		}
		menuItems[menuIndex] = userPatchMenuItems[u]
		menuIndex += 1
	end
	
	
	local presets = Presets():presets()
	local presetMenuItems = {}
	for p = 1, #presets, 1 do
		local preset = presets[p]
		presetMenuItems[p] = {
			label = preset.name
		}
		menuItems[menuIndex] = presetMenuItems[p]
		menuIndex += 1
	end

	
	--items, xx, yy, w, h, rH, onChange, onSelect, zIndex
	self.patchList = TextList(menuItems, 105, 5, 200 - 10, 240  - 10, 20, nil, function(index, item)
		if index <= #userPatches then
			print("returning user patch at index " .. index)
			local selectedUserPatch = userPatches[index]
			onLoadUserPatch(selectedUserPatch)
		else
			local selectedPreset = presets[index - #userPatches]
			if onLoadPreset ~= nil then onLoadPreset(selectedPreset) end
		end
		
		self:dismiss()
	end, 29000)
	
	self.modulePopupInputHandler = {
		
		BButtonDown = function()
			self:dismiss()
		end,
		
		AButtonDown = function()
			self.patchList:tapA()
		end,
		
		leftButtonDown = function()
	
		end,
		
		rightButtonDown = function()
	
		end,
		
		upButtonDown = function()
			self.patchList:goUp()
		end,
		
		downButtonDown = function()
			self.patchList:goDown()
		end,
		
		cranked = function(change, acceleratedChange)
			self.crankDelta += change
			if self.crankDelta < -20 then
				self.crankDelta = 0.0
				self.patchList:goUp()
			elseif self.crankDelta > 20 then
				self.crankDelta = 0.0
				self.patchList:goDown()
			end
		end,
	}
	playdate.inputHandlers.push(self.modulePopupInputHandler)
end

function PatchLoadDialog:dismiss()
	print("ModulePopup:dismiss()")
	playdate.inputHandlers.pop()
	self.patchList:removeAll()
	self.backgroundSprite:remove()
	self.onDismiss()
end

function PatchLoadDialog:draw()

end