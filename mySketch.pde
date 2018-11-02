/* @pjs preload="MonetWaterlily.jpg"; */

/*


brush's stroke & portrait.

Controls:
  - Mouse click to switch to the next image.

Derived from Jason Labbe's open source jasonlabbe3d.com
  
*/
import processing.video.*;

PImage img;
PImage camImg;
Capture cam;
int distance;
boolean looping;

void setup() {
  size(1024, 986);
  //size(2048, 1024);
  
  background(255);
  loop();
  frameCount = 0;
  looping = true;
  
  img = loadImage("MonetWaterlily.jpg");
  img.loadPixels();
  String[] cameras = Capture.list();
  
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println( cameras[i]);
    }
    
    // The camera can be initialized directly using an 
    // element from the array returned by list():
    cam = new Capture(this, cameras[0]);
    cam.start();     
  }     
}


//void draw(){
//  if (cam.available() == true) {
//    cam.read();
//    //println("has camera");
//  }
//  //println("next");
//  camImg = createImage(width, height, RGB);
//  camImg.copy(cam, 0, 0, cam.width, cam.height, 0, 0, cam.width, cam.height);
  
//  int finalIndex = firstPixel();
//  println("final Index is " + finalIndex);
//  distance = finalIndex;
//  background(finalIndex);

//  //image(cam, 0, 0);
//}

int firstPixel(){
   int index = (cam.height/2)*cam.width;
   /* loop through the cam image in the mid point */
    for (int x = 0; x < cam.width; x+=1) {
       color pixelColor = cam.pixels[index];
       //pixelColor = color(red(pixelColor), green(pixelColor), blue(pixelColor), 100);
       float avgColor = (red(pixelColor) + green(pixelColor) + blue(pixelColor))/3;
       
       if(avgColor<100){
        //println("avgColor is " + avgColor);
        println("return " + x);
        //return index/3;
        return x;
       }
       
       index++;
     }

   return cam.width;  
}



void paintStroke(float strokeLength, color strokeColor, int strokeThickness) {
  float stepLength = strokeLength/4.0;
  
  // Determines if the stroke is curved. A straight line is 0.
  float tangent1 = 0;
  float tangent2 = 0;
  
  float odds = random(1.0);
  
  if (odds < 0.7) {
    tangent1 = random(-strokeLength, strokeLength);
    tangent2 = random(-strokeLength, strokeLength);
  } 
  
  // Draw a big stroke
  noFill();
  stroke(strokeColor);
  strokeWeight(strokeThickness);
  curve(tangent1, -stepLength*2, 0, -stepLength, 0, stepLength, tangent2, stepLength*2);
  
  int z = 1;
  
  // Draw stroke's details
  for (int num = strokeThickness; num > 0; num --) {
    float offset = random(-50, 25);
    color newColor = color(red(strokeColor)+offset, green(strokeColor)+offset, blue(strokeColor)+offset, random(100, 255));
    
    stroke(newColor);
    strokeWeight((int)random(0, 3));
    //curve(tangent1, -stepLength*2, z-strokeThickness/2, -stepLength*random(0.9, 1.1), 
    //      z-strokeThickness/2, stepLength*random(0.9, 1.1), tangent2, stepLength*2);
    
    curve(tangent1, -stepLength*2, z-strokeThickness/2, -stepLength, 
          z-strokeThickness/2, stepLength, tangent2, stepLength*2);
    
    z += 1;
  }
}





void draw() {
  if (cam.available() == true) {
    cam.read();
  }
  camImg = createImage(width, height, RGB);
  camImg.copy(cam, 0, 0, cam.width, cam.height, 0, 0, cam.width, cam.height);
  
  int finalIndex = firstPixel();
  println("final Index is " + finalIndex);
  distance = finalIndex;
  
  translate(width/2, height/2);
  
  int index = 0;
  
  for (int y = 0; y < img.height; y+=1) {
    for (int x = 0; x < img.width; x+=1) {
      int odds = (int)random(20000);
      
      if (odds < 1) {
        color pixelColor = camImg.pixels[index];
        pixelColor = color(red(pixelColor), green(pixelColor), blue(pixelColor), 100);
        
        pushMatrix();
        translate(x-img.width/2, y-img.height/2);
        rotate(radians(random(-90, 90)));
        
        
        /* Paint by layers from rough strokes to finer details */
        /* strokeLength, color strokeColor, int strokeThickness */
        if (distance < 50) {
          // Big rough strokes
          paintStroke(random(30, 50), pixelColor, (int)random(20, 30));
        } else if (distance < 150) {
          // Thick strokes
          paintStroke(random(10, 20), pixelColor, (int)random(8, 10));
        } else if (distance < 300) {
          // Small strokes
          paintStroke(random(5, 15), pixelColor, (int)random(5, 10));
        } else if (distance < 450) {
          // Big dots
          paintStroke(random(3, 10), pixelColor, (int)random(3, 5));
        } else if (distance < 650) {
          // Small dots
          paintStroke(random(1, 7), pixelColor, (int)random(1, 7));
        } else if (distance < 1000) {
          // Small dots
          paintStroke(random(1, 3), pixelColor, (int)random(1, 3));
        }
        
        //if (distance < 50) {
        //  // Big rough strokes
        //  paintStroke(random(150, 250), pixelColor, (int)random(20, 40));
        //} else if (distance < 150) {
        //  // Thick strokes
        //  paintStroke(random(75, 125), pixelColor, (int)random(8, 12));
        //} else if (distance < 300) {
        //  // Small strokes
        //  paintStroke(random(30, 60), pixelColor, (int)random(1, 4));
        //} else if (distance < 450) {
        //  // Big dots
        //  paintStroke(random(5, 20), pixelColor, (int)random(5, 15));
        //} else if (distance < 650) {
        //  // Small dots
        //  paintStroke(random(1, 10), pixelColor, (int)random(1, 7));
        //} else if (distance < 1000) {
        //  // Small dots
        //  paintStroke(random(1, 10), pixelColor, (int)random(1, 3));
        //}
        
        popMatrix();
      }
      
      index += 1;
    }
  }
  
  //if (frameCount > 900) {
  //  println("done");
  //  noLoop();
  //}
}

void mouseClicked() {
    //  println("done");
    //noLoop();
    if (looping){
      looping = false;
      noLoop();
    }else{
      looping = true;
      loop();
    }
}
