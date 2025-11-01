import "CoreLibs/sprites"
import "CoreLibs/graphics"
import "CoreLibs/ui"

local gfx <const> = playdate.graphics

class('SmallEncoder').extends()

local SmallEncoderDiam = 30

local focusImage = gfx.image.new(SmallEncoderDiam, SmallEncoderDiam)
gfx.pushContext(focusImage)
gfx.setColor(gfx.kColorBlack)
gfx.setLineWidth(4)
gfx.drawCircleAtPoint(SmallEncoderDiam/2, SmallEncoderDiam/2, SmallEncoderDiam/2 - 2)
gfx.setLineWidth(1)
gfx.drawLine(SmallEncoderDiam/2, SmallEncoderDiam/2, 6, SmallEncoderDiam - 6)
gfx.popContext()

local unfocusImage = gfx.image.new(SmallEncoderDiam, SmallEncoderDiam)
gfx.pushContext(unfocusImage)
gfx.setColor(gfx.kColorBlack)
gfx.drawCircleAtPoint(SmallEncoderDiam/2, SmallEncoderDiam/2, SmallEncoderDiam/2 - 2)
gfx.drawLine(SmallEncoderDiam/2, SmallEncoderDiam/2, 7, SmallEncoderDiam - 7)
gfx.popContext()

function SmallEncoder:init(x, y, value, onChange)
    SmallEncoder.super.init(self)
    self.onChange = onChange
    self.value = value
    self.focused = false
    
    self.sprite = gfx.sprite.new()
    self.sprite:moveTo(x, y)
    self.sprite:setImage(unfocusImage)
    self.sprite:add()
    
    self:redraw()
end

function SmallEncoder:focus()
  self.sprite:setImage(focusImage)
  self.focused = true
end

function SmallEncoder:unfocus()
  self.sprite:setImage(unfocusImage)
  self.focused = false
end

function SmallEncoder:map(value, start1, stop1, start2, stop2)
  return start2 + (stop2 - start2) * ((value - start1) / (stop1 - start1))
end

function SmallEncoder:redraw()
  local rotation = self:map(self.value, 0.0, 100.0, 0.0, 271.5)
  self.sprite:setRotation(rotation)
end

function SmallEncoder:turn(change)
  if not self.focused then
    return
  end
  self.value += change
  if self.value <  0 then
    self.value = 0
  elseif self.value > 100 then
    self.value = 100
  end
  
  self:redraw()
  self.onChange(self.value)
end

function SmallEncoder:remove()
  self.sprite:remove()
end