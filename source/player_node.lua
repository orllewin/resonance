local gfx <const> = playdate.graphics
local diam = 16

local Mode = {
	manual = 0,
	orbit = 1,
	osc = 2
}

class('PlayerNode').extends()

function PlayerNode:init(p, size)
		PlayerNode.super.init(self)
		
		self.p = p
		
		--orbit
		self.orbitPoint = p:copy()
		self.velocity = 6.0
		self.orbitDirection = 1
		self.orbitDegree = 320
		
		--oscillator
		self.oscStartPoint = p:copy()
		self.oscEndPoint = p:copy()
		self.oscDirection = 1
		
		self.size = size
						
		self.sprite = gfx.sprite.new()
		self.sprite:moveTo(self.p.x, self.p.y)
		self.sprite:add()
				
		self.orbitOrbitSprite = gfx.sprite.new()
		self.orbitOrbitSprite:moveTo(self.orbitPoint.x, self.orbitPoint.y)
		
		local arrowImage = gfx.image.new("images/focus_indicator")
		self.activeSprite = gfx.sprite.new(arrowImage)
		
		self:crank(0)
		
		self.mode = Mode.manual
end

function PlayerNode:randomise()
	self.p.x = math.random(10, 390)
	self.p.y = math.random(10, 230)
	self:move(0, 0)
	
	self.size = math.random(10, 100)
	self:crank(0)
	
	local oX = self.p.x + math.random(-100, 100)
	local direction = 1
	if math.random(100) < 50 then
		direction = -1
	end
	
	self:setActiveOrbit(oX, self.p.y, math.random(5, 30), math.random(1, 360))
end

function PlayerNode:toggleDirection()
	if self.orbitDirection == 1 then
		self.orbitDirection = -1
	elseif self.orbitDirection == -1 then
		self.orbitDirection = 1
	end
end

function PlayerNode:stop()
	self.sprite:remove()
  self.orbitOrbitSprite:remove()
	self.activeSprite:remove()
end

function PlayerNode:setActive(isActive)
	self.isActive = isActive
	if isActive then
		self.activeSprite:add()
	else
		self.activeSprite:remove()
	end
	self:crank(0)
	self:move(0, 0)
end

function PlayerNode:setActiveOscillator(sX, sY, eX, eY, velocity)
	if(sX < eX) then
		self.oscStartPoint.x = sX
		self.oscStartPoint.y = sY
		self.oscEndPoint.x = eX
		self.oscEndPoint.y = eY
	else
		self.oscStartPoint.x = eX
		self.oscStartPoint.y = eY
		self.oscEndPoint.x = sX
		self.oscEndPoint.y = sY
	end
	self.velocity = velocity
	self.oscDirection = 1
	self:moveTo(self.oscStartPoint.x, self.oscStartPoint.y)
	self.mode = Mode.osc
end

function PlayerNode:setActiveOrbit(x, y, velocity, angle)
	self.orbitPoint.x = x
	self.orbitPoint.y = y
	self.velocity = velocity
	self.orbitDegree = angle

	self:moveOrigin(0,0)
	
	local orbitRadius = math.max(3, self.orbitPoint:distanceToPoint(self.p))
	local orbitOrbitImage = gfx.image.new(orbitRadius * 2 + 6, orbitRadius * 2 + 6)
	gfx.pushContext(orbitOrbitImage)
	gfx.setColor(gfx.kColorBlack)
	gfx.setLineWidth(5)
	gfx.setDitherPattern(0.8, gfx.image.kDitherTypeScreen)
	gfx.drawCircleAtPoint(orbitRadius + 3, orbitRadius + 3, orbitRadius)
	gfx.popContext()
	self.orbitOrbitSprite:setImage(orbitOrbitImage)
	
	self.orbitOrbitSprite:moveTo(self.orbitPoint.x, self.orbitPoint.y)
	self.orbitOrbitSprite:add()
	
	self.mode = Mode.orbit
end

function PlayerNode:moveOrigin(x, y)
	self.orbitPoint.x = self.orbitPoint.x + x
	self.orbitPoint.y = self.orbitPoint.y + y
	self.orbitOrbitSprite:moveTo(self.orbitPoint.x, self.orbitPoint.y)
end

function PlayerNode:setVelocity(velocity)
	self.velocity = velocity
end

function PlayerNode:crank(change)
	self.size = math.max(self.size + change, 4)
	local image = gfx.image.new(self.size, self.size)
	gfx.pushContext(image)
	gfx.setColor(gfx.kColorBlack)
	gfx.setLineWidth(1)
	
	if(self.isActive) then
		gfx.fillCircleAtPoint(self.size/2, self.size/2, diam/2)
	else
		gfx.drawCircleAtPoint(self.size/2, self.size/2, diam/2)
	end
	
	
	gfx.setLineWidth(3)
	gfx.drawCircleAtPoint(self.size/2, self.size/2, self.size/2 - 3)
	gfx.popContext()
	
	self.sprite:setImage(image)
end

function PlayerNode:setSize(size)
	self.size = size
	self:crank(0)
end

function PlayerNode:moveTo(x, y)
	self.p.x = x
	self.p.y = y
	self:move(0,0)
end

function PlayerNode:move(x, y)
	if x ~= 0 or y ~= 0 then
		if self.mode == Mode.orbit then
			self.orbitOrbitSprite:remove()
			self.mode = Mode.manual
		elseif self.mode == Mode.osc then
			self.mode = Mode.manual
		end
	end
	
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
	
	if self.isActive then
		self.activeSprite:moveTo(self.p.x, self.p.y - 16)
	end
end

function PlayerNode:updateOrbitOrOsc()
	if self.mode == Mode.orbit then
		local origin = self.orbitPoint
		local radius = self.orbitPoint:distanceToPoint(self.p)
		local velocity = self.velocity
		
		if self.orbitDegree == nil then self.orbitDegree = 1 end
		local angle = (self.orbitDegree * self:map(self.velocity, 1, 100, 0.01, 1.0)) * math.pi / 180

		if(self.orbitDirection == 1) then
			self.orbitDegree += 1
			if angle > 6.283 then self.orbitDegree = 0 end
		else
			self.orbitDegree -= 1
			if angle < -6.283 then self.orbitDegree = 0 end
		end

		local x = origin.x + radius * math.cos( angle )
		local y = origin.y + radius * math.sin( angle )
		self.p.x = x
		self.p.y = y
		self.sprite:moveTo(self.p.x, self.p.y)
		
		if self.isActive then
			self.activeSprite:moveTo(self.p.x, self.p.y - 16)
		end
	elseif self.mode == Mode.osc then
		local x = self.p.x
		
		local increment = self:map(self.velocity, 1, maxVelocity, 0.15, 1.75)
		if self.oscDirection == 1 then
			--moving right
			
			x += increment
			if x > self.oscEndPoint.x then
				self.oscDirection = -1
			end
		else
			--moving left
			x -= increment
			if x < self.oscStartPoint.x then
				self.oscDirection = 1
			end
		end
		self.p.x = x
		self.p.y = self.oscEndPoint.y
		self.sprite:moveTo(self.p.x, self.p.y)
		
		if self.isActive then
			self.activeSprite:moveTo(self.p.x, self.p.y - 16)
		end
	end
end

function PlayerNode:map(value, start1, stop1, start2, stop2)
	return start2 + (stop2 - start2) * ((value - start1) / (stop1 - start1))
end

function PlayerNode:getState()
	local saveState = {}
	saveState.x = self.p.x
	saveState.y = self.p.y
	saveState.size = self.size
	saveState.mode = self.mode
	saveState.velocity = self.velocity
	saveState.orbitX = self.orbitPoint.x
	saveState.orbitY = self.orbitPoint.y
	saveState.oscStartPointX = self.oscStartPoint.x
	saveState.oscStartPointY = self.oscStartPoint.y
	saveState.oscEndPointX = self.oscEndPoint.x
	saveState.oscEndPointY = self.oscEndPoint.y
	return saveState
end