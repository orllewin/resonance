class('Point').extends()

function Point:init(x, y)
		Node.super.init(self)
		
		self.x = x
		self.y = y
end