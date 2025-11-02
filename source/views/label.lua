import "CoreLibs/sprites"
import "CoreLibs/graphics"
import "CoreLibs/ui"

local gfx <const> = playdate.graphics

class('Label').extends()

function Label:init(text, x, y)
  Label.super.init(self)
  
  self.text = text
  self.x = x
  self.y = y
  
  local textWidth, textHeight = gfx.getTextSizeForMaxWidth(text, 400)
  local labelImage = gfx.image.new(textWidth, textHeight, gfx.kColorWhite)
  gfx.pushContext(labelImage)
  gfx.setColor(gfx.kColorBlack)
  gfx.drawText(text, 0, 0)
  gfx.popContext()
  
  self.sprite = gfx.sprite.new(labelImage)
  self.sprite:moveTo(x, y)
  self.sprite:setCenter(0, 0)
  self.sprite:add()
end

function Label:update(text, x, y)
  self.text = text
  self.x = x
  self.y = y
  
  local textWidth, textHeight = gfx.getTextSizeForMaxWidth(text, 400)
  local labelImage = gfx.image.new(textWidth, textHeight, gfx.kColorWhite)
  gfx.pushContext(labelImage)
  gfx.setColor(gfx.kColorBlack)
  gfx.drawText(text, 0, 0)
  gfx.popContext()
  self.sprite:setImage(labelImage)
  self.sprite:moveTo(x, y)
  
end

function Label:remove()
  self.sprite:remove()
end