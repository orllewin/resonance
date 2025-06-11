import "CoreLibs/sprites"
import "CoreLibs/graphics"

local gfx <const> = playdate.graphics
local diam = 12
local selectedDiam = 18

class('Node').extends()

function Node:init(p, midiNote)
		Node.super.init(self)
		
		self.p = p
		self.midiNote = midiNote
		
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
		
		self.synth = playdate.sound.synth.new(playdate.sound.kWaveTriangle)
		self.synth:setADSR(0.5, 0.5, 1.0, 2.0)
		self.synth:playMIDINote(self.midiNote)
		self.synth:setVolume(0)
end

function Node:labelVisible(visible)
	if(visible) then
		self:select()
		self.label:add()
	else
		self.label:remove()
	end
end

function Node:setWaveform(waveform)
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
	end	
end

function Node:checkPlayers(players)
	local distanceA = self.p:distanceToPoint(players[1].p)
	local distanceB = self.p:distanceToPoint(players[2].p)
	if(distanceA > players[1].size and distanceB > players[2].size) then
		self.synth:noteOff()
	else
		self.synth:setVolume(self:map(math.min(distanceA, distanceB), 0, 100, 1.0, 0.0)/10.0)
		if(not self.synth:isPlaying()) then
			self.synth:playMIDINote(self.midiNote)
		end
		
		--Accelerometer
		if waveform == "Vosim" or waveform == "Phase" or waveform == "Digital" then
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
	if(change> 0) then
		self.midiNote = math.max (1, self.midiNote - 1)
	elseif(change < 0) then
		self.midiNote = math.min (127, self.midiNote + 1)
	end
	local image = gfx.imageWithText(midi:label(self.midiNote), 1000, 1000)
	self.label:setImage(image)
	self.label:moveTo(self.p.x + selectedDiam + image.width/2, self.p.y)
	self.synth:playMIDINote(self.midiNote)
end

function Node:setNote(midiNote)
	self.midiNote = midiNote
	self.synth:playMIDINote(self.midiNote)
end

function Node:select()
	local image = gfx.image.new(selectedDiam, selectedDiam)
	gfx.pushContext(image)
	gfx.setColor(gfx.kColorBlack)
	gfx.drawCircleAtPoint(selectedDiam/2, selectedDiam/2, selectedDiam/2)
	gfx.fillCircleAtPoint(selectedDiam/2, selectedDiam/2, diam/2)
	gfx.popContext()
	self.sprite:setImage(image)
	self.label:moveTo(self.p.x + selectedDiam + image.width/2, self.p.y)
end

function Node:deselect()
	local image = gfx.image.new(diam, diam)
	gfx.pushContext(image)
	gfx.setColor(gfx.kColorBlack)
	gfx.fillCircleAtPoint(diam/2, diam/2, diam/2)
	gfx.popContext()
	self.sprite:setImage(image)
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
	self.label:moveTo(self.p.x + selectedDiam + self.label.width/2, self.p.y)
end