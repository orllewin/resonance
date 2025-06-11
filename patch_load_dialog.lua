import "CoreLibs/sprites"
import "CoreLibs/graphics"
import "CoreLibs/ui"
import "presets"

local gfx <const> = playdate.graphics

class('PatchLoadDialog').extends()

local ppresets = Presets():presets()

function PatchLoadDialog:init()
		PatchLoadDialog.super.init(self)	
		
			
		
		self.menuGrid = playdate.ui.gridview.new(100 - 8, 100)
		local menuBackground = gfx.image.new(400, 240, gfx.kColorWhite)
		self.menuGrid.backgroundImage = menuBackground
		self.menuGrid:setNumberOfColumns(4)
		self.menuGrid:setNumberOfRows(4)
		self.menuGrid:setCellPadding(4, 4, 4, 4)
		self.menuGrid.changeRowOnColumnWrap = false

		function self.menuGrid:drawCell(section, row, column, selected, x, y, width, height)
			if selected then
				gfx.fillRoundRect(x, y, width, height, 4)
				gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
			else
				gfx.setImageDrawMode(gfx.kDrawModeCopy)
			end
			
			local entryIndex = (((row-1) * 4) + (column-1))
			
			if(entryIndex < #ppresets) then
				local preset = ppresets[entryIndex + 1]
				gfx.drawTextInRect(preset.name, x, y+ (height/2), width, height, nil, "...", kTextAlignment.center)
			else
				gfx.drawTextInRect("--", x, y+ (height/2), width, height, nil, "...", kTextAlignment.center)
			end
		end
end




function PatchLoadDialog:show()
	--todo load ing data here
	--self.menuGrid:setNumberOfColumns(4)
	--self.menuGrid:setNumberOfRows(4)
	
end

function PatchLoadDialog:draw()
	self.menuGrid:drawInRect(0, 0, 400, 240)
end