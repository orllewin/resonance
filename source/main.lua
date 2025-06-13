import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/ui"
import "node"
import "midi"
import "patch_dialog"
import "nodes_dialog"
import "node_dialog"
import "player_node"
import "presets"
import "patch_name"

local gfx <const> = playdate.graphics
local geom <const> = playdate.geometry

local nodes = {}
local playerNodes = {}
local synths = {}

local leftDown = false
local rightDown = false
local upDown = false
local downDown = false

local setOriginMode = false

local patchNameSprite = PatchName()
local presets = Presets():presets()

local showingLoadPatchMenu = false
local showingSavePatchMenu = false
local showingMenu = false

local activeNode = 0
local activePlayerNode = 1

local nodeDidHold = false

midi = Midi()

--todo be a good citizen and maybe turn this on and off depending on selected waveform
playdate.startAccelerometer()

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
				activeNode = 0
				for i = 1,#nodes,1 do nodes[i]:deselect() end
			else
				activePlayerNode += 1
				if activePlayerNode > #playerNodes then activePlayerNode = 1 end
				for p = 1,#playerNodes,1 do
					local player = playerNodes[p]
					if p == activePlayerNode then
						player:setActive(true)
					else
						player:setActive(false)
					end
				end
			end
		end
	end,
	
	BButtonHeld = function()
		nodeDidHold = true
		--showingMenu = true
		if activeNode == 0 then
			print("Error: Active node is 0")
			return
		end
		local nodeDialog = NodeDialog()
		nodeDialog:show(
			nodes[activeNode],
			function ()
				-- onDismiss
				--showingMenu = false
			end,
			function (waveform)
				--onWaveform
				--showingMenu = false
				nodes[activeNode]:setWaveform(waveform)
				nodes[activeNode]:select()
			end
		)
	end,
	
	BButtonUp = function()
		if not nodeDidHold then
			local nodeCount = #nodes
			for i = 1,nodeCount,1 do nodes[i]:deselect() end
			activeNode += 1
			if(activeNode == nodeCount + 1) then
				activeNode = 1
			end
			
			nodes[activeNode]:select()
		end
		
		nodeDidHold = false
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
			playerNodes[activePlayerNode]:crank(change)
			updateNodes()
		end
	end,
}

function setLabelsVisible(visible)
	for i = 1,#nodes,1 do 
		nodes[i]:labelVisible(visible)
	end
end

function savePatch(patchName)
	local filename = playdate.epochFromTime(playdate.getTime()) .. ".res"
	local patch = {}
	
	patch.name = string.lower(patchName)
	
	local nodeStates = {}
	local nodeCount = #nodes
	for i = 1,nodeCount,1 do 
		local nodeState = nodes[i]:getState()
		nodeStates[i] = nodeState
	end
	
	patch.nodes = nodeStates
	
	local playerStates = {}
	local playerCount = #playerNodes
	for i = 1,playerCount,1 do 
		local playerNodeState = playerNodes[i]:getState()
		playerStates[i] = playerNodeState
	end
	
	patch.players = playerStates
	
	local patchJson = json.encodePretty(patch)
	print(patchJson)
	playdate.datastore.write(patch, filename, true)
	patchNameSprite:update(patchName)
end

local patchDialog = PatchDialog()
local nodesDialog = NodesDialog()

function loadPatch(patch)
	printTable(patch)
	patchNameSprite:update(patch.name)
	
	--empty nodes table
	for k, v in pairs(nodes) do 
		v:stop()
		nodes[k] = nil 
	end
	
	for k, v in pairs(patch.nodes) do
		local node = Node(geom.point.new(v.x, v.y), v.midiNote)
		table.insert(nodes, node)
	end
	
	if patch.waveform ~= nil then
		local nodeCount = #nodes
		for i = 1,nodeCount,1 do 
			nodes[i]:setWaveform(waveform)
		end
	end
	
	--empty players table
	for k, v in pairs(playerNodes) do 
		v:stop()
		playerNodes[k] = nil 
	end
	
	for k, v in pairs(patch.players) do
		local playerNode = PlayerNode(geom.point.new(v.x, v.y), v.size, nil, nil, 1)
		 playerNode:setActiveOrbit(
			 v.orbitX, 
			 v.orbitY,
			 v.orbitVelocity,
			 v.orbitStartAngle
		 )
		 table.insert(playerNodes, playerNode)
	end
	
	setLabelsVisible(true)
end

function setup()
	local backgroundImage = gfx.image.new( "images/background" )
	assert( backgroundImage )
	
	local menuImage = gfx.image.new( "images/elderwean" )
	playdate.setMenuImage(menuImage, 100)
	
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
		
	
	local patchMenuItem, error = menu:addMenuItem("Patches", 
		function()
			showingMenu = true
		
			--onDismiss, onLoadPatch, onSavePatch, onDeletePatch
			patchDialog:show(
				function()
					--onDismiss
					showingMenu = false 
				end, 
				function(patch)
					--onLoadPatch
					showingMenu = false 
					loadPatch(patch)
				end,
				function(saveName)
					--onSavePatch
					showingMenu = false 
					savePatch(saveName)
				end,
				function(patch)
					--onDeletePatch
					print("Delete patch:" .. patch.name)
				end
			)
		end
	)
	
	local nodesMenuItem, error = menu:addMenuItem("Nodes", 
		function()
			showingMenu = true
	
			nodesDialog:show(
				function()
					--onDismiss
					showingMenu = false 
				end,
				function()
					--onRandomise
					showingMenu = false 
					local nodeCount = #nodes
					for n = 1,nodeCount,1 do
						nodes[n]:randomise()
					end
					local playerCount = #playerNodes
					for p = 1,playerCount,1 do
						playerNodes[p]:randomise()
					end
				end,
				function()
					--onRandomiseNotes
					showingMenu = false 
					local scale = midi:generateRandomScale(40)
					local nodeCount = #nodes
					for n = 1,nodeCount,1 do
						nodes[n]:chooseRandomNote(scale)
					end
				end,
				function(waveform)
					--onWaveform
					showingMenu = false 
					local nodeCount = #nodes
					for n = 1,nodeCount,1 do
						nodes[n]:setWaveform(waveform)
					end
				end
			)
		end
	)
	
	local scale = midi:generateScale(50, "Dorian")
	
	nodes[1] = Node(geom.point.new(66, 60), scale[1])
	nodes[2] = Node(geom.point.new(66, 180), scale[4])
	nodes[3] = Node(geom.point.new(133, 120), scale[7])
	nodes[4] = Node(geom.point.new(200, 60), scale[10])
	nodes[5] = Node(geom.point.new(200, 180), scale[14])
	nodes[6] = Node(geom.point.new(266, 120), scale[17])
	nodes[7] = Node(geom.point.new(333, 60), scale[21])
	nodes[8] = Node(geom.point.new(333, 180), scale[24])
	
	playerNodes[1] = PlayerNode(geom.point.new(67, 120), 67, geom.point.new(133, 120), 27, -1)
	playerNodes[2] = PlayerNode(geom.point.new(333, 120), 65, geom.point.new(266, 120), 23, 1)
	
	setLabelsVisible(true)
end

setup()

function playdate.update()
	gfx.sprite.update()
	
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
	if not showingMenu and not showingLoadPatchMenu and not showingSavePatchMenu then
		updateNodes()
	end
end

function updateNodes()
		local nodeCount = #nodes
		for i = 1,nodeCount,1 do 
			local node = nodes[i]
			node:checkPlayers(playerNodes) 
			for p = 1, #playerNodes, 1 do 
				local player = playerNodes[p]
				player:updateOrbit()
				if(node.p:distanceToPoint(player.p) < player.size) then
					gfx.drawLine(node.p.x, node.p.y, player.p.x, player.p.y)
				end
			end
		end
end