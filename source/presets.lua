import "midi"

class('Presets').extends()

local midi = Midi()

function Presets:init()
		Presets.super.init(self)
		
end

function Presets:defaultPatch()
	--return self:chromaCircle1("--", true)
	return self:origin()
end

function Presets:synths()
	return {
		{
			label = "Synths:::",
			type = "category_title"
		},
		self:origin(),
		self:chromaCircle1("ChromaCircle", false),
		self:lydianGrid(),
		self:new(),
	}
end

function Presets:sequencers()
	return {
		{
			label = "Sequencers:::",
			type = "category_title"
		},
		self:mixolydian1(),
		self:cropCircles(),
		self:dualOscillator(),
		self:cMaj(),
		self:popolVuh(),
		self:pentatonic1(),
		self:rhubarb(),
	}
end

function Presets:newPatch()
	return {
		name = "--",
		waveform = "Sine",
		nodes = {
			{ midiNote = 60, x = 50, y = 60 },
			{ midiNote = 60, x = 100, y = 120 },
			{ midiNote = 60, x = 150, y = 60 },
			{ midiNote = 60, x = 200, y = 120 },
			{ midiNote = 60, x = 250, y = 60 },
			{ midiNote = 60, x = 300, y = 120 },
			{ midiNote = 60, x = 350, y = 60 }
		},
		players = {
			{
				x = 200,
				y = 180,
				size = 66
			},
		}
	}
end

function Presets:origin()
	return {
		name = "Origin",
		waveform = "Triangle",
		nodes = {
			{ midiNote = 60, x = 66, y = 55 },
			{ midiNote = 60, x = 200, y = 55 },
			{ midiNote = 65, x = 333, y = 55 },
			
			{ midiNote = 53, x = 130, y = 115 },
			{ midiNote = 60, x = 264, y = 115 },
			
			{ midiNote = 62, x = 66, y = 175 },
			{ midiNote = 48, x = 200, y = 175 },
			{ midiNote = 69, x = 333, y = 175 },
		},
		players = {
				{
					x = 159,
					y = 75,
					size = 80
				},
				{
					x = 150,
					y = 174,
					size = 70
				}
		}
	}
end

function Presets:dualOscillator()
	return {
		name = "Dual Oscillator",
		waveform = "Vosim",
		nodes = {
			{ midiNote = 40, x = 50, y = 60 },
			{ midiNote = 48, x = 150, y = 60 },
			{ midiNote = 50, x = 250, y = 60 },
			
			{ midiNote = 60, x = 100, y = 120 },
			{ midiNote = 77, x = 200, y = 120 },
			{ midiNote = 81, x = 300, y = 120 },
			
			{ midiNote = 65, x = 50, y = 180 },
			{ midiNote = 79, x = 150, y = 180 },
			{ midiNote = 72, x = 250, y = 180 },
		},
		players = {
				{
					x = 100,
					y = 100,
					size = 90,
					mode = 2,
					velocity = 12,
					oscStartPointX = 20,
					oscStartPointY = 70,
					oscEndPointX = 380,
					oscEndPointY = 70
				},
				{
					x = 100,
					y = 200,
					size = 120,
					mode = 2,
					velocity = 14,
					oscStartPointX = 20,
					oscStartPointY = 160,
					oscEndPointX = 380,
					oscEndPointY = 160
				}
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
			{ midiNote = 64, x = 50, y = 60 },
			{ midiNote = 69, x = 150, y = 60 },
			{ midiNote = 65, x = 250, y = 60 },
			
			{ midiNote = 72, x = 100, y = 120 },
			{ midiNote = 62, x = 200, y = 120 },
			{ midiNote = 74, x = 300, y = 120 },
			
			{ midiNote = 69, x = 50, y = 180 },
			{ midiNote = 70, x = 150, y = 180 },
			{ midiNote = 50, x = 250, y = 180 },
		},
		players = {
				{
					x = 350,
					y = playerY,
					size = 66
				},
		}
	}
end

function Presets:lydianGrid()
	local s = midi:generateScale(48, "Lydian")
	return {
		name = "Lydian Grid",
		waveform = "Vosim",
		nodes = {
			{ midiNote = s[1], x = 49, y = 30 },
			{ midiNote = s[3], x = 110, y = 30 },
			{ midiNote = s[5], x = 168, y = 30 },
			{ midiNote = s[7], x = 229, y = 30 },
			{ midiNote = s[9], x = 287, y = 30 },
			{ midiNote = s[11], x = 344, y = 30 },
			
			{ midiNote = s[12], x = 20, y = 76 },
			{ midiNote = s[14], x = 81, y = 76 },
			{ midiNote = s[16], x = 141, y = 76 },
			{ midiNote = s[18], x = 202, y = 76 },
			{ midiNote = s[20], x = 258, y = 76 },
			{ midiNote = s[22], x = 319, y = 76 },
			
			{ midiNote = s[2], x = 49, y = 120 },
			{ midiNote = s[4], x = 110, y = 120 },
			{ midiNote = s[6], x = 168, y = 120 },
			{ midiNote = s[8], x = 229, y = 120 },
			{ midiNote = s[10], x = 287, y = 120 },
			{ midiNote = s[12], x = 344, y = 120 },
			
			{ midiNote = s[23], x = 20, y = 163 },
			{ midiNote = s[25], x = 81, y = 163 },
			{ midiNote = s[27], x = 141, y = 163 },
			{ midiNote = s[29], x = 202, y = 163 },
			{ midiNote = s[31], x = 258, y = 163 },
			{ midiNote = s[33], x = 319, y = 163 },
			
			{ midiNote = s[14], x = 49, y = 208 },
			{ midiNote = s[16], x = 110, y = 208 },
			{ midiNote = s[18], x = 168, y = 208 },
			{ midiNote = s[20], x = 229, y = 208 },
			{ midiNote = s[22], x = 287, y = 208 },
			{ midiNote = s[24], x = 344, y = 208 },
		},
		players = {
				{
					x = 374,
					y = 162,
					size = 56
				},
		}
	}
end

function Presets:cropCircles()
	return {
		name = "Crop Circle",
		waveform = "Vosim",
		nodes = {
			{ midiNote = 60, x = 67, y = 120 },
			{ midiNote = 45, x = 167, y = 63 },
			{ midiNote = 55, x = 167, y = 176 },
			{ midiNote = 45, x = 233, y = 47 },
			{ midiNote = 45, x = 233, y = 195 },
			{ midiNote = 50, x = 267, y = 120 },
			{ midiNote = 60, x = 300, y = 34 },
			{ midiNote = 67, x = 300, y = 205 },
			{ midiNote = 64, x = 333, y = 120 }
		},
		players = {
			{
				x = 66,
				y = 120,
				size = 66,
				mode = 1,
				orbitX = 133,
				orbitY = 120,
				velocity = 9,
				orbitStartAngle = 210
			},
			{
				x = 66,
				y = 120,
				size = 66,
				mode = 1,
				orbitX = 166,
				orbitY = 120,
				velocity = 12,
				orbitStartAngle = 210
			},
			{
				x = 66,
				y = 120,
				size = 132,
				mode = 1,
				orbitX = 200,
				orbitY = 120,
				velocity = 15,
				orbitStartAngle = 210
			}
		}
		
	}
end

function Presets:popolVuh()
	return {
		name = "Popol Vuh",
		waveform = "Triangle",
		nodes = {
			{ midiNote = 67, x = 29, y = 50, },
			{ midiNote = 72, x = 98, y = 152 },
			{ midiNote = 69, x = 170, y = 52 },
			{ midiNote = 69, x = 219, y = 112 },
			{ midiNote = 60, x = 319, y = 60 },
			{ midiNote = 67, x = 303, y = 186 }
		},
		players = {
			{
				x = 128,
				y = 80,
				size = 75,
				mode = 1,
				orbitX = 103,
				orbitY = 80,
				velocity = 20,
				orbitStartAngle = 210
			},
			{
				x = 316,
				y = 117,
				size = 75,
				mode = 1,
				orbitDirection = -1,
				orbitX = 296,
				orbitY = 117,
				velocity = 18,
				orbitStartAngle = 1
			}
		}
	}
end

function Presets:cMaj()
	return {
		name = "Meditate",
		waveform = "Triangle",
		nodes = {
			{ midiNote = 60, x = 45, y = 160 },
			{ midiNote = 64, x = 74, y = 77 },
			{ midiNote = 52, x = 118, y = 188 },
			{ midiNote = 57, x = 163, y = 82 },
			{ midiNote = 60, x = 248, y = 156 },
			{ midiNote = 57, x = 272, y = 48 },
			{ midiNote = 69, x = 340, y = 137},
			{ midiNote = 67, x = 348, y = 72 }
		},
		players = {
			{
				x = 135,
				y = 123,
				size = 75,
				mode = 1,
				orbitX = 116,
				orbitY = 123,
				velocity = 22,
				orbitStartAngle = 210
			},
			{
				x = 309,
				y = 105,
				size = 60,
				mode = 1,
				orbitX = 292,
				orbitY = 105,
				velocity = 25,
				orbitDirection = -1,
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
	player1.mode = 1
	player1.orbitX = 209
	player1.orbitY = 110
	player1.velocity = 12
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
	player1.mode = 1
	player1.orbitX = 0
	player1.orbitY = 120
	player1.velocity = 25
	player1.orbitStartAngle = 1
	players[1] = player1
	
	local player2 = {}
	player2.x = 250
	player2.y = 120
	player2.size = 75
	player2.mode = 1
	player2.orbitX = 300
	player2.orbitY = 120
	player2.velocity = 25
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
	player1.mode = 1
	player1.orbitX = 200
	player1.orbitY = 120
	player1.velocity = 20
	player1.orbitStartAngle = 1
	players[1] = player1
	
	local player2 = {}
	player2.x = 200
	player2.y = 60
	player2.size = 100
	player2.mode = 1
	player2.orbitX = 200
	player2.orbitY = 120
	player2.velocity = 15
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