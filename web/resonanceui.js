const STATE_IDLE = 0;
const STATE_NEW_NOTE = 1;
const STATE_NEW_VISITOR = 2;
let state = STATE_IDLE;

const DEFAULT_VISITOR_RADIUS = 32;

const BG = "#2f2d27";
const FG = "#d4d2ca";
const PDY = "#f5c251";

let ctx;
let canvas;

let pendingNote = "C#"
let pendingSize = DEFAULT_VISITOR_RADIUS

const notes = [];

class NoteNode {
  constructor(x, y, note) {
      this.x = x;
      this.y = y;
      this.note = note;
  }
}

const visitors = [];

class VisitorNode {
  constructor(x, y, radius) {
      this.x = x;
      this.y = y;
      this.radius = radius;
  }
}

function resonanceCanvasInit(){
  canvas = document.getElementById("resonance_canvas");
  ctx = canvas.getContext("2d");
  
  canvas.addEventListener("mousemove", onMouseMove, false);
  canvas.addEventListener("mousedown", onMouseDown, false);
  
  drawAll();
}

function getMidiNote(noteStr){
  const midiNote = noteNames.indexOf(noteStr) + 12
  return midiNote;
}

function clearAll(){
  notes.length = 0;
  visitors.length = 0;
  drawAll();
  patchSendListener("clr 0");
  visitors.push(new VisitorNode(200, 120, 30));
  state = STATE_IDLE;
  drawAll();
}

function clearAllFromSerial(){
  notes.length = 0;
  visitors.length = 0;
  state = STATE_IDLE;
  drawAll();
}

function addPlayerFromSerial(x, y, size){
  console.log("Adding player from serial: x: " + x + " y: " + y + " size: " + size)
  visitors.push(new VisitorNode(x, y, size));
  state = STATE_IDLE;
  drawAll();
}

function addNoteFromSerial(x, y, midiNote){
  console.log("Adding note from serial: x: " + x + " y: " + y + " midiNote: " + midiNote)
  const noteLabel = noteNames[midiNote - 12]
  notes.push(new NoteNode(x, y, noteLabel));
  state = STATE_IDLE;
  drawAll();
}

function octUp(){
  patchSendListener("octu");
}

function octDown(){
  patchSendListener("octd");
}

function setNote(note) {
  pendingNote = note;
}

function setVisitorSize(size){
  pendingSize = size * 1.5;
  drawAll();
  drawVisitorNode(200, 120, pendingSize);
}

function drawAll(){
  ctx.clearRect(0, 0, canvas.width, canvas.height);
  drawGrid();
  drawNotes();
  drawVisitors();
  drawLines();
}

function onMouseDown(e) {
    e.stopPropagation();
    
    var cursor = {
        x: e.offsetX || e.originalEvent.layerX,
        y: e.offsetY || e.originalEvent.layerY
    };
    
    if(state == STATE_IDLE){
      
    }else if(state == STATE_NEW_NOTE) {
      notes.push(new NoteNode(cursor.x, cursor.y, pendingNote));
      state = STATE_IDLE;
      drawAll();
      patchSendListener("note " + cursor.x + " " + cursor.y + " " + getMidiNote(pendingNote));
    }else if (state == STATE_NEW_VISITOR) {
      visitors.push(new VisitorNode(cursor.x, cursor.y, pendingSize));
      state = STATE_IDLE;
      drawAll();
      patchSendListener("plyr " + cursor.x + " " + cursor.y + " " + pendingSize);
    }
}

function onMouseMove(e) {
    e.stopPropagation();
    
    var cursor = {
        x: e.offsetX || e.originalEvent.layerX,
        y: e.offsetY || e.originalEvent.layerY
    };
    
    console.log(cursor.x, cursor.y);
    
    if(state == STATE_IDLE){
      
    }else if(state == STATE_NEW_NOTE) {
      ctx.clearRect(0, 0, canvas.width, canvas.height);
      drawAll();
      drawNoteNode(cursor.x, cursor.y, pendingNote);
    }else if (state == STATE_NEW_VISITOR) {
      ctx.clearRect(0, 0, canvas.width, canvas.height);
      drawAll();
      drawVisitorNode(cursor.x, cursor.y, pendingSize);
    }
}

function drawNotes(){
  notes.forEach(function (item, index) {
    console.log(item, index);
    drawNoteNode(item.x, item.y, item.note);
  });
}

function drawVisitors(){
  visitors.forEach(function (item, index) {
    console.log(item, index);
    drawVisitorNode(item.x, item.y, item.radius);
  });
}

function drawLines(){
  visitors.forEach(function (visitor, index) {
    //drawVisitorNode(item.x, item.y, item.radius);
    notes.forEach(function (note, index) {
      //drawNoteNode(item.x, item.y, item.note);
      if(dist(visitor.x, visitor.y, note.x, note.y) < (visitor.radius * 2)){
        ctx.beginPath();
        ctx.moveTo(visitor.x, visitor.y); 
        ctx.lineTo(note.x, note.y); 
        ctx.lineWidth = 1;
        ctx.stroke();
      }
    });
  });
}

function dist(x1, y1, x2, y2){
  var a = x1 - x2;
  var b = y1 - y2;
  
  return Math.sqrt( a*a + b*b );
}

function drawGrid(){ 
  const cellSize = 400/13 
  const xOffset = (cellSize/2) - 2
  const yOffset = (240/cellSize) + 4
  ctx.fillStyle = FG;
  for (let x = 0; x < 13; x++) {
    for (let y = 0; y < 13; y++) {
      ctx.fillRect(xOffset + (cellSize * x), yOffset + (cellSize * y),1,1);
    }
  }
}

function drawNoteNode(x, y, note){
  ctx.beginPath();
  ctx.arc(x, y, 6, 0, 2 * Math.PI);
  ctx.fillStyle = FG;
  ctx.fill();
  
  ctx.font = "12px Arial";
  ctx.fillText(note, x + 16, y + 6);
}

function drawVisitorNode(x, y, outerRadius){
  
  ctx.strokeStyle = FG;
  
  ctx.beginPath();
  ctx.arc(x, y, 6, 0, 2 * Math.PI);
  ctx.lineWidth = 1;
  ctx.stroke();
  
  ctx.beginPath();
  ctx.arc(x, y, outerRadius, 0, 2 * Math.PI);
  ctx.lineWidth = 3;
  ctx.stroke();
}

function newNoteNode(){
  state = STATE_NEW_NOTE;
}

function newVisitorNode(){
  state = STATE_NEW_VISITOR;
}