local gfx <const> = playdate.graphics
local diam = 12
local selectedDiam = 18

class('Node').extends()

function Node:init(p, midiNote)
		Node.super.init(self)
		
		self.p = p
		self.midiNote = midiNote
		
		self.crankDelta = 0 
		
		local image = gfx.image.new(diam, diam)
		gfx.pushContext(image)
		gfx.setColor(gfx.kColorBlack)
		gfx.fillCircleAtPoint(diam/2, diam/2, diam/2)
		gfx.popContext()
		
		self.sprite = gfx.sprite.new(image)
		self.sprite:moveTo(self.p.x, self.p.y)
		self.sprite:add()
		
		self.label = gfx.sprite.spriteWithText(midi:label(self.midiNote), 1000, 1000)
		self.label:moveTo(self.p.x + diam, self.p.y)
		
		local arrowImage = gfx.image.new("images/focus_indicator")
		self.activeSprite = gfx.sprite.new(arrowImage)
		
		self.synth = playdate.sound.synth.new(playdate.sound.kWaveTriangle)
		gChannel:addSource(self.synth)
		self.waveform = "Triangle"
		self.synth:setADSR(0.5, 0.5, 1.0, 2.0)
		self.synth:playMIDINote(self.midiNote)
		self.synth:setVolume(0)
		
		
end

function Node:octaveUp()
	if self.midiNote < 115 then
		self.midiNote += 12
	end
	self:crank(0)
end

function Node:octaveDown()
	if self.midiNote >= 12 then
		self.midiNote -= 12
	end
	self:crank(0)
end

function Node:randomise()
	self.p.x = math.random(10, 390)
	self.p.y = math.random(10, 230)
	self.size = math.random(10, 100)
	self:moveTo(self.p.x, self.p.y)
end

function Node:stop()
	self.sprite:remove()
	self.label:remove()
	self.activeSprite:remove()
	self.synth:stop()
	self.synth = nil
end

function Node:labelVisible(visible)
	if(visible) then
		self:select()
		self:deselect()
		self.label:add()
	else
		self.label:remove()
	end
end

function Node:setWaveform(waveform)
	self.waveform = waveform
	if waveform == "Sine" then
		self.synth:setWaveform(playdate.sound.kWaveSine)
	elseif waveform == "Square" then
		self.synth:setWaveform(playdate.sound.kWaveSquare)
	elseif waveform == "Sawtooth" then
		self.synth:setWaveform(playdate.sound.kWaveSawtooth)
	elseif waveform == "Triangle" then
		self.synth:setWaveform(playdate.sound.kWaveTriangle)	
	elseif waveform == "Phase" then
		self.synth:setWaveform(playdate.sound.kWavePOPhase)		
	elseif waveform == "Digital" then
		self.synth:setWaveform(playdate.sound.kWavePODigital)			
	elseif waveform == "Vosim" then
		self.synth:setWaveform(playdate.sound.kWavePOVosim)
	elseif waveform == "Noise" then
		self.synth:setWaveform(playdate.sound.kWaveNoise)				
	end	
end

function Node:checkPlayers(players)
	local playerCount = #players
	
	local closestDistance = 600
	
  local distances = {}
	local ranges = {}	
	
	local withinRange = false
	
	for p = 1, playerCount, 1 do
		local player = players[p]
		local distance =  self.p:distanceToPoint(player.p)
		if distance < player.size then
			table.insert(distances, distance)
			table.insert(ranges, player.size)
			withinRange = true
		end
		
		if distance < closestDistance then
			closestDistance = distance
		end
	end

	if(not withinRange) then
		self.synth:noteOff()
	else
		
		local volume = 0
		local playersInRange = #distances
		
		for i = 1,playersInRange,1 do
			local playerVolume = self:map(distances[i], ranges[i], 0, 0.0, 1.0)
			volume += playerVolume
		end
		
		self.synth:setVolume((math.min(volume, 1.0))/nodeCount)
		
		--self.synth:setVolume(self:map(closestDistance, 0, 100, 1.0, 0.0)/nodeCount)
		if(not self.synth:isPlaying()) then
			self.synth:playMIDINote(self.midiNote)
		end
		
		--Accelerometer
		if self.waveform == "Vosim" or self.waveform == "Phase" or self.waveform == "Digital" then
			local x, y, _z = playdate.readAccelerometer()
			self.synth:setParameter(1, self:map(x, -1.0, 1.0, 0.0, 1.0))
			self.synth:setParameter(2, self:map(y, -1.0, 1.0, 0.0, 1.0))
		end
	end
end

function Node:map(value, start1, stop1, start2, stop2)
	return start2 + (stop2 - start2) * ((value - start1) / (stop1 - start1))
end

function Node:crank(change)
	self.crankDelta += change
	if(change == 0) then
		--do nothing
	elseif(self.crankDelta > 10) then
		self.midiNote = math.max (1, self.midiNote - 1)
		self.crankDelta = 0
	elseif(self.crankDelta < -10) then
		self.midiNote = math.min (127, self.midiNote + 1)
		self.crankDelta = 0
	end
	
	local image = gfx.imageWithText(midi:label(self.midiNote), 1000, 1000)
	self.label:setImage(image)
	
	self:updateLabelPosition()
	
	self.synth:playMIDINote(self.midiNote)

end

function Node:chooseRandomNote(notes)
	local randIndex = math.floor(math.random(1, 30))
	local randNote = notes[randIndex]
	print("randNote: " .. randNote)
	self:setNote(randNote)
end

function Node:setNote(midiNote)
	self.midiNote = midiNote
	self.synth:playMIDINote(self.midiNote)
	self:deselect()
	self:crank(0)
end

function Node:select()
	local image = gfx.image.new(selectedDiam, selectedDiam)
	gfx.pushContext(image)
	gfx.setColor(gfx.kColorBlack)
	gfx.drawCircleAtPoint(selectedDiam/2, selectedDiam/2, selectedDiam/2)
	gfx.fillCircleAtPoint(selectedDiam/2, selectedDiam/2, diam/2)
	gfx.popContext()
	self.sprite:setImage(image)

	self:updateLabelPosition()
	
	self.activeSprite:moveTo(self.p.x, self.p.y - 16)
	self.activeSprite:add()
end

function Node:updateLabelPosition()
	if self.p.x > 360 then
		self.label:moveTo(self.p.x - selectedDiam - self.sprite.width/2, self.p.y)
	else
		self.label:moveTo(self.p.x + selectedDiam + self.sprite.width/2, self.p.y)
	end
end

function Node:deselect()
	local image = gfx.image.new(diam, diam)
	gfx.pushContext(image)
	gfx.setColor(gfx.kColorBlack)
	gfx.fillCircleAtPoint(diam/2, diam/2, diam/2)
	gfx.popContext()
	self.sprite:setImage(image)
	self.activeSprite:remove()
end

function Node:moveTo(x, y)
	self.p.x = x
	self.p.y = y
	self:move(0, 0)
end

function Node:move(x, y)
	self.p.x = self.p.x + x
	self.p.y = self.p.y + y
	
	if(self.p.x < 0) then
		self.p.x = 0
	end
	if(self.p.x > 400) then
		self.p.x = 400
	end
	if(self.p.y < 0) then
		self.p.y = 0
	end
	if(self.p.y > 240) then
		self.p.y = 240
	end
	self.sprite:moveTo(self.p.x, self.p.y)
	self:updateLabelPosition()
	self.activeSprite:moveTo(self.p.x, self.p.y - 16)
end

function Node:getState()
	local saveState = {}
	saveState.x = self.p.x
	saveState.y = self.p.y
	saveState.midiNote = self.midiNote
	
	return saveState
end