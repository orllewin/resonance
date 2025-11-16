import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/ui"

import "node"
import "player_node"
import "sprites/orbit_config"
import "sprites/oscillator_config"
import "sprites/patch_name"

import "midi"

import "dialogs/patch_dialog"
import "dialogs/nodes_dialog"
import "dialogs/node_dialog"
import "dialogs/player_dialog"
import "dialogs/velocity_dialog"
import "dialogs/help_dialog"
import "dialogs/effects_dialog"
import "dialogs/full_effects_dialog"

import "sprites/active_node"

import "presets"

local gfx <const> = playdate.graphics
local geom <const> = playdate.geometry

local stepSize = 3

local nodes = {}
nodeCount = 0
local playerNodes = {}
local synths = {}

--globals
resFont = gfx.font.new("parodius_ext")
gfx.setFont(resFont)

gChannel = playdate.sound.channel.new()

gShowSerialLog = false
gAccelerometerActive = false

-- 1. Delay (Pre) Effect
gPreDelay = playdate.sound.delayline.new(3.0)
gPreDelayMax = 3.0
gPreDelayTap1 = gPreDelay:addTap(gPreDelayMax)

gPreDelayTime = 1.2
gPreDelayTap1:setDelay(gPreDelayTime)

gPreDelayVolume = 0.0
gPreDelayTap1:setVolume(gPreDelayVolume)
gChannel:addSource(gPreDelayTap1)
gPreDelay:setMix(0.0)

gPreDelayFeedback = 0.2
gPreDelay:setFeedback(gPreDelayFeedback)

gChannel:addEffect(gPreDelay)

-- 2. Ringmod Effect
gRingmod = playdate.sound.ringmod.new()
gRingmodFreq = 120
gRingmodFreqMin = 20
gRingmodFreqMax = 4000
gRingmodMix = 0.0
gRingmod:setFrequency(gRingmodFreq)
gRingmod:setMix(gRingmod)
gChannel:addEffect(gRingmod)

-- 3. Bitcrusher Effect
gBitcrusher = playdate.sound.bitcrusher.new()
gBitcrusherAmount = 0.0
gBitcrusherUndersample = 0.0
gBitcrusherMix = 0.0
gBitcrusher:setAmount(gBitcrusherAmount)
gBitcrusher:setUndersampling(gBitcrusherUndersample)
gBitcrusher:setMix(gBitcrusherMix)
gChannel:addEffect(gBitcrusher)

-- 4. Overdrive Effect
gOverdriveGain = 24.0
gOverdriveGainMax = 64.0
gOverdriveLimit = 48.0
gOverdriveLimitMax = 64.0
gOverdriveMix = 0.0
gOverdrive = playdate.sound.overdrive.new()
gOverdrive:setGain(gOverdriveGain)
gOverdrive:setLimit(gOverdriveLimit)
gOverdrive:setMix(gOverdriveMix)
gChannel:addEffect(gOverdrive)

-- 5. Delay (Mid) Effect
gMidDelay = playdate.sound.delayline.new(3.0)
gMidDelayMax = 3.0
gMidDelayTap1 = gMidDelay:addTap(gMidDelayMax)

gMidDelayTime = 1.2
gMidDelayTap1:setDelay(gMidDelayTime)

gMidDelayVolume = 0.0
gMidDelayTap1:setVolume(gMidDelayVolume)
gChannel:addSource(gMidDelayTap1)
gMidDelay:setMix(0.0)

gMidDelayFeedback = 0.2
gMidDelay:setFeedback(gMidDelayFeedback)

gChannel:addEffect(gMidDelay)

-- 6. Low-pass Effect
gLowPass = playdate.sound.twopolefilter.new(playdate.sound.kFilterLowPass)
gLowPassFreq = 120
gLowPassFreqMin = 40
gLowPassFreqMax = 1000
gLowPassRes = 0.5
gLowPassMix = 0.0
gLowPass:setResonance(gLowPassRes)
gLowPass:setFrequency(gLowPassFreq)
gLowPass:setMix(gLowPassMix)
gChannel:addEffect(gLowPass)

-- 7. High-pass Effect
gHighPass = playdate.sound.twopolefilter.new(playdate.sound.kFilterHighPass)
gHighPassFreq = 120
gHighPassFreqMin = 40
gHighPassFreqMax = 2000
gHighPassRes = 0.5
gHighPassMix = 0.0
gHighPass:setResonance(gHighPassRes)
gHighPass:setFrequency(gHighPassFreq)
gHighPass:setMix(gHighPassMix)
gChannel:addEffect(gHighPass)

-- 8. Delay (Post) Effect
gDelay = playdate.sound.delayline.new(3.0)
gDelayMax = 3.0
gDelayTap1 = gDelay:addTap(gDelayMax)

gDelayTime = 1.2
gDelayTap1:setDelay(gDelayTime)

gDelayVolume = 0.0
gDelayTap1:setVolume(gDelayVolume)
gChannel:addSource(gDelayTap1)
gDelay:setMix(0.0)

gDelayFeedback = 0.2
gDelay:setFeedback(gDelayFeedback)

gChannel:addEffect(gDelay)

-- End of effects

gDialogHeight = 240
gDialogWidth = 200 

maxVelocity = 50.0

local serialLog = {"Serial Log"}

local WAVEFORM_SELECT <const> = "wf"
local WAVEFORM_PARAM_1 <const> = "wfp1"
local WAVEFORM_PARAM_2 <const> = "wfp2"
local LOAD_PATCH <const> = "patch"
local CLEAR_PATCH <const> = "clr"
local ADD_NOTE <const> = "note"
local ADD_PLAYER <const> = "plyr"
local OCT_UP <const> = "octu"
local OCT_DOWN <const> = "octd"
local PATCH_REQUEST <const> = "prq"

local EFFECT_PRE_DELAY_TIME <const> = "pdt"
local EFFECT_PRE_DELAY_FEEDBACK <const> = "pdf"
local EFFECT_PRE_DELAY_MIX <const> = "pdm"

local EFFECT_MID_DELAY_TIME <const> = "mdt"
local EFFECT_MID_DELAY_FEEDBACK <const> = "mdf"
local EFFECT_MID_DELAY_MIX <const> = "mdm"

local EFFECT_DELAY_TIME <const> = "psdt"
local EFFECT_DELAY_FEEDBACK <const> = "psdf"
local EFFECT_DELAY_MIX <const> = "psdm"

local EFFECT_LOWPASS_FREQ <const> = "lpf"
local EFFECT_LOWPASS_RESONANCE <const> = "lpr"
local EFFECT_LOWPASS_MIX <const> = "lpm"

local EFFECT_HIGHPASS_FREQ <const> = "hpf"
local EFFECT_HIGHPASS_RESONANCE <const> = "hpr"
local EFFECT_HIGHPASS_MIX <const> = "hpm"

local EFFECT_OVERDRIVE_GAIN <const> = "odg"
local EFFECT_OVERDRIVE_LIMIT <const> = "odl"
local EFFECT_OVERDRIVE_MIX <const> = "odm"

local EFFECT_BITCRUSHER_AMOUNT <const> = "bca"
local EFFECT_BITCRUSHER_UNDERSAMPLE <const> = "bcu"
local EFFECT_BITCRUSHER_MIX <const> = "bcm"

local EFFECT_RINGMOD_FREQ <const> = "rmf"
local EFFECT_RINGMOD_MIX <const> = "rmm"

function playdate.serialMessageReceived(message)
	print("SERIAL: " .. message)
	
	local tokens = getWords(message)
	local command = tokens[1]
	local valueStr = tokens[2]
	local valueNumber = tonumber(valueStr)
	
	if command == PATCH_REQUEST then
		serialPatchSend()
	elseif command == ADD_NOTE then
		local x = tonumber(tokens[2])
		local y = tonumber(tokens[3])
		local midiNote = tonumber(tokens[4])
		local newIndex = #nodes + 1
		nodes[newIndex] = Node(geom.point.new(x, y), midiNote)--table.insert duh
		nodeCount = #nodes
	elseif command == ADD_PLAYER then
		local x = tonumber(tokens[2])
		local y = tonumber(tokens[3])
		local size = tonumber(tokens[4])
		local playerNode = PlayerNode(geom.point.new(x, y), size * 2, nil, nil, 1)
		table.insert(playerNodes, playerNode)
	elseif command == OCT_UP then
		local nodeCount = #nodes
		for n = 1,nodeCount,1 do
			nodes[n]:octaveUp()
		end
	elseif command == OCT_DOWN then
		local nodeCount = #nodes
		for n = 1,nodeCount,1 do
			nodes[n]:octaveDown()
		end
	elseif command == CLEAR_PATCH then
		print("CLEAR_PATCH")
		local patchStr = "{\"name\": \"Serial\", \"waveform\": \"sine\", \"nodes\": [],\"players\": [{ \"size\": 64, \"x\": 200, \"y\": 120 }]}"
		local clearPatchTable = json.decode(patchStr)
		printTable(clearPatchTable)
		loadPatch(clearPatchTable)
	elseif command == WAVEFORM_SELECT then
		print("WAVEFORM_SELECT: " ..  valueStr)
		local nodeCount = #nodes
		for n = 1,nodeCount,1 do
			nodes[n]:setWaveform(valueStr)
		end
	elseif command == WAVEFORM_PARAM_1 then
		local nodeCount = #nodes
		for n = 1,nodeCount,1 do
			nodes[n]:setSynthParam1(valueNumber)
		end
	elseif command == WAVEFORM_PARAM_2 then
		local nodeCount = #nodes
		for n = 1,nodeCount,1 do
			nodes[n]:setSynthParam2(valueNumber)
		end
	elseif command == EFFECT_PRE_DELAY_TIME then
		gPreDelayTime = map(valueNumber, 0, 100, 0.0, gPreDelayMax)
		gPreDelayTap1:setDelay(gPreDelayTime)
	elseif command == EFFECT_PRE_DELAY_FEEDBACK then
		gPreDelayFeedback = valueNumber/100.0
		gPreDelay:setFeedback(gPreDelayFeedback)
	elseif command == EFFECT_PRE_DELAY_MIX then
		gPreDelayVolume = valueNumber/200.0--max 0.5 delay volume
		gPreDelayTap1:setVolume(gPreDelayVolume)
	elseif command == EFFECT_MID_DELAY_TIME then
		gMidDelayTime = map(valueNumber, 0, 100, 0.0, gMidDelayMax)
		gMidDelayTap1:setDelay(gMidDelayTime)
	elseif command == EFFECT_MID_DELAY_FEEDBACK then
		gMidDelayFeedback = valueNumber/100.0
		gMidDelay:setFeedback(gMidDelayFeedback)
	elseif command == EFFECT_MID_DELAY_MIX then
		gMidDelayVolume = valueNumber/200.0--max 0.5 delay volume
		gMidDelayTap1:setVolume(gMidDelayVolume)
	elseif command == EFFECT_DELAY_TIME then
		gDelayTime = map(valueNumber, 0, 100, 0.0, gDelayMax)
		gDelayTap1:setDelay(gDelayTime)
	elseif command == EFFECT_DELAY_FEEDBACK then
		gDelayFeedback = valueNumber/100.0
		gDelay:setFeedback(gDelayFeedback)
	elseif command == EFFECT_DELAY_MIX then
		gDelayVolume = valueNumber/200.0--max 0.5 delay volume
		gDelayTap1:setVolume(gDelayVolume)
	elseif command == EFFECT_BITCRUSHER_AMOUNT then
		gBitcrusherAmount = valueNumber/100.0
		gBitcrusher:setAmount(gBitcrusherAmount)
	elseif command == EFFECT_BITCRUSHER_UNDERSAMPLE then
		gBitcrusherUndersample = valueNumber/100.0
		gBitcrusherMix = 0.0
		gBitcrusher:setUndersampling(gBitcrusherUndersample)
	elseif command == EFFECT_BITCRUSHER_MIX then
		gBitcrusherMix = valueNumber/100.0
		gBitcrusher:setMix(gBitcrusherMix)
	elseif command == EFFECT_LOWPASS_FREQ then
		gLowPassFreq = map(valueNumber, 0, 100, gLowPassFreqMin, gLowPassFreqMax)
		gLowPass:setFrequency(gLowPassFreq)
	elseif command == EFFECT_LOWPASS_RESONANCE then
		gLowPassRes = valueNumber/100.0
		gLowPass:setResonance(gLowPassRes)
	elseif command == EFFECT_LOWPASS_MIX then
		gLowPassMix = valueNumber/100.0
		gLowPass:setMix(gLowPassMix)
	elseif command == EFFECT_HIGHPASS_FREQ then
		gHighPassFreq = map(valueNumber, 0, 100, gHighPassFreqMin, gHighPassFreqMax)
		gHighPass:setFrequency(gHighPassFreq)
	elseif command == EFFECT_HIGHPASS_RESONANCE then
		gHighPassRes = valueNumber/100.0
		gHighPass:setResonance(gHighPassRes)
	elseif command == EFFECT_HIGHPASS_MIX then
		gHighPassMix = valueNumber/100.0
		gHighPass:setMix(gHighPassMix)
	elseif command == EFFECT_OVERDRIVE_GAIN then
		gOverdriveGain = map(valueNumber, 0, 100, 0.0, gOverdriveGainMax)
		gOverdrive:setGain(gOverdriveGain)
	elseif command == EFFECT_OVERDRIVE_LIMIT then
		gOverdriveLimit = map(valueNumber, 0, 100, 0.0, gOverdriveLimitMax)
		gOverdrive:setLimit(gOverdriveLimit)
	elseif command == EFFECT_OVERDRIVE_MIX then
		gOverdriveMix = valueNumber/100.0
		gOverdrive:setMix(gOverdriveMix)
	elseif command == EFFECT_RINGMOD_FREQ then
		gRingmodFreq = map(valueNumber, 0, 100, gRingmodFreqMin, gRingmodFreqMax)
		gRingmod:setFrequency(gRingmodFreq)
	elseif command == EFFECT_RINGMOD_MIX then
		gRingmodMix = valueNumber/100.0
		gRingmod:setMix(gRingmodMix)
	end
	
	if gShowSerialLog then
		table.insert(serialLog, message)
		
		if #serialLog > 12 then
			table.remove(serialLog,1)
		end
	end
end

-- END OF EFFECTS-------------------------------------------------------------

local introLabelSprite = gfx.sprite.spriteWithText("Resonance", 400, 20)



local leftDown = false
local rightDown = false
local upDown = false
local downDown = false

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
		showingMenu = true
		playerDialog:show(
			playerNodes[activePlayerNode],
			activePlayerNode,
			function()
				--onDismiss
				showingMenu = false
			end,
			function()
				--onSetOrbit
				playerNodes[activePlayerNode]:move(0, 0)--removes orbit
				showingMenu = false
				orbitConfig:show(
					function()
						--onDismiss
					end,
					function(oX, oY, pX, pY)
						--onSetOrbit
						playerNodes[activePlayerNode]:moveTo(pX, pY)
						playerNodes[activePlayerNode]:setActiveOrbit(oX, oY, 20, 1)
					end
				)
			end,
			function()
				--onToggleDirection
				showingMenu = false
				playerNodes[activePlayerNode]:toggleDirection()
			end,
			function()
				--onSetOscillator
				showingMenu = false
				playerNodes[activePlayerNode]:move(0, 0)--removes orbit
				oscillatorConfig:show(
					function()
						--onDismiss
					end,
					function(oX, oY, pX, pY)
						--onSetOscillator
						print("set osc: " .. oX .. "." .. oY .. " and " .. pX .. "." .. pY)
						playerNodes[activePlayerNode]:moveTo(pX, pY)
						playerNodes[activePlayerNode]:setActiveOscillator(oX, oY, pX, pY, 20)
					end
				)
			end,
			function()
				--onSetVelocity
				showingMenu = false
				VelocityDialog():show(
					playerNodes[activePlayerNode],
					function()
						--onDismiss
					end,
					function(velocity)
						--onSetVelocity
						playerNodes[activePlayerNode]:setVelocity(velocity)
					end
				)
			end,
			function()
				--onRemove
				--todo confirmation dialog?
				showingMenu = false
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
		showingMenu = true
		nodeDialog:show(
			nodes[activeNode],
			function ()
				-- onDismiss
				--showingMenu = false
				nodeDidHold = true
				showingMenu = false
			end,
			function (waveform)
				--onWaveform
				--showingMenu = false
				nodeDidHold = true
				showingMenu = false
				nodes[activeNode]:setWaveform(waveform)
				nodes[activeNode]:select()
				activeNodeLabel:updateNode(nodes[activeNode])
			end,
			function()
				--onRemove
				showingMenu = false
				if #nodes > 1 then
					nodes[activeNode]:stop()
					table.remove(nodes, activeNode)
					activeNode = 1
					nodes[activeNode]:select()
					activeNodeLabel:updateNode(nodes[activeNode])
					nodeCount = #nodes
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
			if #playerNodes > 0 then playerNodes[activePlayerNode]:crank(change) end
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
	
	nodeCount = #nodes
	
	--empty players table
	for k, v in pairs(playerNodes) do 
		v:stop()
		playerNodes[k] = nil 
	end
	
	for k, v in pairs(patch.players) do
		local playerNode = PlayerNode(geom.point.new(v.x, v.y), v.size)
		if v.mode ~= nil and v.mode == 1 then
			playerNode:setActiveOrbit(
				v.orbitX, 
				v.orbitY,
				v.velocity,
				v.orbitStartAngle
			)
			if v.orbitDirection ~= nil and v.orbitDirection == -1 then
				playerNode:toggleDirection()
			end
		elseif v.mode ~= nil and v.mode == 2 then
			playerNode:setActiveOscillator(
				v.oscStartPointX,
				v.oscStartPointY,
				v.oscEndPointX,
				v.oscEndPointY,
				v.velocity
			)
 		end
		 table.insert(playerNodes, playerNode)
	end
	
	introLabelSprite:setScale(1)
	introLabelSprite:moveTo(355, 10)
	
	if #playerNodes > 0 then
		activePlayerNode = 1
		playerNodes[1]:setActive(true)
	else

	end
	
	setLabelsVisible(true)
end

function showNodesMenu()
	showingMenu = true
	
	nodesDialog:show(
		function()
			--onDismiss
			showingMenu = false 
		end,
		function ()
			--onAddPlayerNode
			showingMenu = false 
			local playerNode = PlayerNode(geom.point.new(200, 120), 65, nil, nil, 1)
		  table.insert(playerNodes, playerNode)
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
			nodes[newIndex] = Node(geom.point.new(200, 120), 60)--table.insert duh
			setLabelsVisible(true)
			nodeCount = #nodes
			
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
		end,
		function()
			--onEffects
			showingMenu = true
			-- EffectsDialog():show(
			-- 	function() 
			-- 		--onDismiss
			-- 		showingMenu = false 
			-- 	end
			-- )
			
			FullEffectsDialog():show(
				function() 
					--onDismiss
					showingMenu = false 
				end
			)
		end,
		function()
			--onSerialLogToggle
			gShowSerialLog = not gShowSerialLog
		end,
		function()
			--onSerialPatchSend
			showingMenu = false 
			serialPatchSend()
		end
	)
end

local patchResetSent = false 
local serialPlayerIndex = 0
local serialNoteIndex = 0
local serialPatchDelayMs = 125
function serialPatchSend()
	if not patchResetSent then
		print("< " .. LOAD_PATCH)
		patchResetSent = true
		serialPlayerIndex = 0
		serialNoteIndex = 0
		playdate.timer.performAfterDelay(serialPatchDelayMs, function() 
			serialPatchSend()
		 end
	  )
	elseif serialPlayerIndex < #playerNodes then
		serialPlayerIndex += 1
		local player = playerNodes[serialPlayerIndex]
		print("< " .. ADD_PLAYER .. " " .. player.p.x .. " " .. player.p.y .. " " .. (player.size/4))
		playdate.timer.performAfterDelay(serialPatchDelayMs, function() 
			serialPatchSend()
		 end)
	elseif serialNoteIndex < #nodes then
		serialNoteIndex += 1
		local node = nodes[serialNoteIndex]
		print("< " .. ADD_NOTE .. " " .. node.p.x .. " " .. node.p.y .. " " .. node.midiNote)
		playdate.timer.performAfterDelay(serialPatchDelayMs, function() 
			serialPatchSend()
		 end)
	else
		patchResetSent = false
		serialPlayerIndex = 0
		serialNoteIndex = 0
	end
end

function setup()
	local backgroundImage = gfx.image.new( "images/background" )
	assert( backgroundImage )
	
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
		
	local helpMenu, error = menu:addMenuItem("Help", 
		function()
			showingMenu = true
			HelpDialog():show(function()
				showingMenu = false
				end
			)
		end
	)
	
	local invertMenu, error = menu:addMenuItem("Invert", 
		function()
			if playdate.display.getInverted() then
				playdate.display.setInverted(false)
			else
				playdate.display.setInverted(true)
			end
		end
	)
	
	loadPatch(Presets():defaultPatch())
	
	introLabelSprite:moveTo(310, 220)
	introLabelSprite:setScale(2)
	introLabelSprite:add()
	
	setLabelsVisible(true)
end

setup()

function map(value, start1, stop1, start2, stop2)
	return start2 + (stop2 - start2) * ((value - start1) / (stop1 - start1))
end

function playdate.update()
	gfx.sprite.update()
	
	playdate.timer.updateTimers()
	
	if orbitConfig.showing then
		orbitConfig:checkKeys()
	elseif oscillatorConfig.showing then
		oscillatorConfig:checkKeys()
	else
		if(leftDown) then
			if(activeNode > 0) then
				nodes[activeNode]:move(-stepSize, 0)
				activeNodeLabel:updateNode(nodes[activeNode])
			else
				playerNodes[activePlayerNode]:move(-stepSize, 0)
			end
		end
		if(rightDown) then
			if(activeNode > 0) then
				nodes[activeNode]:move(stepSize, 0)
				activeNodeLabel:updateNode(nodes[activeNode])
			else
				playerNodes[activePlayerNode]:move(stepSize, 0)
			end
		end
		if(upDown) then
			if(activeNode > 0) then
				nodes[activeNode]:move(0, -stepSize)
				activeNodeLabel:updateNode(nodes[activeNode])
			else
				playerNodes[activePlayerNode]:move(0, -stepSize)
			end
		end
		if(downDown) then
			if(activeNode > 0) then
				nodes[activeNode]:move(0, stepSize)
				activeNodeLabel:updateNode(nodes[activeNode])
			else
				playerNodes[activePlayerNode]:move(0, stepSize)
			end
		end
	end
	
	updateNodes()
	if not showingMenu then
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
	
	if gShowSerialLog then
		local serialLogLine = 1
		for _,message in pairs(serialLog) do
		gfx.drawText(message, 5, 8 + (serialLogLine * 16))
		serialLogLine += 1
		end
	end
end

function updateNodes()
		for i = 1,nodeCount,1 do 
			local node = nodes[i]
			node:checkPlayers(playerNodes) 
			local playerCount = #playerNodes
			for p = 1, playerCount, 1 do 
				local player = playerNodes[p]
				player:updateOrbitOrOsc()
				if not showingMenu then
					if(node.p:distanceToPoint(player.p) < player.size) then
						gfx.drawLine(node.p.x, node.p.y, player.p.x, player.p.y)
					end
				end
			end
		end
end