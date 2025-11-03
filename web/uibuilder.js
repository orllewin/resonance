function addKnob(label, container, value){
  const knob = pureknob.createKnob(75, 75);
  setKnobConfig(knob, label, container, value);
  return knob
}

function setKnobConfig(knob, label, elementId, value){
  knob.setProperty('label', label);
  knob.setProperty('angleStart', -0.75 * Math.PI);
  knob.setProperty('angleEnd', 0.75 * Math.PI);
  knob.setProperty('colorFG', '#88ff88');
  knob.setProperty('trackWidth', 0.4);
  knob.setProperty('valMin', 0);
  knob.setProperty('valMax', 100);
  knob.setValue(value);
  const node = knob.node();
  const container = document.getElementById(elementId);
  container.appendChild(node);
}

function addPreDelay(){
  //Delay time
  const preDelayTime = addKnob('Time', 'pre_delay_time_container', 25);
  const preDelayTimeListener = function(knob, value) {
    console.log(value);
    setParam('pdt', value);
  };
  preDelayTime.addListener(preDelayTimeListener);
  
  //Delay feedback
  const preDelayFeedback = addKnob('Feedback', 'pre_delay_feedback_container', 25); 
  const preDelayFeedbackListener = function(knob, value) {
    console.log(value);
    setParam('pdf', value);
  };
  preDelayFeedback.addListener(preDelayFeedbackListener)
  
  //Delay mix
  const preDelayMix = addKnob('Mix', 'pre_delay_mix_container', 0);
  const preDelayMixListener = function(knob, value) {
    console.log(value);
    setParam('pdm', value);
  };
  preDelayMix.addListener(preDelayMixListener);
}

function addRingMod(){
  //Ringmod freq
  const ringmodFreq = addKnob('Frequency', 'ringmod_freq_container', 25);        
  const ringmodFreqListener = function(knob, value) {
    console.log(value);
    setParam('rmf', value);
  };
  
  ringmodFreq.addListener(ringmodFreqListener);
  
  //Ringmod mix
  const ringmodMix = addKnob('Mix', 'ringmod_mix_container', 0);        
  const ringmodMixListener = function(knob, value) {
    console.log(value);
    setParam('rmm', value);
  };
  
  ringmodMix.addListener(ringmodMixListener);
}

function addBitcrusher(){
  //Bitcrusher amount
  const bitcrusherAmount = addKnob('Amount', 'bitcrusher_amount_container', 10);
  const bitcrusherAmountListener = function(knob, value) {
    console.log(value);
    setParam('bca', value);
  };
  
  bitcrusherAmount.addListener(bitcrusherAmountListener);
  
  //Bitcrusher undersampling
  const bitcrusherUndersample = addKnob('Undersample', 'bitcrusher_undersampling_container', 25);   
  const bitcrusherUndersamplingListener = function(knob, value) {
    console.log(value);
    setParam('bcu', value);
  };
  
  bitcrusherUndersample.addListener(bitcrusherUndersamplingListener);
  
  //Bitcrusher mix
  const bitcrusherMix = addKnob('Mix', 'bitcrusher_mix_container', 0);  
  const bitcrusherMixListener = function(knob, value) {
    console.log(value);
    setParam('bcm', value);
  };
  
  bitcrusherMix.addListener(bitcrusherMixListener);
}

function addOverdrive(){
  //Overdrive gain
  const overdriveGain = addKnob('Gain', 'overdrive_gain_container', 50);        
  const overdriveGainListener = function(knob, value) {
    console.log(value);
    setParam('odg', value);
  };
  
  overdriveGain.addListener(overdriveGainListener);
  
  //Overdrive limit
  const overdriveLimit = addKnob('Limit', 'overdrive_limit_container', 50);        
  const overdriveLimitListener = function(knob, value) {
    console.log(value);
    setParam('odl', value);
  };
  
  overdriveLimit.addListener(overdriveLimitListener);
  
  //Overdrive mix
  const overdriveMix = addKnob('Mix', 'overdrive_mix_container', 0);        
  const overdriveMixListener = function(knob, value) {
    console.log(value);
    setParam('odm', value);
  };
  
  overdriveMix.addListener(overdriveMixListener);
}

function addMidDelay(){
  //Delay time
  const midDelayTime = addKnob('Time', 'mid_delay_time_container', 25);
  const midDelayTimeListener = function(knob, value) {
    console.log(value);
    setParam('mdt', value);
  };
  midDelayTime.addListener(midDelayTimeListener);
  
  //Delay feedback
  const midDelayFeedback = addKnob('Feedback', 'mid_delay_feedback_container', 25); 
  const midDelayFeedbackListener = function(knob, value) {
    console.log(value);
    setParam('mdf', value);
  };
  midDelayFeedback.addListener(midDelayFeedbackListener)
  
  //Delay mix
  const midDelayMix = addKnob('Mix', 'mid_delay_mix_container', 0);
  const midDelayMixListener = function(knob, value) {
    console.log(value);
    setParam('mdm', value);
  };
  midDelayMix.addListener(midDelayMixListener);
}

function addLowPass(){
  //Low-pass frequency
  const lowpassFreq = addKnob('Frequency', 'lowpass_freq_container', 50);    
  const lowpassFreqListener = function(knob, value) {
    console.log(value);
    setParam('lpf', value);
  };
  
  lowpassFreq.addListener(lowpassFreqListener);
  
  //Low-pass resonance
  const lowpassRes = addKnob('Resonance', 'lowpass_res_container',50);    
  const lowpassResListener = function(knob, value) {
    console.log(value);
    setParam('lpr', value);
  };
  
  lowpassRes.addListener(lowpassResListener);
  
  //Low-pass mix
  const lowpassMix = addKnob('Mix', 'lowpass_mix_container', 0);     
  const lowpassMixListener = function(knob, value) {
    console.log(value);
    setParam('lpm', value);
  };
  
  lowpassMix.addListener(lowpassMixListener);
}

function addHighPass(){
  //High-pass frequency
  const highpassFreq = addKnob('Frequency', 'highpass_freq_container', 50);      
  const highpassFreqListener = function(knob, value) {
    console.log(value);
    setParam('hpf', value);
  };
  
  highpassFreq.addListener(highpassFreqListener);
  
  //High-pass resonance
  const highpassRes = addKnob('Resonance', 'highpass_res_container', 50);      
  const highpassResListener = function(knob, value) {
    console.log(value);
    setParam('hpr', value);
  };
  
  highpassRes.addListener(highpassResListener);
  
  //High-pass mix
  const highpassMix = addKnob('Mix', 'highpass_mix_container', 0);        
  const highpassMixListener = function(knob, value) {
    console.log(value);
    setParam('hpm', value);
  };
  
  highpassMix.addListener(highpassMixListener);
}

function addPostDelay(){
  //Delay time
  const delayTime = addKnob('Time', 'delay_time_container', 25);
  const delayTimeListener = function(knob, value) {
    console.log(value);
    setParam('psdt', value);
  };
  delayTime.addListener(delayTimeListener);
  
  //Delay feedback
  const delayFeedback = addKnob('Feedback', 'delay_feedback_container', 25); 
  const delayFeedbackListener = function(knob, value) {
    console.log(value);
    setParam('psdf', value);
  };
  delayFeedback.addListener(delayFeedbackListener)
  
  //Delay mix
  const delayMix = addKnob('Mix', 'delay_mix_container', 0);
  const delayMixListener = function(knob, value) {
    console.log(value);
    setParam('psdm', value);
  };
  delayMix.addListener(delayMixListener);
}

function addSynthParams(){
  //Synth param 1
  const synthParam1 = addKnob('Parameter 1', 'synth_param1_container', 0);
  const synthParam1Listener = function(knob, value) {
    waveformParam1(value);
  };
  synthParam1.addListener(synthParam1Listener);
  
  //Synth param 2
  const synthParam2 = addKnob('Parameter 2', 'synth_param2_container', 0);
  const synthParam2Listener = function(knob, value) {
    waveformParam2(value);
  };
  synthParam2.addListener(synthParam2Listener);
}

function buildUI(){	
  addPreDelay();
  addRingMod();
  addBitcrusher();
  addOverdrive();
  addMidDelay();
  addLowPass();
  addHighPass();
  addPostDelay();
  addSynthParams();
}