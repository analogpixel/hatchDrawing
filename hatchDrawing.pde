import processing.svg.*;


PImage img1;
PGraphics output;
PGraphics svg;
int bw = 8;
int bh = 8;
PImage brushes[];
boolean drawh=true;
boolean drawv=true;
int minlen=6;
int darkness=5; 
int xskip=1;
int yskip=1;

 void setup() {
  size(800,800);
  img1 = loadImage("flower2small.jpg");
  //img1.filter(GRAY);
  
  output = createGraphics(bw * img1.width, bh * img1.height);
  svg = createGraphics(bw * img1.width, bh * img1.height, SVG, "output.svg");
  
  brushes = new PImage[darkness];
  for(int i=0; i < darkness; i++) {
    brushes[i] = loadImage("b" + i + ".png");
  }
  
  bw = brushes[0].width;
  bh = brushes[0].height;
  
  output.beginDraw();
  output.background(255);
  for (int x=0; x < img1.width; x+=xskip)
    for (int y=0; y < img1.height; y+=yskip) {
            float r = red(img1.get(x,y));
            int i = int(map(r, 0, 255, darkness-1,0));
            output.image(brushes[i], x*bw, y*bh);
    }
  output.endDraw();
  output.filter(THRESHOLD);
   output.save("output.png");
   
   println("Phase 1 complete");
   println("Now convert to svg");
   
  
  svg.beginDraw();
  
   // build up the vertical lines
   println("Draw verticals");
   if (drawv) {
   for (int x=0; x < output.width; x++) {
      
     int lasty=0;
     boolean run=false;
     
     for (int y=0; y < output.height; y++) {
       int c = int(red(output.get(x,y)));
       
       // if we get to a white pixel and are in a run
       if ((c == 255 && run)||(run && y == output.height-1)) {
         if (abs(y-lasty) > minlen) {
         svg.line(x, lasty, x, y);
         }
         run=false;
         continue;
       }
       
       // if we get a black pixel and we aren't in a run already
       if (c == 0 && (! run) ) {
         run=true;
         lasty = y;
         continue;
       }
       
     }
     
   }
   }
   
   
   // build up the horizontal lines
   if (drawh) {
     println("Draw Horizontals");
   for (int y=0; y < output.height; y++) {
      
     int lastx=0;
     boolean run=false;
     
     for (int x=0; x < output.width; x++) {
       int c = int(red(output.get(x,y)));
       
       // if we get to a white pixel and are in a run
       if ((c == 255 && run) || (run && x == output.width-1)) {
         if (abs(x-lastx) > minlen) {
           svg.line(lastx, y, x, y);
         }
         run=false;
         continue;
       }
       
       // if we get a black pixel and we aren't in a run already
       if (c == 0 && (! run) ) {
         run=true;
         lastx = x;
         continue;
       }
       
     }
     
   }
   }
   
   println("Finish up");
   
   svg.dispose();
   svg.endDraw();
   println("finished");
   exit();
 }
 
 void draw() {
 }
 
 