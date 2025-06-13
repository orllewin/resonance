import "midi"

class('Presets').extends()

local midi = Midi()

function Presets:init()
		Presets.super.init(self)
		
end

function Presets:presets()
	return {
		self:new(),
		self:mixolydian1(),
		self:cMaj(),
		self:dorian1(),
		self:orlDrone(),
		self:pentatonic1(),
		self:rhubarb(),
		self:stopLookListen()
	}
end

function Presets:orlDrone()
	return {
		name = "Orl Drone",
		waveform = "Triangle",
		nodes = {
			{
				midiNote = 67,
				x = 29,
				y = 50
			},
			{
				midiNote = 72,
				x = 98,
				y = 152
			},
			{
				midiNote = 69,
				x = 170,
				y = 52
			},
			{
				midiNote = 69,
				x = 219,
				y = 112
			},
			{
				midiNote = 60,
				x = 319,
				y = 60
			},
			{
				midiNote = 67,
				x = 303,
				y = 186
			},
			{
				midiNote = 60,
				x = 14,
				y = 229
			},
			{
				midiNote = 60,
				x = 67,
				y = 229
			}
		},
		players = {
			{
				x = 128,
				y = 80,
				size = 75,
				isOrbiting = true,
				orbitX = 103,
				orbitY = 80,
				orbitVelocity = 20,
				orbitStartAngle = 210
			},
			{
				x = 316,
				y = 117,
				size = 75,
				isOrbiting = true,
				orbitX = 296,
				orbitY = 117,
				orbitVelocity = 18,
				orbitStartAngle = 1
			}
		}
	}
end

function Presets:cMaj()
	return {
		name = "C Major",
		waveform = "Triangle",
		nodes = {
			{
				midiNote = 60,
				x = 45,
				y = 160
			},
			{
				midiNote = 64,
				x = 74,
				y = 77
			},
			{
				midiNote = 52,
				x = 118,
				y = 188
			},
			{
				midiNote = 57,
				x = 163,
				y = 82
			},
			{
				midiNote = 60,
				x = 248,
				y = 156
			},
			{
				midiNote = 57,
				x = 272,
				y = 48
			},
			{
				midiNote = 69,
				x = 340,
				y = 137
			},
			{
				midiNote = 67,
				x = 348,
				y = 72
			}
		},
		players = {
			{
				x = 135,
				y = 123,
				size = 75,
				isOrbiting = true,
				orbitX = 116,
				orbitY = 123,
				orbitVelocity = 25,
				orbitStartAngle = 210
			},
			{
				x = 309,
				y = 105,
				size = 60,
				isOrbiting = true,
				orbitX = 292,
				orbitY = 105,
				orbitVelocity = 28,
				orbitStartAngle = 1
			}
		}
	}
end

function Presets:stopLookListen()
	return {
		name = "Stop, Look, Listen",
		waveform = "Triangle",
		nodes = {
			{
				midiNote = 76,
				x = 280,
				y = 109
			},
			{
				midiNote = 74,
				x = 268,
				y = 145
			},
			{
				midiNote = 73,
				x = 240,
				y = 169
			},
			{
				midiNote = 69,
				x = 196,
				y = 179
			},
			{
				midiNote = 74,
				x = 128,
				y = 103
			},
			{
				midiNote = 72,
				x = 144,
				y = 61
			},
			{
				midiNote = 71,
				x = 178,
				y = 35
			},
			{
				midiNote = 67,
				x = 218,
				y = 31
			}
		},
		players = {
			{
				x = 267,
				y = 103,
				size = 30,
				isOrbiting = true,
				orbitX = 206,
				orbitY = 103,
				orbitVelocity = 130,
				orbitStartAngle = 210
			},
			{
				x = 10,
				y = 20,
				size = 5,
				isOrbiting = false,
				orbitX = 10,
				orbitY = 20,
				orbitVelocity = 75,
				orbitStartAngle = 1
			}
		}
	}
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
	player1.orbitVelocity = 12
	player1.orbitStartAngle = 350
	players[1] = player1
	
	local player2 = {}
	player2.x = 12
	player2.y = 22
	player2.size = 12
	player2.isOrbiting = false
	player2.orbitX = 12
	player2.orbitY = 22
	player2.orbitVelocity = 1
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
	player1.orbitVelocity = 20
	player1.orbitStartAngle = 1
	players[1] = player1
	
	local player2 = {}
	player2.x = 333
	player2.y = 120
	player2.size = 100
	player2.isOrbiting = true
	player2.orbitX = 300
	player2.orbitY = 120
	player2.orbitVelocity = 28
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
	player1.orbitVelocity = 20
	player1.orbitStartAngle = 1
	players[1] = player1
	
	local player2 = {}
	player2.x = 200
	player2.y = 60
	player2.size = 100
	player2.isOrbiting = true
	player2.orbitX = 200
	player2.orbitY = 120
	player2.orbitVelocity = 15
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