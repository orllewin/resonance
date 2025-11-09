function addKnob(label, container, value){
  const knob = pureknob.createKnob(75, 75);
  setKnobConfig(knob, label, container, value);
  return knob
}

function setKnobConfig(knob, label, elementId, value){
  knob.setProperty('label', label);
  knob.setProperty('angleStart', -0.75 * Math.PI);
  knob.setProperty('angleEnd', 0.75 * Math.PI);
  knob.setProperty('colorFG', '#f5c251');
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
  populateNotesDropdown();
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

const noteNames = [
  "C#",		//13
  "D",		//14
  "Eb",		//15
  "E",		//16
  "F",		//17
  "F#",		//18
  "G",		//19
  "Ab", 	//20
  "A0",		//21
  "Bb0",	//22
  "B0",		//23
  "C1",		//24
  "C#1",	//25
  "D1",		//26
  "Eb1",	//27
  "E1",		//28
  "F1",		//29
  "F#1",	//30
  "G1",		//31
  "Ab1",	//32
  "A1",		//33
  "Bb1",	//34
  "B1",		//35
  "C2",		//36
  "C#2",	//37
  "D2",		//38
  "Eb2",	//39
  "E2",		//40
  "F2",		//41
  "F#2",	//42
  "G2",		//43
  "Ab2",	//44
  "A2",		//45
  "Bb2", 	//46
  "B2",		//47
  "C3",		//48
  "C#3",	//49
  "D3",		//50
  "Eb3", 	//51
  "E3",		//52
  "F3",		//53
  "F#3",	//54
  "G3",		//55
  "Ab3",	//56
  "A3",		//57
  "Bb3",	//58
  "B3",		//59
  "C4",   //60
  "C#4",  //61 
  "D4",		//62
  "Eb",		//63
  "E4",		//64 
  "F4", 	//65
  "F#4", 	//66
  "G4", 	//67
  "Ab4", 	//68
  "A4", 	//69
  "Bb4", 	//70
  "B4", 	//71 	 
  "C5", 	//72
  "C#5", 	//73
  "D5", 	//74
  "Eb5", 	//75
  "E5", 	//76
  "F5", 	//77
  "F#5", 	//78
  "G5", 	//79
  "Ab5", 	//80
  "A5", 	//81
  "Bb5", 	//82
  "B5", 	//83
];

function populateNotesDropdown(){
  const notesDropdown = document.getElementById('notes_dropdown');
  noteNames.forEach(function (item, index) {
    var option = document.createElement('option');
    option.value = item;
    option.innerHTML = item;
    notesDropdown.appendChild(option);
  });
}