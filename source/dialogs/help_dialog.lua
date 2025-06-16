import "CoreLibs/sprites"
import "CoreLibs/graphics"
import "CoreLibs/ui"
import "button"

local gfx <const> = playdate.graphics

class('HelpDialog').extends()

local text = "Welcome to Resonance, a drone instrument and sequencer from orllewin (orllewin.uk)\n\n" ..
"There are three main controls:\n\n" ..
"(A) steps through the note nodes, when selected you can move a node or change its note with the crank. A long press with (A) will open a context menu for the node.\n\n" .. 
"(B) steps through the player nodes, when a player approaches a note node it causes it to emit audio. A player can be controlled manually or with a long press of (B) a context menu will open where you can set orbits. The crank will change a player nodes range.\n\n" ..
"A global menu can be opened by pressing (A) then (B) together."


function HelpDialog:init()
		HelpDialog.super.init(self)
end

function HelpDialog:show(onDismiss)
	local background = gfx.image.new(400, 240, gfx.kColorWhite)
	gfx.pushContext(background)
	gfx.setColor(gfx.kColorBlack)
	gfx.drawRoundRect(0, 0, 400, 240, 12) 
	gfx.drawText("Resonance Help", 10, 10)
	gfx.drawLine(5, 24, 400 - 10, 24)
	
	--(text, x, y, [width, height], [leadingAdjustment], [wrapMode], [alignment]) 
	gfx.drawText(text, 10, 33, 400 - 20, 200, nil, gfx.kWrapWord, gfx.kAlignLeft)

	gfx.popContext()
	
	self.backgroundSprite = gfx.sprite.new(background)
	self.backgroundSprite:moveTo(200, 120)
	self.backgroundSprite:add()
	
	self.confirmButton = Button(
		"Continue:::",
		345,--x
		220,--y 
		function()
			--onClick
			self:dismiss()
			onDismiss()
		end
	)
	
	self.confirmButton:focus()
	
	self.patchLoadInputHandler = {
		
		BButtonDown = function()
			self:dismiss()
			onDismiss()
		end,
		
		AButtonDown = function()
			self.confirmButton:click()
		end,
		
		leftButtonDown = function()
		end,
		
		rightButtonDown = function()
		end,
		
		upButtonDown = function()
		end,
		
		downButtonDown = function()
		end,
		
		cranked = function(change, acceleratedChange)
		end,
	}
	
	playdate.inputHandlers.push(self.patchLoadInputHandler)
end

function HelpDialog:dismiss()
	playdate.inputHandlers.pop()
	self.confirmButton:remove()
	self.backgroundSprite:remove()
end