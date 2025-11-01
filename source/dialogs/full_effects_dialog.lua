import "views/label"
import "views/small_encoder"

local gfx <const> = playdate.graphics

class('FullEffectsDialog').extends()

local effectDialogWidth = 400
local leftGroupMargin  = 12
local rightGroupMargin = 12

local row1LabelY = 70
local row2LabelY = 145
local row3LabelY = 220

local row1EncoderY = 50
local row2EncoderY = 120
local row3EncoderY = 195
local col1StartX = 33.33
local col2StartX = 166.66
local col3StartX = 300.00 - rightGroupMargin

local labelColumn1X = (col1StartX + leftGroupMargin) - 12
local labelColumn2X = (col2StartX) - 12
local labelColumn3X = (col3StartX) - 12

function FullEffectsDialog:init()
    FullEffectsDialog.super.init(self)
end

function FullEffectsDialog:show(onDismiss)
  local background = gfx.image.new(effectDialogWidth, 240, gfx.kColorWhite)
  gfx.pushContext(background)
  gfx.setColor(gfx.kColorBlack)
  
  local smallResImage = playdate.graphics.image.new("images/small_res")
  smallResImage:setInverted(true)
  local smallerResImage = smallResImage:scaledImage(0.80)
  smallerResImage:drawScaled(300, 162, 0.75)
  
  
  gfx.drawRoundRect(0, 0, effectDialogWidth, 240, 12) 
  
  local row1LabelYY = 15
  gfx.drawText("Delay (Pre)", (col1StartX + leftGroupMargin) - 12, row1LabelYY)
  gfx.drawText("Ring mod", col2StartX - 12, row1LabelYY)
  gfx.drawText("Bitcrusher", col3StartX - 12, row1LabelYY)
  
  local row2LabelYY = 90
  gfx.drawText("Overdrive", (col1StartX + leftGroupMargin) - 12, row2LabelYY)
  gfx.drawText("Delay (Mid)", col2StartX - 12, row2LabelYY)
  gfx.drawText("Low-Pass", col3StartX - 12, row2LabelYY)
  
  local row3LabelYY = 165
  gfx.drawText("High-pass", (col1StartX + leftGroupMargin) - 12, row3LabelYY)
  gfx.drawText("Delay (Post)", col2StartX - 12, row3LabelYY)
  
  
  
  
  gfx.popContext()
  
  self.backgroundSprite = gfx.sprite.new(background)
  self.backgroundSprite:moveTo(200, 120)
  self.backgroundSprite:add()
  
  self.focusedView = nil
  self.focusedRow = 1
  self.focusedColumn = 1
  
  
  self.label = Label("Time", labelColumn1X, row1LabelY)

  -- ROW 1 ---------------------------------------------------------------------------------
  -- DELAY
  local preDelayTimeValue = self:map(gPreDelayTime, 0.0, gPreDelayMax, 0.0, 100.0)
  self.preDelayTimeEncoder = SmallEncoder(33.33 + leftGroupMargin, row1EncoderY, preDelayTimeValue,
    function(value) 
      --delayTime 0.0 to 100.0
      gPreDelayTime = self:map(value, 0.0, 100.0, 0.0, gPreDelayMax)
      gPreDelayTap1:setDelay(gPreDelayTime)
    end
  )
  self.focusedView = self.preDelayTimeEncoder
  self.preDelayFeedbackEncoder = SmallEncoder(66.66 + leftGroupMargin, row1EncoderY, gPreDelayFeedback * 100.0,
    function(value) 
      gPreDelayFeedback = value/100.0
      gPreDelay:setFeedback(gPreDelayFeedback)
    end
  )
  self.delayVolumeEncoder = SmallEncoder(100.00 + leftGroupMargin, row1EncoderY, gPreDelayVolume * 100.0,
    function(value) 
      gPreDelayVolume = value/100.0
      gPreDelayTap1:setVolume(gPreDelayVolume)
    end
  )
  
  -- ROW 1 ---------------------------------------------------------------------------------
  -- RING MOD
  local ringModFreqValue = self:map(gDelayTime, 0.0, gDelayMax, 0.0, 100.0)
  self.ringmodFreqEncoder = SmallEncoder(166.66, row1EncoderY, ringModFreqValue,
    function(value) 
      gRingmodFreq = self:map(value, 0.0, 100.0, gRingmodFreqMin, gRingmodFreqMax)
      gRingmod:setFrequency(gRingmodFreq)
    end
  )
  self.ringmodMixEncoder = SmallEncoder(200.00, row1EncoderY, gRingmodMix * 100.0, 
    function(value) 
      gRingmodMix = value/100.0
      gRingmod:setFeedback(gDelayFeedback)
    end
  )
  
  -- ROW 1 ---------------------------------------------------------------------------------
  -- BITCRUSHER
  self.bitcrusherAmountEncoder = SmallEncoder(300.00 - rightGroupMargin, row1EncoderY, gBitcrusherAmount * 100.0, 
    function(value) 
      gBitcrusherAmount = value/100.0
      gBitcrusher:setAmount(gBitcrusherAmount)
    end
  )
  self.bitcrusherUndersampleEncoder = SmallEncoder(333.33 - rightGroupMargin, row1EncoderY, gBitcrusherUndersample * 100.0, 
    function(value) 
      gBitcrusherUndersample = value/100.0
      gBitcrusher:setUndersampling(gBitcrusherUndersample)
    end
  )
  self.bitcrusherMixEncoder = SmallEncoder(366.66 - rightGroupMargin, row1EncoderY, gBitcrusherMix * 100.0, 
    function(value) 
      gBitcrusherMix = value/100.0
      gBitcrusher:setMix(gBitcrusherMix)
    end
  )
  
  -- ROW 2 ---------------------------------------------------------------------------------
  -- OVERDRIVE
  local overdriveGain = self:map(gOverdriveGain, 0.0, 1.0, 0.0, 100.0)
  self.overdriveGainEncoder = SmallEncoder(33.33 + leftGroupMargin, row2EncoderY, overdriveGain,
    function(value) 
      gOverdriveGain = value/100.0
      gOverdrive:setGain(gOverdriveGain)
    end
  )
  self.overdriveLimitEncoder = SmallEncoder(66.66 + leftGroupMargin, row2EncoderY, gDelayFeedback * 100.0, 
    function(value) 
      gOverdriveLimit = map(value, 0.0, 100.0, 0.0, gOverdriveLimitMax)
      gOverdrive:setLimit(gOverdriveLimit)
    end
  )
  self.overdriveMixEncoder = SmallEncoder(100.00 + leftGroupMargin, row2EncoderY, gDelayVolume * 100.0,
    function(value) 
      gOverdriveMix = value/100.0
      gOverdrive:setMix(gOverdriveMix)
    end
  )
  -- ROW 2 ---------------------------------------------------------------------------------
  -- DELAY (MID)
  local delayMidTimeValue = self:map(gMidDelayTime, 0.0, gMidDelayMax, 0.0, 100.0)
  self.delayMidTimeEncoder = SmallEncoder(166.66, row2EncoderY, delayMidTimeValue,
    function(value) 
      gMidDelayTime = self:map(value, 0.0, 100.0, 0.0, gMidDelayMax)
      gMidDelayTap1:setDelay(gMidDelayTime)
    end
  )
  self.delayMidFeedbackEncoder = SmallEncoder(200.00, row2EncoderY, gMidDelayFeedback * 100.0, 
    function(value) 
      gMidDelayFeedback = value/100.0
      gMidDelayTap1:setFeedback(gMidDelayFeedback)
    end
  )
  self.delayMidMixEncoder = SmallEncoder(233.33, row2EncoderY, gMidDelayVolume * 100.0, 
    function(value) 
      gMidDelayVolume = value/100.0
      gMidDelayTap1:setFeedback(gMidDelayVolume)
    end
  )
  -- ROW 2 ---------------------------------------------------------------------------------
  -- LOW-PASS
  local lowpassFreqValue = self:map(gLowPassFreq, gLowPassFreqMin, gLowPassFreqMax, 0.0, 100.0)
  self.lowpassFreqEncoder = SmallEncoder(300.00 - rightGroupMargin, row2EncoderY, lowpassFreqValue, 
    function(value) 
      gLowPassFreq = self:map(value, 0.0, 100.0, gLowPassFreqMin, gLowPassFreqMax)
      gLowPass:setFrequency(gLowPassFreq)
    end
  )
  self.lowpassResonanceEncoder = SmallEncoder(333.33 - rightGroupMargin, row2EncoderY, gLowPassRes * 100.0, 
    function(value) 
      gLowPassRes = value/100.0
      gLowPass:setResonance(gLowPassRes)
    end
  )
  self.lowpassMixEncoder = SmallEncoder(366.66 - rightGroupMargin, row2EncoderY, gLowPassMix * 100.0, 
    function(value) 
      gLowPassMix = value/100.0
      gLowPass:setMix(gLowPassMix)
    end
  )
  
  -- ROW 3 ---------------------------------------------------------------------------------
  -- HIGH-PASS
  local highpassFreqValue = self:map(gHighPassFreq, gHighPassFreqMin, gHighPassFreqMax, 0.0, 100.0)
  self.highpassFreqEncoder = SmallEncoder(33.33 + leftGroupMargin, row3EncoderY, highpassFreqValue,
    function(value) 
      gHighPassFreq = self:map(value, 0.0, 100.0, gHighPassFreqMin, gHighPassFreqMax)
      gHighPass:setFrequency(gHighPassFreq)
    end
  )
  self.highpassResonanceEncoder = SmallEncoder(66.66 + leftGroupMargin, row3EncoderY, gHighPassRes * 100.0, 
    function(value) 
      gHighPassRes = value/100.0
      gHighPass:setResonance(gHighPassRes)
    end
  )
  self.highpassMixEncoder = SmallEncoder(100.00 + leftGroupMargin, row3EncoderY, gHighPassMix * 100.0, 
    function(value) 
      gHighPassMix = value/100.0
      gHighPass:setMix(gHighPassMix)
    end
  )
  
  -- ROW 3 ---------------------------------------------------------------------------------
  -- DELAY (POST)
  local delayPostTimeValue = self:map(gDelayTime, 0.0, gDelayMax, 0.0, 100.0)
  self.delayPostTimeEncoder = SmallEncoder(166.66, row3EncoderY, delayPostTimeValue,
    function(value) 
      gDelayTime = self:map(value, 0.0, 100.0, 0.0, gDelayMax)
      gDelayTap1:setDelay(gDelayTime)
    end
  )
  self.delayPostFeedbackEncoder = SmallEncoder(200.00, row3EncoderY, gDelayFeedback * 100.0, 
    function(value) 
      gDelayFeedback = value/100.0
      gDelayTap1:setFeedback(gDelayFeedback)
    end
  )
  self.delayPostMixEncoder = SmallEncoder(233.33, row3EncoderY, gDelayVolume * 100.0, 
    function(value) 
      gDelayVolume = value/100.0
      gDelayTap1:setFeedback(gDelayVolume)
    end
  )
  
  self.inputHandler = {
    
    BButtonDown = function()
      self:dismiss()
      onDismiss()
    end,
    
    AButtonDown = function()
      self:dismiss()
      onDismiss()
    end,
    
    leftButtonDown = function()
      self.focusedView:unfocus()
      self.focusedColumn = math.max(1, self.focusedColumn - 1)
      self:updateFocusedEncoder()
    end,
    
    rightButtonDown = function()
      self.focusedView:unfocus()
      if self.focusedRow == 1 then
        self.focusedColumn = math.min(8, self.focusedColumn + 1)
      elseif self.focusedRow == 2 then
        self.focusedColumn = math.min(9, self.focusedColumn + 1)
      else
        self.focusedColumn = math.min(6, self.focusedColumn + 1)
      end
      self:updateFocusedEncoder()
    end,
    
    upButtonDown = function()
      self.focusedView:unfocus()
      if self.focusedRow == 2 then
        if self.focusedColumn > 5 then self.focusedColumn = self.focusedColumn - 1 end
      end
      self.focusedRow = math.max(1, self.focusedRow - 1)
      self:updateFocusedEncoder()
    end,
    
    downButtonDown = function()
      self.focusedView:unfocus()
      if self.focusedRow == 1 then
        if self.focusedColumn > 5 then self.focusedColumn = self.focusedColumn + 1 end
      elseif self.focusedRow == 2 then
        if self.focusedColumn > 6 then self.focusedColumn = 6 end
      end
      self.focusedRow = math.min(3, self.focusedRow + 1)
      self:updateFocusedEncoder()
    end,
    
    cranked = function(change, acceleratedChange)
      self.focusedView:turn(change)
    end,
  }
  
  playdate.inputHandlers.push(self.inputHandler)
  
  self.focusedView:focus()
end

function FullEffectsDialog:updateFocusedEncoder()
  if self.focusedRow == 1 then
    if self.focusedColumn == 1 then
      self.focusedView = self.preDelayTimeEncoder
      self.label:update("Time", labelColumn1X, row1LabelY)
    elseif self.focusedColumn == 2 then
      self.focusedView = self.preDelayFeedbackEncoder
      self.label:update("Feedback", labelColumn1X, row1LabelY)
    elseif self.focusedColumn == 3 then
      self.focusedView = self.delayVolumeEncoder
      self.label:update("Mix", labelColumn1X, row1LabelY)
    elseif self.focusedColumn == 4 then
      self.focusedView = self.ringmodFreqEncoder
      self.label:update("Frequency", labelColumn2X, row1LabelY)
    elseif self.focusedColumn == 5 then
      self.focusedView = self.ringmodMixEncoder
      self.label:update("Mix", labelColumn2X, row1LabelY)
    elseif self.focusedColumn == 6 then
      self.focusedView = self.bitcrusherAmountEncoder
      self.label:update("Amount", labelColumn3X, row1LabelY)
    elseif self.focusedColumn == 7 then
      self.focusedView = self.bitcrusherUndersampleEncoder
      self.label:update("Undersample", labelColumn3X, row1LabelY)
    elseif self.focusedColumn == 8 then
      self.focusedView = self.bitcrusherMixEncoder
      self.label:update("Mix", labelColumn3X, row1LabelY)
    end
  elseif self.focusedRow == 2 then
    if self.focusedColumn == 1 then
      self.focusedView = self.overdriveGainEncoder
      self.label:update("Gain", labelColumn1X, row2LabelY)
    elseif self.focusedColumn == 2 then
      self.focusedView = self.overdriveLimitEncoder
      self.label:update("Limit", labelColumn1X, row2LabelY)
    elseif self.focusedColumn == 3 then
      self.focusedView = self.overdriveMixEncoder
      self.label:update("Mix", labelColumn1X, row2LabelY)
    elseif self.focusedColumn == 4 then
      self.focusedView = self.delayMidTimeEncoder
      self.label:update("Time", labelColumn2X, row2LabelY)
    elseif self.focusedColumn == 5 then
      self.focusedView = self.delayMidFeedbackEncoder
    self.label:update("Feedback", labelColumn2X, row2LabelY)
    elseif self.focusedColumn == 6 then
      self.focusedView = self.delayMidMixEncoder
      self.label:update("Mix", labelColumn2X, row2LabelY)
    elseif self.focusedColumn == 7 then
      self.focusedView = self.lowpassFreqEncoder
      self.label:update("Frequency", labelColumn3X, row2LabelY)
    elseif self.focusedColumn == 8 then
      self.focusedView = self.lowpassResonanceEncoder
      self.label:update("Resonance", labelColumn3X, row2LabelY)
    elseif self.focusedColumn == 9 then
      self.focusedView = self.lowpassMixEncoder
      self.label:update("Mix", labelColumn3X, row2LabelY)
    end
  else
    if self.focusedColumn == 1 then
      self.focusedView = self.highpassFreqEncoder
      self.label:update("Frequency", labelColumn1X, row3LabelY)
    elseif self.focusedColumn == 2 then
      self.focusedView = self.highpassResonanceEncoder
      self.label:update("Resonance", labelColumn1X, row3LabelY)
    elseif self.focusedColumn == 3 then
      self.focusedView = self.highpassMixEncoder
      self.label:update("Mix", labelColumn1X, row3LabelY)
    elseif self.focusedColumn == 4 then
      self.focusedView = self.delayPostTimeEncoder
      self.label:update("Time", labelColumn2X, row3LabelY) 
    elseif self.focusedColumn == 5 then
      self.focusedView = self.delayPostFeedbackEncoder
      self.label:update("Feedback", labelColumn2X, row3LabelY)      
    elseif self.focusedColumn == 6 then
      self.focusedView = self.delayPostMixEncoder
      self.label:update("Mix", labelColumn2X, row3LabelY)
    end
  end
  
  self.focusedView:focus()
end

function FullEffectsDialog:map(value, start1, stop1, start2, stop2)
  return start2 + (stop2 - start2) * ((value - start1) / (stop1 - start1))
end

function FullEffectsDialog:dismiss()
  playdate.inputHandlers.pop()
  self.backgroundSprite:remove()
  
  --row1
  --delay
  self.preDelayTimeEncoder:remove()
  self.preDelayFeedbackEncoder:remove()
  self.delayVolumeEncoder:remove()
  --ringmod
  self.ringmodFreqEncoder:remove()
  self.ringmodMixEncoder:remove()
  --bitcrusher
  self.bitcrusherAmountEncoder:remove()
  self.bitcrusherUndersampleEncoder:remove()
  self.bitcrusherMixEncoder:remove()
  
  --row2
  --overdrive
  self.overdriveGainEncoder:remove()
  self.overdriveLimitEncoder:remove()
  self.overdriveMixEncoder:remove()
  --delay (mid)
  self.delayMidTimeEncoder:remove()
  self.delayMidFeedbackEncoder:remove()
  self.delayMidMixEncoder:remove()
  --lowpass
  self.lowpassFreqEncoder:remove()
  self.lowpassResonanceEncoder:remove()
  self.lowpassMixEncoder:remove()
  
  --row3
  --highpass
  self.highpassFreqEncoder:remove()
  self.highpassResonanceEncoder:remove()
  self.highpassMixEncoder:remove()
  --delay (post)
  self.delayPostTimeEncoder:remove()
  self.delayPostFeedbackEncoder:remove()
  self.delayPostMixEncoder:remove()

end