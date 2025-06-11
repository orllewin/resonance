import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/keyboard"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/ui"
import "audio"
import "node"
import "midi"
import "patch_save_dialog"
import "player_node"
import "presets"
import "waveform_icon"

local gfx <const> = playdate.graphics
local geom <const> = playdate.geometry
local audio = Audio()

local nodes = {}
local playerNodes = {}
local synths = {}

local leftDown = false
local rightDown = false
local upDown = false
local downDown = false

local setOriginMode = false

local waveformMenu
waveform = "Triangle"
local waveformIcon = WaveformIcon()
waveformIcon:setWaveform(waveform)

local presets = Presets():presets()

local showingLoadPatchMenu = false
local showingSavePatchMenu = false

local menuGrid = playdate.ui.gridview.new(100 - 8, 100)
local menuBackground = gfx.image.new(400, 240, gfx.kColorWhite)
menuGrid.backgroundImage = menuBackground
menuGrid:setNumberOfColumns(4)
menuGrid:setNumberOfRows(4)
--menuGrid:setContentInset(1, 4, 1, 4)
menuGrid:setCellPadding(4, 4, 4, 4)
menuGrid.changeRowOnColumnWrap = false

function menuGrid:drawCell(section, row, column, selected, x, y, width, height)
	if selected then
		gfx.fillRoundRect(x, y, width, height, 4)
		gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
	else
		gfx.setImageDrawMode(gfx.kDrawModeCopy)
	end
	local entryIndex = (((row-1) * 4) + (column-1))
	if(entryIndex < #presets) then
		local preset = presets[entryIndex + 1]
		gfx.drawTextInRect(preset.name, x, y+ (height/2), width, height, nil, "...", kTextAlignment.center)
	else
		gfx.drawTextInRect("--", x, y+ (height/2), width, height, nil, "...", kTextAlignment.center)
	end
end

local activeNode = 0
local activePlayerNode = 1

midi = Midi()

--todo be a good citizen and maybe turn this on and off depending on selected waveform
playdate.startAccelerometer()

local savePatchInputHandler = {
	
}

local loadPatchInputHandler = {
	
	AButtonDown = function()
		showingLoadPatchMenu = false
		playdate.inputHandlers.pop()
		local section, row, column = menuGrid:getSelection()
		local selectedIndex = (((row-1) * 4) + (column-1))
		if(selectedIndex < #presets) then
			local selectedPreset = presets[selectedIndex + 1]
			print("Selected preset = " .. selectedPreset.name)
			nodes[1]:setNote(selectedPreset.notes[1].midiNote)
			nodes[1]:moveTo(selectedPreset.notes[1].x, selectedPreset.notes[1].y)
			
			nodes[2]:setNote(selectedPreset.notes[2].midiNote)
			nodes[2]:moveTo(selectedPreset.notes[2].x, selectedPreset.notes[2].y)
			
			nodes[3]:setNote(selectedPreset.notes[3].midiNote)
			nodes[3]:moveTo(selectedPreset.notes[3].x, selectedPreset.notes[3].y)
			
			nodes[4]:setNote(selectedPreset.notes[4].midiNote)
			nodes[4]:moveTo(selectedPreset.notes[4].x, selectedPreset.notes[4].y)
			
			nodes[5]:setNote(selectedPreset.notes[5].midiNote)
			nodes[5]:moveTo(selectedPreset.notes[5].x, selectedPreset.notes[5].y)
			
			nodes[6]:setNote(selectedPreset.notes[6].midiNote)
			nodes[6]:moveTo(selectedPreset.notes[6].x, selectedPreset.notes[6].y)
			
			nodes[7]:setNote(selectedPreset.notes[7].midiNote)
			nodes[7]:moveTo(selectedPreset.notes[7].x, selectedPreset.notes[7].y)
			
			nodes[8]:setNote(selectedPreset.notes[8].midiNote)
			nodes[8]:moveTo(selectedPreset.notes[8].x, selectedPreset.notes[8].y)
			
			waveform = selectedPreset.waveform
			waveformMenu:setValue(waveform)
			for i = 1,8,1 do 
				nodes[i]:setWaveform(waveform)
			end
			waveformIcon:setWaveform(waveform)
			
			playerNodes[1]:moveTo(selectedPreset.player1.x, selectedPreset.player1.y)
			playerNodes[1]:setSize(selectedPreset.player1.size)
			if selectedPreset.player1.orbitActive then
				playerNodes[1]:setActiveOrbit(
					selectedPreset.player1.orbitX, 
					selectedPreset.player1.orbitY,
					selectedPreset.player1.orbitVelocity
				)
			end
			
			playerNodes[2]:moveTo(selectedPreset.player2.x, selectedPreset.player2.y)
			playerNodes[2]:setSize(selectedPreset.player2.size)
			if selectedPreset.player2.orbitActive then
				playerNodes[2]:setActiveOrbit(
					selectedPreset.player2.orbitX, 
					selectedPreset.player2.orbitY,
					selectedPreset.player2.orbitVelocity
				)
			end
		end
		
	end,
	
	leftButtonDown = function()
		menuGrid:selectPreviousColumn()
	end,
	
	rightButtonDown = function()
		menuGrid:selectNextColumn()
	end,
	
	upButtonDown = function()
		menuGrid:selectPreviousRow()
	end,
	
	downButtonDown = function()
		menuGrid:selectNextRow()
	end,
}

local mainInputHandler = {
	
	AButtonDown = function()
		
	end,
	
	AButtonHeld = function()
		setOriginMode = true
		playerNodes[activePlayerNode]:setOriginMode(true)
	end,
	
	AButtonUp = function()
		if setOriginMode then
			setOriginMode = false
			playerNodes[activePlayerNode]:setOriginMode(false)
		else
			if(activeNode > 0) then
				--setLabelsVisible(false)
				activeNode = 0
				for i = 1,8,1 do nodes[i]:deselect() end
			else
				if(activePlayerNode == 1) then
					activePlayerNode = 2
				else
					activePlayerNode = 1
				end
			end
		end
	end,
	
	BButtonDown = function()
		--setLabelsVisible(true)
		for i = 1,8,1 do nodes[i]:deselect() end
		activeNode += 1
		if(activeNode == 9) then
			activeNode = 1
		end
		
		nodes[activeNode]:select()
	end,
	
	leftButtonDown = function()
		leftDown = true
	end,
	
	leftButtonUp = function()
		leftDown = false
	end,
	
	rightButtonDown = function()
		rightDown = true
	end,
	
	rightButtonUp = function()
		rightDown = false
	end,
	
	upButtonDown = function()
		upDown = true
	end,
	
	upButtonUp = function()
		upDown = false
	end,

	downButtonDown = function()
		downDown = true
	end,
	
	downButtonUp = function()
		downDown = false
	end,
	
	cranked = function(change, acceleratedChange)
		if(activeNode > 0) then
			nodes[activeNode]:crank(change)
		else
			if(activePlayerNode == 1) then
				playerNodes[1]:crank(change)
				updateNodes()
			else
				playerNodes[2]:crank(change)
				updateNodes()
			end
		end
		
	end,
}

function setLabelsVisible(visible)
	for i = 1,8,1 do 
		nodes[i]:labelVisible(visible)
	end
end

function setup()
	local backgroundImage = gfx.image.new( "images/background" )
	assert( backgroundImage )
	
	gfx.sprite.setBackgroundDrawingCallback(
			function( x, y, width, height )
					backgroundImage:draw( 0, 0 )
			end
	)
	
	local font = playdate.graphics.font.new("parodius_ext")
	gfx.setFont(font)
	playdate.setCrankSoundsDisabled(true)
	playdate.display.setInverted(true)
	playdate.inputHandlers.push(mainInputHandler)
	
	
	local menu = playdate.getSystemMenu()			
	
	local saveDialog = PatchSaveDialog()
	playdate.keyboard.keyboardDidShowCallback = function()
		saveDialog:show()
	end
	playdate.keyboard.textChangedCallback = function()
		saveDialog:setText(playdate.keyboard.text)
	end
	
	local presetSelectItem, error = menu:addMenuItem("Load patch", function()
			showingLoadPatchMenu = true
			playdate.inputHandlers.push(loadPatchInputHandler)
	end)
	
	local savePatchItem, error = menu:addMenuItem("Save patch", function()
			showingSavePatchMenu = true

			playdate.keyboard.show("")

			playdate.keyboard.keyboardDidHideCallback = function()
				local savePatchName = playdate.keyboard.text
				print("Keyboard dismissed, patch name: " .. savePatchName)
				saveDialog:hide()
				showingSavePatchMenu = false
				--todo save patch
			end
	end)
	
	waveformMenu = menu:addOptionsMenuItem("Wave:", {"Sine", "Square", "Sawtooth", "Triangle", "Phase", "Digital", "Vosim"}, waveform, function(value)
			waveform = value
			print("Waveform changed to: ", waveform)
			for i = 1,8,1 do 
				nodes[i]:setWaveform(waveform)
			end
			waveformIcon:setWaveform(waveform)
	end)
	
	
	local scale = midi:generateScale(50, "Dorian")
	
	nodes[1] = Node(geom.point.new(66, 60), scale[1])
	nodes[2] = Node(geom.point.new(66, 180), scale[4])
	nodes[3] = Node(geom.point.new(133, 120), scale[7])
	nodes[4] = Node(geom.point.new(200, 60), scale[10])
	nodes[5] = Node(geom.point.new(200, 180), scale[14])
	nodes[6] = Node(geom.point.new(266, 120), scale[17])
	nodes[7] = Node(geom.point.new(333, 60), scale[21])
	nodes[8] = Node(geom.point.new(333, 180), scale[24])
	
	playerNodes[1] = PlayerNode(geom.point.new(67, 120), 100, geom.point.new(133, 120), 35)
	playerNodes[2] = PlayerNode(geom.point.new(333, 120), 75, geom.point.new(266, 120), 60)
	
	setLabelsVisible(true)
end

setup()

function playdate.update()
	gfx.sprite.update()
	
	if showingLoadPatchMenu then
		menuGrid:drawInRect(0, 0, 400, 240)
	end
	
	playdate.timer.updateTimers()
	
	--These will only fire with the main input handler 
	--since it's the only one that needs key repeat:
	if(leftDown) then
		if setOriginMode then
			playerNodes[activePlayerNode]:moveOrigin(-2, 0)
		elseif(activeNode > 0) then
			nodes[activeNode]:move(-2, 0)
		else
			playerNodes[activePlayerNode]:move(-2, 0)
		end
	end
	if(rightDown) then
		if setOriginMode then
			playerNodes[activePlayerNode]:moveOrigin(2, 0)
		elseif(activeNode > 0) then
			nodes[activeNode]:move(2, 0)
		else
			playerNodes[activePlayerNode]:move(2, 0)
		end
	end
	if(upDown) then
		if setOriginMode then
			playerNodes[activePlayerNode]:changeOrbitVelocity(2)
		elseif(activeNode > 0) then
			nodes[activeNode]:move(0, -2)
		else
			playerNodes[activePlayerNode]:move(0, -2)
		end
	end
	if(downDown) then
		if setOriginMode then
			playerNodes[activePlayerNode]:changeOrbitVelocity(-2)
		elseif(activeNode > 0) then
			nodes[activeNode]:move(0, 2)
		else
			playerNodes[activePlayerNode]:move(0, 2)
		end
	end
	
	--Only draw nodes if menu not displaying
	if not showingLoadPatchMenu and not showingSavePatchMenu then
		updateNodes()
	end
end

function updateNodes()
		for i = 1,8,1 do 
			local node = nodes[i]
			node:checkPlayers(playerNodes) 
			if(node.p:distanceToPoint(playerNodes[1].p) < playerNodes[1].size) then
				gfx.drawLine(node.p.x, node.p.y, playerNodes[1].p.x, playerNodes[1].p.y)
			end
			if(node.p:distanceToPoint(playerNodes[2].p) < playerNodes[2].size) then
				gfx.drawLine(node.p.x, node.p.y, playerNodes[2].p.x, playerNodes[2].p.y)
			end
		end
		
		for p =1,2,1 do
			local playerNode = playerNodes[p]
			playerNode:updateOrbit()
		end
end