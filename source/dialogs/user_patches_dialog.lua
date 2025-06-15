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
end

function UserPatchesDialog:show(onDismiss, onLoadPatch)
	self.onDismiss = onDismiss
	local background = gfx.image.new(gDialogWidth, gDialogHeight, gfx.kColorWhite)
	gfx.pushContext(background)
	gfx.setColor(gfx.kColorBlack)
	gfx.drawRoundRect(0, 0, gDialogWidth, gDialogHeight, 12) 
	
	gfx.drawText("XUser patches", 10, 10)
	
	self.crankDelta = 0
	
	gfx.drawLine(5, 24, gDialogWidth - 10, 24)
	
	gfx.popContext()
	
	self.backgroundSprite = gfx.sprite.new(background)
	self.backgroundSprite:moveTo(400 - (gDialogWidth/2), 120)
	self.backgroundSprite:add()
	
	print("load patches")
	local menuItems = {}
	local menuIndex = 1
	
	local showList = true
	
	local userPatchesRepository = UserPatches()
	
	local userPatchMenuItems = {}
	local userPatches = userPatchesRepository:patches()

		print("loading user patches")
		if #userPatches == 0 then
			showList = true
			--todo - improve this - just show a modal instead
			menuItems[1] = {
				label = "No patches saved"
			}
		else
		
			for u = 1, #userPatches, 1 do
				local userPatch = userPatches[u]
				print("Adding userpath: " .. userPatch.name)
				userPatchMenuItems[u] = {
					label = userPatch.name
				}
				menuItems[menuIndex] = userPatchMenuItems[u]
				menuIndex += 1
			end
		end
	
	self.patchList = TextList(menuItems, 400 - (gDialogWidth - 10), 120 - (gDialogHeight/2) + 30, 200 - 20, 240  - 10, 20, nil, function(index, item)
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