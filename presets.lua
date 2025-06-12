import "midi"

class('Presets').extends()

local midi = Midi()

function Presets:init()
		Presets.super.init(self)
		
end

function Presets:presets()
	
	local presets = {}
	presets[1] = self:new()
	presets[2] = self:mixolydian1()
	presets[3] = self:dorian1()
	presets[4] = self:pentatonic1()
	presets[5] = self:harmonic1()
	presets[6] = self:rhubarb()
	
	return presets
end

function Presets:new()
	local preset = {}
	preset.name = "--"
	preset.waveform = "Sine"
	local nodes = {}
	nodes[1] = {
				midiNote = 60,
				x = 22,
				y = 22
			}
	nodes[2] = {
				midiNote = 60,
				x = 22,
				y = 50
			}
	nodes[3] = {
				midiNote = 60,
				x = 22,
				y = 78
			}
	nodes[4] = {
				midiNote = 60,
				x = 22,
				y = 106
			}
	nodes[5] = {
				midiNote = 60,
				x = 22,
				y = 134
			}
	nodes[6] = {
				midiNote = 60,
				x = 22,
				y = 162
			}
	nodes[7] = {
				midiNote = 60,
				x = 22,
				y = 190
			}
	nodes[8] = {
				midiNote = 60,
				x = 22,
				y = 218
			}
		
	preset.nodes = nodes
	
	local players = {}
	local player1 = {}
	player1.x = 133
	player1.y = 120
	player1.size = 100
	player1.isOrbiting = false
	player1.orbitX = 133
	player1.orbitY = 120
	player1.orbitVelocity = 75
	player1.orbitStartAngle = 1
	players[1] = player1

	local player2 = {}
	player2.x = 266
	player2.y = 120
	player2.size = 100
	player2.isOrbiting = false
	player2.orbitX = 266
	player2.orbitY = 120
	player2.orbitVelocity = 75
	player2.orbitStartAngle = 350
	players[2] = player2
	
	preset.players = players

	return preset
end

function Presets:rhubarb()
	local preset = {}
	preset.name = "Rhubarb"
	preset.waveform = "Vosim"
	local nodes = {}
	
	local n1 = {}
	n1.midiNote = 66
	n1.x = 314
	n1.y = 62
	nodes[1] = n1
	
	local n2 = {}
	n2.midiNote = 50
	n2.x = 270
	n2.y = 96
	nodes[2] = n2
	
	local n3 = {}
	n3.midiNote = 54
	n3.x = 256
	n3.y = 150
	nodes[3] = n3
	
	local n4 = {}
	n4.midiNote = 61
	n4.x = 312
	n4.y = 178
	nodes[4] = n4
	
	local n5 = {}
	n5.midiNote = 64
	n5.x = 171
	n5.y = 210
	nodes[5] = n5
	
	local n6 = {}
	n6.midiNote = 59
	n6.x = 92
	n6.y = 158
	nodes[6] = n6
	
	local n7 = {}
	n7.midiNote = 52
	n7.x = 145
	n7.y = 128
	nodes[7] = n7
	
	local n8 = {}
	n8.midiNote = 57
	n8.x = 113
	n8.y = 73
	nodes[8] = n8
	
	preset.nodes = nodes
	
	local players = {}
	local player1 = {}
	player1.x = 304
	player1.y = 110
	player1.size = 100
	player1.isOrbiting = true
	player1.orbitX = 209
	player1.orbitY = 110
	player1.orbitVelocity = 95
	player1.orbitStartAngle = 350
	players[1] = player1
	
	local player2 = {}
	player2.x = 12
	player2.y = 22
	player2.size = 12
	player2.isOrbiting = false
	player2.orbitX = 12
	player2.orbitY = 12
	player2.orbitVelocity = 12
	player2.orbitStartAngle = 1
	players[2] = player2
	preset.players = players
	return preset
end

function Presets:pentatonic1()
	local preset = {}
	preset.name = "Pentatonic"
	preset.waveform = "Sawtooth"
	local scale = midi:generateScale(24, "Pentatonic Major")
	preset.nodes = {
		self:nodespecialSequence(1, scale[27]), 
		self:nodespecialSequence(2, scale[25]), 
		self:nodespecialSequence(3, scale[22]), 
		self:nodespecialSequence(4, scale[28]), 
		self:nodespecialSequence(5, scale[16]), 
		self:nodespecialSequence(6, scale[14]), 
		self:nodespecialSequence(7, scale[18]), 
		self:nodespecialSequence(8, scale[22])
	}
	
	local players = {}
	local player1 = {}
	player1.x = 120
	player1.y = 120
	player1.size = 125
	player1.isOrbiting = true
	player1.orbitX = 0
	player1.orbitY = 120
	player1.orbitVelocity = 120
	player1.orbitStartAngle = 1
	players[1] = player1
	
	local player2 = {}
	player2.x = 250
	player2.y = 120
	player2.size = 75
	player2.isOrbiting = true
	player2.orbitX = 300
	player2.orbitY = 120
	player2.orbitVelocity = 80
	player2.orbitStartAngle = 1
	players[2] = player2
	
	preset.players = players
	
	return preset
end


function Presets:harmonic1()
	local preset = {}
	preset.name = "Harmonic"
	preset.waveform = "Phase"
	local scale = midi:generateScale(36, "Harmonic Major")
	preset.nodes = {
		self:noteTwoSquares(1, scale[27]), 
		self:noteTwoSquares(2, scale[25]), 
		self:noteTwoSquares(3, scale[22]), 
		self:noteTwoSquares(4, scale[28]), 
		self:noteTwoSquares(5, scale[16]), 
		self:noteTwoSquares(6, scale[14]), 
		self:noteTwoSquares(7, scale[18]), 
		self:noteTwoSquares(8, scale[22])
	}
	
	local players = {}
	local player1 = {}
	player1.x = 66
	player1.y = 120
	player1.size = 125
	player1.isOrbiting = true
	player1.orbitX = 132
	player1.orbitY = 120
	player1.orbitVelocity = 120
	player1.orbitStartAngle = 1
	players[1] = player1
	
	local player2 = {}
	player2.x = 250
	player2.y = 120
	player2.size = 75
	player2.isOrbiting = true
	player2.orbitX = 300
	player2.orbitY = 120
	player2.orbitVelocity = 80
	player2.orbitStartAngle = 1
	players[2] = player2
	
	preset.players = players
	
	return preset
end

function Presets:dorian1()
	local preset = {}
	preset.name = "Dorian"
	preset.waveform = "Triangle"
	local scale = midi:generateScale(36, "Dorian")
	preset.nodes = {
		self:noteTwoSquares(1, scale[27]), 
		self:noteTwoSquares(2, scale[25]), 
		self:noteTwoSquares(3, scale[13]), 
		self:noteTwoSquares(4, scale[13]), 
		self:noteTwoSquares(5, scale[16]), 
		self:noteTwoSquares(6, scale[22]), 
		self:noteTwoSquares(7, scale[24]), 
		self:noteTwoSquares(8, scale[26])
	}
	
	local players = {}
	local player1 = {}
	player1.x = 67
	player1.y = 120
	player1.size = 90
	player1.isOrbiting = true
	player1.orbitX = 100
	player1.orbitY = 120
	player1.orbitVelocity = 120
	player1.orbitStartAngle = 1
	players[1] = player1
	
	local player2 = {}
	player2.x = 333
	player2.y = 120
	player2.size = 100
	player2.isOrbiting = true
	player2.orbitX = 300
	player2.orbitY = 120
	player2.orbitVelocity = 80
	player2.orbitStartAngle = 1
	players[2] = player2
	
	preset.players = players
	
	return preset
end

function Presets:mixolydian1()
	local preset = {}
	preset.name = "Mixolydian"
	preset.waveform = "Vosim"
	local scale = midi:generateScale(36, "Mixolydian")
	preset.nodes = {
		self:noteDefaultPoint(1, scale[27]), 
		self:noteDefaultPoint(2, scale[25]), 
		self:noteDefaultPoint(3, scale[13]), 
		self:noteDefaultPoint(4, scale[13]), 
		self:noteDefaultPoint(5, scale[16]), 
		self:noteDefaultPoint(6, scale[22]), 
		self:noteDefaultPoint(7, scale[24]), 
		self:noteDefaultPoint(8, scale[26])
	}
	
	local players = {}
	local player1 = {}
	player1.x = 33
	player1.y = 120
	player1.size = 160
	player1.isOrbiting = true
	player1.orbitX = 200
	player1.orbitY = 120
	player1.orbitVelocity = 120
	player1.orbitStartAngle = 1
	players[1] = player1
	
	local player2 = {}
	player2.x = 200
	player2.y = 60
	player2.size = 100
	player2.isOrbiting = true
	player2.orbitX = 200
	player2.orbitY = 120
	player2.orbitVelocity = 80
	player2.orbitStartAngle = 1
	players[2] = player2
	preset.players = players
	return preset
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

function Presets:nodespecialSequence(index, midiNote)
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