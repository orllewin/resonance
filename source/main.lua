import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/ui"

import "node"
import "player_node"
import "sprites/orbit_config"
import "sprites/oscillator_config"

import "midi"

import "dialogs/patch_dialog"
import "dialogs/nodes_dialog"
import "dialogs/node_dialog"
import "dialogs/player_dialog"
import "dialogs/velocity_dialog"

import "sprites/active_node"

import "presets"
import "patch_name"

local gfx <const> = playdate.graphics
local geom <const> = playdate.geometry

local stepSize = 3

--globals
resFont = gfx.font.new("parodius_ext")
gfx.setFont(resFont)

gDialogHeight = 240
gDialogWidth = 200 

local introLabelSprite = gfx.sprite.spriteWithText("Resonance", 400, 20)

local nodes = {}
local playerNodes = {}
local synths = {}

local leftDown = false
local rightDown = false
local upDown = false
local downDown = false

local setOriginMode = false

local patchNameSprite = PatchName()

local showingLoadPatchMenu = false
local showingSavePatchMenu = false
local showingMenu = false

local activeNodeLabel = ActiveNodeLabel()
local activeNode = 0
local activePlayerNode = 1

local nodeDidHold = false

midi = Midi()

local orbitConfig = OrbitConfig()
local oscillatorConfig = OscillatorConfig()

--todo be a good citizen and maybe turn this on and off depending on selected waveform
playdate.startAccelerometer()

local mainInputHandler = {
	
	AButtonDown = function()
		if playdate.buttonIsPressed(playdate.kButtonB) then
			showNodesMenu()
		end
	end,
	
	AButtonHeld = function()	
		local playerDialog = PlayerDialog()
		playerDialog:show(
			playerNodes[activePlayerNode],
			activePlayerNode,
			function()
				--onDismiss
			end,
			function()
				--onSetOrbit
				playerNodes[activePlayerNode]:move(0, 0)--removes orbit
				orbitConfig:show(
					function()
						--onDismiss
					end,
					function(oX, oY, pX, pY)
						--onSetOrbit
						playerNodes[activePlayerNode]:moveTo(pX, pY)
						playerNodes[activePlayerNode]:setActiveOrbit(oX, oY, 50, 1)
					end
				)
			end,
			function()
				--onToggleDirection
				playerNodes[activePlayerNode]:toggleDirection()
			end,
			function()
				--onSetOscillator
				playerNodes[activePlayerNode]:move(0, 0)--removes orbit
				oscillatorConfig:show(
					function()
						--onDismiss
					end,
					function(oX, oY, pX, pY)
						--onSetOrbit
						playerNodes[activePlayerNode]:moveTo(pX, pY)
						playerNodes[activePlayerNode]:setActiveOrbit(oX, oY, 50, 1)
					end
				)
			end,
			function()
				--onSetVelocity
				VelocityDialog():show(
					playerNodes[activePlayerNode],
					function()
						--onDismiss
					end,
					function(velocity)
						--onSetVelocity
						playerNodes[activePlayerNode]:setOrbitVelocity(velocity)
					end
				)
			end,
			function()
				--onReset
				playerNodes[activePlayerNode]:move(0, 0)
			end,
			function()
				--onRemove
				--todo confirmation dialog?
				if #playerNodes > 1 then
					playerNodes[activePlayerNode]:stop()
					table.remove(playerNodes, activePlayerNode)
					activePlayerNode = 1
					playerNodes[activePlayerNode]:setActive(true)
				end
			end
		)
	end,
	
	AButtonUp = function()
		if setOriginMode then
			setOriginMode = false
			playerNodes[activePlayerNode]:setOriginMode(false)
		else
			if not nodeDidHold then
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
								activeNodeLabel:updatePlayer(player)
							else
								player:setActive(false)
							end
						end
					end
				end
				nodeDidHold = false
		end
	end,
	
	BButtonDown = function()
		
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
				nodeDidHold = true
			end,
			function (waveform)
				--onWaveform
				--showingMenu = false
				nodeDidHold = true
				nodes[activeNode]:setWaveform(waveform)
				nodes[activeNode]:select()
				activeNodeLabel:updateNode(nodes[activeNode])
			end,
			function()
				--onRemove
				if #nodes > 1 then
					nodes[activeNode]:stop()
					table.remove(nodes, activeNode)
					activeNode = 1
					nodes[activeNode]:select()
					activeNodeLabel:updateNode(nodes[activeNode])
				end
			end
		)
	end,
	
	BButtonUp = function()
		if not nodeDidHold then

			--deselect active player
			playerNodes[activePlayerNode]:setActive(false)
			
			local nodeCount = #nodes
			for i = 1,nodeCount,1 do nodes[i]:deselect() end
			activeNode += 1
			if(activeNode == nodeCount + 1) then
				activeNode = 1
			end
			
			nodes[activeNode]:select()
			activeNodeLabel:updateNode(nodes[activeNode])
			
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
			activeNodeLabel:updateNode(nodes[activeNode])
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
	introLabelSprite:setScale(1)
	introLabelSprite:moveTo(355, 10)
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
		if v.waveform ~= nil then 
			node:setWaveform(v.waveform) 
		elseif patch.waveform ~= nil then
			node:setWaveform(patch.waveform) 
		end
		table.insert(nodes, node)
	end
	
	--empty players table
	for k, v in pairs(playerNodes) do 
		v:stop()
		playerNodes[k] = nil 
	end
	
	for k, v in pairs(patch.players) do
		local playerNode = PlayerNode(geom.point.new(v.x, v.y), v.size, nil, nil, 1)
		if v.isOrbiting then
			playerNode:setActiveOrbit(
				v.orbitX, 
				v.orbitY,
				v.orbitVelocity,
				v.orbitStartAngle
			)
 		end
		 table.insert(playerNodes, playerNode)
	end
	
	introLabelSprite:setScale(1)
	introLabelSprite:moveTo(355, 10)
	
	setLabelsVisible(true)
end

function showNodesMenu()
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
		end,
		function()
			--onAddNew
			showingMenu = false 
			local newIndex = #nodes + 1
			nodes[newIndex] = Node(geom.point.new(200, 120), 60)
			setLabelsVisible(true)
			
			--todo-- set the new node as active - some weirdness stopping it being simple
		end,
		function()
			--onOctaveUp
			showingMenu = false 
			local nodeCount = #nodes
			for n = 1,nodeCount,1 do
				nodes[n]:octaveUp()
			end
		end,
		function()
			--onOctaveDown
			showingMenu = false 
			local nodeCount = #nodes
			for n = 1,nodeCount,1 do
				nodes[n]:octaveDown()
			end
		end
	)
end

function setup()
	local backgroundImage = gfx.image.new( "images/background" )
	assert( backgroundImage )
	
	--local menuImage = gfx.image.new( "images/elderwean" )
	local menuImage = gfx.image.new( "images/menu_image" )
	playdate.setMenuImage(menuImage, 100)
	
	gfx.sprite.setBackgroundDrawingCallback(
			function( x, y, width, height )
					backgroundImage:draw( 0, 0 )
			end
	)
	
	playdate.setCrankSoundsDisabled(true)
	playdate.display.setInverted(true)
	playdate.inputHandlers.push(mainInputHandler)
	
	
	local menu = playdate.getSystemMenu()			
		
	
	local patchMenuItem, error = menu:addMenuItem("Patches", 
		function()
			showingMenu = true
		
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
				end
			)
		end
	)
	
	local nodesMenuItem, error = menu:addMenuItem("Nodes", 
		function()
			showNodesMenu()
		end
	)
	
	loadPatch(Presets():defaultPatch())
	
	introLabelSprite:moveTo(310, 220)
	introLabelSprite:setScale(2)
	introLabelSprite:add()
	
	setLabelsVisible(true)
end

setup()

function playdate.update()
	gfx.sprite.update()
	
	playdate.timer.updateTimers()
	
	--These will only fire with the main input handler 
	--since it's the only one that needs key repeat:
	if orbitConfig.showing then
		orbitConfig:checkKeys()
	elseif oscillatorConfig.showing then
		oscillatorConfig:checkKeys()
	else
		if(leftDown) then
			if setOriginMode then
				playerNodes[activePlayerNode]:moveOrigin(-stepSize, 0)
			elseif(activeNode > 0) then
				nodes[activeNode]:move(-stepSize, 0)
				activeNodeLabel:updateNode(nodes[activeNode])
			else
				playerNodes[activePlayerNode]:move(-stepSize, 0)
			end
		end
		if(rightDown) then
			if setOriginMode then
				playerNodes[activePlayerNode]:moveOrigin(stepSize, 0)
			elseif(activeNode > 0) then
				nodes[activeNode]:move(stepSize, 0)
				activeNodeLabel:updateNode(nodes[activeNode])
			else
				playerNodes[activePlayerNode]:move(stepSize, 0)
			end
		end
		if(upDown) then
			if setOriginMode then
				playerNodes[activePlayerNode]:changeOrbitVelocity(2)
			elseif(activeNode > 0) then
				nodes[activeNode]:move(0, -stepSize)
				activeNodeLabel:updateNode(nodes[activeNode])
			else
				playerNodes[activePlayerNode]:move(0, -stepSize)
			end
		end
		if(downDown) then
			if setOriginMode then
				playerNodes[activePlayerNode]:changeOrbitVelocity(-stepSize)
			elseif(activeNode > 0) then
				nodes[activeNode]:move(0, stepSize)
				activeNodeLabel:updateNode(nodes[activeNode])
			else
				playerNodes[activePlayerNode]:move(0, stepSize)
			end
		end
	end
	
	--Only draw nodes if menu not displaying
	if not showingMenu then
		updateNodes()
		
		if(activeNodeLabel.isPlayer) then
			activeNodeLabel:updatePlayer(playerNodes[activePlayerNode])
			gfx.drawText(activeNodeLabel.text, 5, 230)
		else 
			if activeNodeLabel.supportsAccelerometer then
				gfx.drawText(activeNodeLabel.text, 27, 230)
			else
				gfx.drawText(activeNodeLabel.text, 5, 230)
			end
		end
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