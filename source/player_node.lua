import "CoreLibs/sprites"
import "CoreLibs/graphics"

local gfx <const> = playdate.graphics
local diam = 16

class('PlayerNode').extends()

function PlayerNode:init(p, size, orbitOrigin, orbitVelocity, orbitDirection)
		PlayerNode.super.init(self)
		
		self.p = p
		self.orbitPoint = p:copy()
		if(orbitOrigin ~= nil) then
			self.orbitPoint.x = orbitOrigin.x
			self.orbitPoint.y = orbitOrigin.y
		end

		self.orbitVelocity = orbitVelocity
		if self.orbitVelocity == nil then self.orbitVelocity = 3 end
		
		self.orbitDirection = orbitDirection
		if self.orbitDirection == nil then self.orbitDirection = 1 end

		self.orbitDegree = 320
		
		self.size = size
		self.isOriginMode = false
				
		self.sprite = gfx.sprite.new()
		self.sprite:moveTo(self.p.x, self.p.y)
		self.sprite:add()
		
		local originImage = gfx.image.new(8, 8)
		gfx.pushContext(originImage)
		gfx.setColor(gfx.kColorBlack)
		gfx.drawCircleAtPoint(4, 4, 4)
		gfx.popContext()
		self.orbitOriginSprite = gfx.sprite.new(originImage)
		self.orbitOriginSprite:moveTo(self.p.x, self.p.y)
		
		local orbitVelocityImage = gfx.image.new(2, math.max(3, self.orbitVelocity))
		gfx.pushContext(orbitVelocityImage)
		gfx.setColor(gfx.kColorBlack)
		gfx.fillRect(0, 0, 2, self.orbitVelocity)
		gfx.popContext()
		self.orbitVelcitySprite = gfx.sprite.new(orbitVelocityImage)
		self.orbitVelcitySprite:moveTo(self.p.x, self.p.y)
		
		local orbitRadius = math.max(3, self.orbitPoint:distanceToPoint(self.p))
		local orbitOrbitImage = gfx.image.new(orbitRadius*2, orbitRadius*2)
		gfx.pushContext(orbitOrbitImage)
		gfx.setColor(gfx.kColorBlack)
		gfx.drawCircleAtPoint(orbitRadius, orbitRadius, orbitRadius)
		gfx.popContext()
		self.orbitOrbitSprite = gfx.sprite.new(orbitOrbitImage)
		self.orbitOrbitSprite:moveTo(self.orbitPoint.x, self.orbitPoint.y)
		
		self:crank(0)
		
		if(orbitVelocity ~= nil and orbitVelocity > 0 and orbitOrigin ~= nil) then
			self.orbitOrbitSprite:moveTo(self.orbitPoint.x, self.orbitPoint.y)
			self.orbitOrbitSprite:add()
			self:moveOrigin(0,0)
			self:setOriginMode(false)
		else
			self.isOrbiting = false
		end
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

function PlayerNode:stop()
	self.sprite:remove()
	self.orbitOriginSprite:remove()
	self.orbitVelcitySprite:remove()
	self.orbitOrbitSprite:remove()
end

function PlayerNode:setActive(isActive)
	self.isActive = isActive
	self:crank(0)
end

function PlayerNode:setActiveOrbit(x, y, velocity, angle)
	self.orbitPoint.x = x
	self.orbitPoint.y = y
	self.orbitVelocity = velocity
	self.orbitDegree = angle
	self.orbitOrbitSprite:moveTo(self.orbitPoint.x, self.orbitPoint.y)
	self.orbitOrbitSprite:add()
	self:moveOrigin(0,0)
	self:setOriginMode(false)
end

function PlayerNode:setOriginMode(isOriginMode)
	self.isOriginMode = isOriginMode
	
	if isOriginMode then
		self.orbitPoint.x = self.p.x
		self.orbitPoint.y = self.p.y
		self.orbitOriginSprite:moveTo(self.orbitPoint.x, self.orbitPoint.y)
		self.orbitVelcitySprite:moveTo(self.orbitPoint.x, self.orbitPoint.y)
		self.orbitOrbitSprite:moveTo(self.orbitPoint.x, self.orbitPoint.y)
		self.orbitOriginSprite:add()
		self.orbitVelcitySprite:add()
		self.orbitOrbitSprite:add()
	else
		self.orbitOriginSprite:remove()
		self.orbitVelcitySprite:remove()
		self.orbitOriginSprite:remove()
		self.isOrbiting = true
	end
end

function PlayerNode:moveOrigin(x, y)
	self.orbitPoint.x = self.orbitPoint.x + x
	self.orbitPoint.y = self.orbitPoint.y + y
	self.orbitOriginSprite:moveTo(self.orbitPoint.x, self.orbitPoint.y)
	self.orbitVelcitySprite:moveTo(self.orbitPoint.x, self.orbitPoint.y)
	self.orbitOrbitSprite:moveTo(self.orbitPoint.x, self.orbitPoint.y)
	self:changeOrbitVelocity(0)
end

function PlayerNode:setOrbitVelocity(velocity)
	self.orbitVelocity = velocity
	self:changeOrbitVelocity(0)
end

function PlayerNode:changeOrbitVelocity(change)
	self.orbitVelocity = math.max(1, self.orbitVelocity + change)
	local orbitVelocityImage = gfx.image.new(2, self.orbitVelocity)
	gfx.pushContext(orbitVelocityImage)
	gfx.setColor(gfx.kColorBlack)
	gfx.fillRect(0, 0, 2, self.orbitVelocity)
	gfx.popContext()
	self.orbitVelcitySprite:setImage(orbitVelocityImage)
	
	local orbitRadius = math.max(3, self.orbitPoint:distanceToPoint(self.p))
	local orbitOrbitImage = gfx.image.new(orbitRadius * 2 + 6, orbitRadius * 2 + 6)
	gfx.pushContext(orbitOrbitImage)
	gfx.setColor(gfx.kColorBlack)
	gfx.setLineWidth(5)
	gfx.setDitherPattern(0.8, gfx.image.kDitherTypeScreen)
	gfx.drawCircleAtPoint(orbitRadius + 3, orbitRadius + 3, orbitRadius)
	gfx.popContext()
	self.orbitOrbitSprite:setImage(orbitOrbitImage)
	
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
	if(self.isOrbiting) then
		self.isOrbiting = false
		self.orbitOrbitSprite:remove()
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
end

function PlayerNode:updateOrbit()
	if(self.isOrbiting) then
		local origin = self.orbitPoint
		local radius = self.orbitPoint:distanceToPoint(self.p)
		local velocity = self.orbitVelocity
		
		if self.orbitDegree == nil then self.orbitDegree = 1 end
		local angle = (self.orbitDegree * self:map(self.orbitVelocity, 1, 100, 0.01, 1.0)) * math.pi / 180

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
	saveState.isOrbiting = self.isOrbiting
	saveState.orbitVelocity = self.orbitVelocity
	saveState.orbitX = self.orbitPoint.x
	saveState.orbitY = self.orbitPoint.y
	return saveState
end