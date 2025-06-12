import "CoreLibs/sprites"
import "CoreLibs/graphics"
import "CoreLibs/ui"
import "presets"
import "user_patches"
import 'text_list'
import 'string_utils'

local gfx <const> = playdate.graphics

class('PatchLoadDialog').extends()

function PatchLoadDialog:init()
		PatchLoadDialog.super.init(self)	
end

function PatchLoadDialog:show(showPatches, showPresets, isDelete, onDismiss, onLoadPatch, onDeletePatch)
	self.onDismiss = onDismiss
	local background = gfx.image.new(200, 240, gfx.kColorWhite)
	gfx.pushContext(background)
	gfx.setColor(gfx.kColorBlack)
	gfx.drawRoundRect(0, 0, 200, 240, 12) 
	
	if isDelete then
		gfx.drawText("Delete patch", 10, 10)
	elseif showPatches then
		gfx.drawText("User patches", 10, 10)
	elseif showPresets then
		gfx.drawText("Presets", 10, 10)
	end
	
	gfx.drawLine(5, 24, 200 - 10, 24)
	
	gfx.popContext()
	
	self.backgroundSprite = gfx.sprite.new(background)
	self.backgroundSprite:moveTo(200, 120)
	self.backgroundSprite:add()
	
	print("load patches")
	local menuItems = {}
	local menuIndex = 1
	
	local showList = true
	
	local userPatchesRepository = UserPatches()
	
	local userPatchMenuItems = {}
	local userPatches = userPatchesRepository:patches()
	if showPatches then
		print("loading user patches")
		if #userPatches == 0 then
			showList = false
			
		else
		
			for u = 1, #userPatches, 1 do
				local userPatch = userPatches[u]
				userPatchMenuItems[u] = {
					label = userPatch.name
				}
				menuItems[menuIndex] = userPatchMenuItems[u]
				menuIndex += 1
			end
		end
	end
	
	local presetMenuItems = {}
	local presets = Presets():presets()
	if showPresets then
		for p = 1, #presets, 1 do
			local preset = presets[p]
			presetMenuItems[p] = {
				label = preset.name
			}
			menuItems[menuIndex] = presetMenuItems[p]
			menuIndex += 1
		end
	end

	if showList then
		self.patchList = TextList(menuItems, 110, 34, 200 - 20, 240 - 44, 20, nil, function(index, item)
			if index <= #userPatchMenuItems then
				print("returning user patch at index " .. index)
				local selectedUserPatch = userPatches[index]
				if isDelete then
					local file = replace(selectedUserPatch.file, ".json", "")
					playdate.datastore.delete(file)
					playdate.inputHandlers.pop()
					self.patchList:removeAll()
					self.backgroundSprite:remove()
					self:show(showPatches, showPresets, isDelete, onDismiss, onLoadPatch, onDeletePatch)
				else
					onLoadPatch(selectedUserPatch)
					self:dismiss()
				end
				
			else
				local selectedPreset = presets[index - #userPatchMenuItems]
				onLoadPatch(selectedPreset)
				self:dismiss()
			end
			
			
		end, 29000)
	end
	
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

function PatchLoadDialog:dismiss()
	playdate.inputHandlers.pop()
	if self.patchList ~= nil then self.patchList:removeAll() end
	self.backgroundSprite:remove()
	self.onDismiss()
end

function PatchLoadDialog:draw()

end