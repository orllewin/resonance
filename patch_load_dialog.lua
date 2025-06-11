import "CoreLibs/sprites"
import "CoreLibs/graphics"
import "CoreLibs/ui"
import "presets"
import 'text_list'

local gfx <const> = playdate.graphics
local ppresets = Presets():presets()

class('PatchLoadDialog').extends()

function PatchLoadDialog:init()
		PatchLoadDialog.super.init(self)	
end

function PatchLoadDialog:show(onLoad)
	local background = gfx.image.new(400, 240, playdate.graphics.kColorWhite)
	self.backgroundSprite = gfx.sprite.new(background)
	self.backgroundSprite:moveTo(200, 120)
	self.backgroundSprite:add()
	local menuItems = {}
	for p =1,#ppresets,1 do
		local preset = ppresets[p]
		menuItems[p] = {
			label = preset.name
		}
	end
	
	--items, xx, yy, w, h, rH, onChange, onSelect, zIndex
	self.patchList = TextList(menuItems, 5, 5, 400 - 10, 240  - 10, 20, nil, function(index, item)
		local selectedPreset = ppresets[index]
		if onLoad ~= nil then onLoad(selectedPreset) end
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
end

function PatchLoadDialog:draw()

end