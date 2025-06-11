import "midi"

class('Presets').extends()

local midi = Midi()

function Presets:init()
		Presets.super.init(self)
		
end

function Presets:presets()
	
	local presets = {}

	presets[1] = self:mixolydian1()
	presets[2] = self:dorian1()
	presets[3] = self:pentatonic1()
	presets[4] = self:harmonic1()
	presets[5] = self:rhubarb()
	
	return presets
end

function Presets:rhubarb()
	local preset = {}
	preset.name = "Rhubarb"
	preset.waveform = "Vosim"
	local notes = {}
	
	local n1 = {}
	n1.midiNote = 66
	n1.x = 314
	n1.y = 62
	notes[1] = n1
	
	local n2 = {}
	n2.midiNote = 50
	n2.x = 270
	n2.y = 96
	notes[2] = n2
	
	local n3 = {}
	n3.midiNote = 54
	n3.x = 256
	n3.y = 150
	notes[3] = n3
	
	local n4 = {}
	n4.midiNote = 61
	n4.x = 312
	n4.y = 178
	notes[4] = n4
	
	local n5 = {}
	n5.midiNote = 64
	n5.x = 171
	n5.y = 210
	notes[5] = n5
	
	local n6 = {}
	n6.midiNote = 59
	n6.x = 92
	n6.y = 158
	notes[6] = n6
	
	local n7 = {}
	n7.midiNote = 52
	n7.x = 145
	n7.y = 128
	notes[7] = n7
	
	local n8 = {}
	n8.midiNote = 57
	n8.x = 120
	n8.y = 61
	notes[8] = n8
	
	preset.notes = notes
	
	local player1 = {}
	player1.x = 304
	player1.y = 110
	player1.size = 100
	player1.orbitActive = true
	player1.orbitX = 209
	player1.orbitY = 110
	player1.orbitVelocity = 80
	preset.player1 = player1
	
	local player2 = {}
	player2.x = 12
	player2.y = 12
	player2.size = 12
	player2.orbitActive = false
	player2.orbitX = 12
	player2.orbitY = 12
	player2.orbitVelocity = 12
	preset.player2 = player2
	
	return preset
end

function Presets:pentatonic1()
	local preset = {}
	preset.name = "Pentatonic"
	preset.waveform = "Sawtooth"
	local scale = midi:generateScale(24, "Pentatonic Major")
	preset.notes = {
		self:noteSpecialSequence(1, scale[27]), 
		self:noteSpecialSequence(2, scale[25]), 
		self:noteSpecialSequence(3, scale[22]), 
		self:noteSpecialSequence(4, scale[28]), 
		self:noteSpecialSequence(5, scale[16]), 
		self:noteSpecialSequence(6, scale[14]), 
		self:noteSpecialSequence(7, scale[18]), 
		self:noteSpecialSequence(8, scale[22])
	}
	
	local player1 = {}
	player1.x = 120
	player1.y = 120
	player1.size = 125
	player1.orbitActive = true
	player1.orbitX = 0
	player1.orbitY = 120
	player1.orbitVelocity = 120
	preset.player1 = player1
	
	local player2 = {}
	player2.x = 250
	player2.y = 120
	player2.size = 75
	player2.orbitActive = true
	player2.orbitX = 300
	player2.orbitY = 120
	player2.orbitVelocity = 80
	preset.player2 = player2
	
	return preset
end


function Presets:harmonic1()
	local harmonicPreset = {}
	harmonicPreset.name = "Harmonic"
	harmonicPreset.waveform = "Phase"
	local scale = midi:generateScale(36, "Harmonic Major")
	harmonicPreset.notes = {
		self:noteTwoSquares(1, scale[27]), 
		self:noteTwoSquares(2, scale[25]), 
		self:noteTwoSquares(3, scale[22]), 
		self:noteTwoSquares(4, scale[28]), 
		self:noteTwoSquares(5, scale[16]), 
		self:noteTwoSquares(6, scale[14]), 
		self:noteTwoSquares(7, scale[18]), 
		self:noteTwoSquares(8, scale[22])
	}
	
	local player1 = {}
	player1.x = 66
	player1.y = 120
	player1.size = 125
	player1.orbitActive = true
	player1.orbitX = 132
	player1.orbitY = 120
	player1.orbitVelocity = 120
	harmonicPreset.player1 = player1
	
	local player2 = {}
	player2.x = 250
	player2.y = 120
	player2.size = 75
	player2.orbitActive = true
	player2.orbitX = 300
	player2.orbitY = 120
	player2.orbitVelocity = 80
	harmonicPreset.player2 = player2
	
	return harmonicPreset
end

function Presets:dorian1()
	local dorianPreset = {}
	dorianPreset.name = "Dorian"
	dorianPreset.waveform = "Triangle"
	local scale = midi:generateScale(36, "Dorian")
	dorianPreset.notes = {
		self:noteTwoSquares(1, scale[27]), 
		self:noteTwoSquares(2, scale[25]), 
		self:noteTwoSquares(3, scale[13]), 
		self:noteTwoSquares(4, scale[13]), 
		self:noteTwoSquares(5, scale[16]), 
		self:noteTwoSquares(6, scale[22]), 
		self:noteTwoSquares(7, scale[24]), 
		self:noteTwoSquares(8, scale[26])
	}
	
	local player1 = {}
	player1.x = 67
	player1.y = 120
	player1.size = 90
	player1.orbitActive = true
	player1.orbitX = 100
	player1.orbitY = 120
	player1.orbitVelocity = 120
	dorianPreset.player1 = player1
	
	local player2 = {}
	player2.x = 333
	player2.y = 120
	player2.size = 100
	player2.orbitActive = true
	player2.orbitX = 300
	player2.orbitY = 120
	player2.orbitVelocity = 80
	dorianPreset.player2 = player2
	
	return dorianPreset
end

function Presets:mixolydian1()
	local dorianPreset = {}
	dorianPreset.name = "Mixolydian"
	dorianPreset.waveform = "Vosim"
	local scale = midi:generateScale(36, "Mixolydian")
	dorianPreset.notes = {
		self:noteDefaultPoint(1, scale[27]), 
		self:noteDefaultPoint(2, scale[25]), 
		self:noteDefaultPoint(3, scale[13]), 
		self:noteDefaultPoint(4, scale[13]), 
		self:noteDefaultPoint(5, scale[16]), 
		self:noteDefaultPoint(6, scale[22]), 
		self:noteDefaultPoint(7, scale[24]), 
		self:noteDefaultPoint(8, scale[26])
	}
	
	local player1 = {}
	player1.x = 33
	player1.y = 120
	player1.size = 160
	player1.orbitActive = true
	player1.orbitX = 200
	player1.orbitY = 120
	player1.orbitVelocity = 120
	dorianPreset.player1 = player1
	
	local player2 = {}
	player2.x = 200
	player2.y = 60
	player2.size = 100
	player2.orbitActive = true
	player2.orbitX = 200
	player2.orbitY = 120
	player2.orbitVelocity = 80
	dorianPreset.player2 = player2
	
	return dorianPreset
end

function Presets:noteDefaultPoint(index, midiNote)
	local note = {}
	note.midiNote = midiNote
	if index == 1 then
		note.x = 66
		note.y = 60
	elseif index == 2 then
		note.x = 66
		note.y = 180
	elseif index == 3 then
		note.x = 133
		note.y = 120
	elseif index == 4 then
		note.x = 200
		note.y = 60
	elseif index == 5 then
		note.x = 200
		note.y = 180
	elseif index == 6 then
		note.x = 266
		note.y = 120
	elseif index == 7 then
		note.x = 333
		note.y = 60
	elseif index == 8 then
		note.x = 333
		note.y = 180
	end
	
	return note
end

function Presets:noteTwoSquares(index, midiNote)
	local note = {}
	note.midiNote = midiNote
	if index == 1 then
		note.x = 58
		note.y = 74
	elseif index == 2 then
		note.x = 58
		note.y = 166
	elseif index == 3 then
		note.x = 142
		note.y = 74
	elseif index == 4 then
		note.x = 142
		note.y = 166
	elseif index == 5 then
		note.x = 260
		note.y = 74
	elseif index == 6 then
		note.x = 260
		note.y = 166
	elseif index == 7 then
		note.x = 342
		note.y = 74
	elseif index == 8 then
		note.x = 342
		note.y = 166
	end
	
	return note
end

function Presets:noteSpecialSequence(index, midiNote)
	local note = {}
	note.midiNote = midiNote
	if index == 1 then
		note.x = 63
		note.y = 120
	elseif index == 2 then
		note.x = 110
		note.y = 74
	elseif index == 3 then
		note.x = 120
		note.y = 120
	elseif index == 4 then
		note.x = 110
		note.y = 166
	elseif index == 5 then
		note.x = 300
		note.y = 74
	elseif index == 6 then
		note.x = 250
		note.y = 120
	elseif index == 7 then
		note.x = 300
		note.y = 166
	elseif index == 8 then
		note.x = 342
		note.y = 120
	end
	
	return note
end