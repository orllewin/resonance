import "midi"

class('Presets').extends()

local midi = Midi()

function Presets:init()
		Presets.super.init(self)
		
end

function Presets:synths()
	return {
		self:chromaCircle1("ChromaCircle", false)
	}
end

function Presets:sequencers()
	return presets()--todo
end

function Presets:defaultPatch()
	return self:chromaCircle1("--", true)
end

function Presets:presets()
	return {
		self:new(),
		self:chromaCircle1("ChromaCircle", false),
		self:mixolydian1(),
		self:cropCircles(),
		self:cMaj(),
		self:dorian1(),
		self:orlDrone(),
		self:pentatonic1(),
		self:rhubarb(),
	}
end

function Presets:newPatch()
	return {
		name = "--",
		waveform = "Sine",
		nodes = {
			{
				midiNote = 60,
				x = 50,
				y = 60
			},
			{
				midiNote = 60,
				x = 100,
				y = 120
			},
			{
				midiNote = 60,
				x = 150,
				y = 60
			},
			{
				midiNote = 60,
				x = 200,
				y = 120
			},
			{
				midiNote = 60,
				x = 250,
				y = 60
			},
			{
				midiNote = 60,
				x = 300,
				y = 120
			},
			{
				midiNote = 60,
				x = 350,
				y = 60
			}
		},
		players = {
			{
				x = 200,
				y = 180,
				size = 66,
				isOrbiting = false,
				orbitX = 166,
				orbitY = 120,
				orbitVelocity = 12,
				orbitStartAngle = 210
			},
		}
	}
end

function Presets:chromaCircle1(title, isStartup)
	local playerY = 180
	if isStartup then
		playerY = 60
	end
	return {
		name = title,
		waveform = "Vosim",
		nodes = {
			{
				midiNote = 65,
				x = 50,
				y = 60
			},
			{
				midiNote = 69,
				x = 150,
				y = 60
			},
			{
				midiNote = 67,
				x = 250,
				y = 60
			},
			{
				midiNote = 64,--E4
				x = 250,
				y = 60
			},
			{
				midiNote = 74,--D5
				x = 100,
				y = 120
			},
			{
				midiNote = 62,--D4
				x = 200,
				y = 120
			},
			{
				midiNote = 72,--C5
				x = 300,
				y = 120
			},
			{
				midiNote = 50,--D3 (bottom row)
				x = 50,
				y = 180
			},
			{
				midiNote = 70,--A#4 (bottom row)
				x = 150,
				y = 180
			},
			{
				midiNote = 69,--A4 (bottom row)
				x = 250,
				y = 180
			},
		},
		players = {
				{
					x = 350,
					y = playerY,
					size = 66,
					isOrbiting = false,
					orbitX = 166,
					orbitY = 120,
					orbitVelocity = 12,
					orbitStartAngle = 210
				},
		}
	}
end

function Presets:cropCircles()
	return {
		name = "Crop Circles",
		nodes = {
			{
				midiNote = 60,
				x = 67,
				y = 120,
				waveform = "Vosim"
			},
			{
				midiNote = 45,
				x = 167,
				y = 63,
				waveform = "Vosim"
			},
			{
				midiNote = 55,
				x = 167,
				y = 176,
				waveform = "Vosim"
			},
			{
				midiNote = 45,
				x = 233,
				y = 47,
				waveform = "Vosim"
			},
			{
				midiNote = 45,
				x = 233,
				y = 195,
				waveform = "Vosim"
			},
			{
				midiNote = 50,
				x = 267,
				y = 120,
				waveform = "Vosim"
			},
			{
				midiNote = 60,
				x = 300,
				y = 34,
				waveform = "Vosim"
			},
			{
				midiNote = 67,
				x = 300,
				y = 205,
				waveform = "Vosim"
			},
			{
				midiNote = 64,
				x = 333,
				y = 120,
				waveform = "Vosim"
			}
		},
		players = {
			{
				x = 66,
				y = 120,
				size = 66,
				isOrbiting = true,
				orbitX = 133,
				orbitY = 120,
				orbitVelocity = 9,
				orbitStartAngle = 210
			},
			{
				x = 66,
				y = 120,
				size = 66,
				isOrbiting = true,
				orbitX = 166,
				orbitY = 120,
				orbitVelocity = 12,
				orbitStartAngle = 210
			},
			{
				x = 66,
				y = 120,
				size = 132,
				isOrbiting = true,
				orbitX = 200,
				orbitY = 120,
				orbitVelocity = 15,
				orbitStartAngle = 210
			}
		}
		
	}
end

function Presets:orlDrone()
	return {
		name = "Orl Drone",
		nodes = {
			{
				midiNote = 67,
				x = 29,
				y = 50,
				waveform = "Triangle"
			},
			{
				midiNote = 72,
				x = 98,
				y = 152,
				waveform = "Triangle"
			},
			{
				midiNote = 69,
				x = 170,
				y = 52,
				waveform = "Triangle"
			},
			{
				midiNote = 69,
				x = 219,
				y = 112,
				waveform = "Triangle"
			},
			{
				midiNote = 60,
				x = 319,
				y = 60,
				waveform = "Triangle"
			},
			{
				midiNote = 67,
				x = 303,
				y = 186,
				waveform = "Triangle"
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
		nodes = {
			{
				midiNote = 60,
				x = 45,
				y = 160,
				waveform = "Triangle"
			},
			{
				midiNote = 64,
				x = 74,
				y = 77,
				waveform = "Triangle"
			},
			{
				midiNote = 52,
				x = 118,
				y = 188,
				waveform = "Triangle"
			},
			{
				midiNote = 57,
				x = 163,
				y = 82,
				waveform = "Triangle"
			},
			{
				midiNote = 60,
				x = 248,
				y = 156,
				waveform = "Triangle"
			},
			{
				midiNote = 57,
				x = 272,
				y = 48,
				waveform = "Triangle"
			},
			{
				midiNote = 69,
				x = 340,
				y = 137,
				waveform = "Triangle"
			},
			{
				midiNote = 67,
				x = 348,
				y = 72,
				waveform = "Triangle"
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

function Presets:new()
	local preset = {}
	preset.name = "8 nodes 1 inducer"
	local nodes = {}
	nodes[1] = {
				midiNote = 60,
				x = 22,
				y = 22,
				waveform = "Sine"
			}
	nodes[2] = {
				midiNote = 60,
				x = 22,
				y = 50,
				waveform = "Sine"
			}
	nodes[3] = {
				midiNote = 60,
				x = 22,
				y = 78,
				waveform = "Sine"
			}
	nodes[4] = {
				midiNote = 60,
				x = 22,
				y = 106,
				waveform = "Sine"
			}
	nodes[5] = {
				midiNote = 60,
				x = 22,
				y = 134,
				waveform = "Sine"
			}
	nodes[6] = {
				midiNote = 60,
				x = 22,
				y = 162,
				waveform = "Sine"
			}
	nodes[7] = {
				midiNote = 60,
				x = 22,
				y = 190,
				waveform = "Sine"
			}
	nodes[8] = {
				midiNote = 60,
				x = 22,
				y = 218,
				waveform = "Sine"
			}
		
	preset.nodes = nodes
	
	local players = {}
	local player1 = {}
	player1.x = 133
	player1.y = 120
	player1.size = 100
	player1.isOrbiting = false
	player1.orbitX = 200
	player1.orbitY = 120
	player1.orbitVelocity = 25
	player1.orbitStartAngle = 1
	players[1] = player1

	preset.players = players

	return preset
end

function Presets:rhubarb()
	local preset = {}
	preset.name = "Rhubarb"
	local nodes = {}
	
	local n1 = {}
	n1.midiNote = 66
	n1.x = 314
	n1.y = 62
	n1.waveform = "Vosim"
	nodes[1] = n1
	
	local n2 = {}
	n2.midiNote = 50
	n2.x = 270
	n2.y = 96
	n2.waveform = "Vosim"
	nodes[2] = n2
	
	local n3 = {}
	n3.midiNote = 54
	n3.x = 256
	n3.y = 150
	n3.waveform = "Vosim"
	nodes[3] = n3
	
	local n4 = {}
	n4.midiNote = 61
	n4.x = 312
	n4.y = 178
	n4.waveform = "Vosim"
	nodes[4] = n4
	
	local n5 = {}
	n5.midiNote = 64
	n5.x = 171
	n5.y = 210
	n5.waveform = "Vosim"
	nodes[5] = n5
	
	local n6 = {}
	n6.midiNote = 59
	n6.x = 92
	n6.y = 158
	n6.waveform = "Vosim"
	nodes[6] = n6
	
	local n7 = {}
	n7.midiNote = 52
	n7.x = 145
	n7.y = 128
	n7.waveform = "Vosim"
	nodes[7] = n7
	
	local n8 = {}
	n8.midiNote = 57
	n8.x = 113
	n8.y = 73
	n8.waveform = "Vosim"
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

	preset.players = players
	return preset
end

function Presets:pentatonic1()
	local preset = {}
	preset.name = "Pentatonic"
	local scale = midi:generateScale(24, "Pentatonic Major")
	preset.nodes = {
		self:nodespecialSequence(1, scale[27], "Sawtooth"), 
		self:nodespecialSequence(2, scale[25], "Sawtooth"), 
		self:nodespecialSequence(3, scale[22], "Sawtooth"), 
		self:nodespecialSequence(4, scale[28], "Sawtooth"), 
		self:nodespecialSequence(5, scale[16], "Sawtooth"), 
		self:nodespecialSequence(6, scale[14], "Sawtooth"), 
		self:nodespecialSequence(7, scale[18], "Sawtooth"), 
		self:nodespecialSequence(8, scale[22], "Sawtooth")
	}
	
	local players = {}
	local player1 = {}
	player1.x = 120
	player1.y = 120
	player1.size = 125
	player1.isOrbiting = true
	player1.orbitX = 0
	player1.orbitY = 120
	player1.orbitVelocity = 25
	player1.orbitStartAngle = 1
	players[1] = player1
	
	local player2 = {}
	player2.x = 250
	player2.y = 120
	player2.size = 75
	player2.isOrbiting = true
	player2.orbitX = 300
	player2.orbitY = 120
	player2.orbitVelocity = 25
	player2.orbitStartAngle = 1
	players[2] = player2
	
	preset.players = players
	
	return preset
end

function Presets:dorian1()
	local preset = {}
	preset.name = "Dorian"
	local scale = midi:generateScale(36, "Dorian")
	preset.nodes = {
		self:noteTwoSquares(1, scale[27], "Triangle"), 
		self:noteTwoSquares(2, scale[25], "Triangle"), 
		self:noteTwoSquares(3, scale[13], "Triangle"), 
		self:noteTwoSquares(4, scale[13], "Triangle"), 
		self:noteTwoSquares(5, scale[16], "Triangle"), 
		self:noteTwoSquares(6, scale[22], "Triangle"), 
		self:noteTwoSquares(7, scale[24], "Triangle"), 
		self:noteTwoSquares(8, scale[26], "Triangle")
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
	local scale = midi:generateScale(36, "Mixolydian")
	preset.nodes = {
		self:noteDefaultPoint(1, scale[27], "Vosim"), 
		self:noteDefaultPoint(2, scale[25], "Vosim"), 
		self:noteDefaultPoint(3, scale[13], "Vosim"), 
		self:noteDefaultPoint(4, scale[13], "Vosim"), 
		self:noteDefaultPoint(5, scale[16], "Vosim"), 
		self:noteDefaultPoint(6, scale[22], "Vosim"), 
		self:noteDefaultPoint(7, scale[24], "Vosim"), 
		self:noteDefaultPoint(8, scale[26], "Vosim")
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

function Presets:noteDefaultPoint(index, midiNote, waveform)
	local note = {}
	note.midiNote = midiNote
	note.waveform = waveform
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

function Presets:noteTwoSquares(index, midiNote, waveform)
	local note = {}
	note.midiNote = midiNote
	note.waveform = waveform 
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

function Presets:nodespecialSequence(index, midiNote, waveform)
	local note = {}
	note.waveform = waveform
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