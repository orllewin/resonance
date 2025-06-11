class('Rect').extends()

function Rect:init(startX, startY, endX, endY)
		Node.super.init(self)
		
		self.startX = startX
		self.startY = startY
		
		self.endX = endX
		self.endY = endY
end