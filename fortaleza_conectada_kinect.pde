//Lucas Cabral e Lia Aguiar - 2019

Particle[] particles;
int[][] connections;
float global_diameter = 0;
float minimum_mouse_distance = 40;
float mouse_ellipse = minimum_mouse_distance*2;
//String[] bairros;
PFont f;
PImage background;
float imgX, imgY;
float diameter_canvas;

color trackColor; 
float colThreshold = 20;
float distThreshold = 15; //65
ArrayList<Blob> blobs = new ArrayList<Blob>();

import KinectPV2.KJoint;
import KinectPV2.*;

KinectPV2 kinect;

//Distance Threashold
int maxD = 1000; // 4.5mx
int minD = 300;  //  50cm
//int maxD = 1300; // 4.5mx
//int minD = 400;  //  50cm

void setup() {
  size(1280, 720, P3D);
  //size(640, 360);
  smooth();
  background(0);
  noCursor();
  createParticles(500, 0.4, 50); //1000,0.5,50
  diameter_canvas = height/2;
  background = loadImage("fdc_strong.png");
  background.resize(0, 650);
  imgX = width/2 - background.width/2;
  imgY = height/2 - background.height/2;
  //bairros = loadStrings("bairros.csv");
  //f = createFont("data/Courier10PitchBT-Roman-10.vlw",8,true);
  //f = loadFont("DejaVuSans-ExtraLight-10.vlw");
  //textFont(f, 8);

  kinect = new KinectPV2(this);
  //Enable point cloud
  kinect.enableDepthImg(true);
  kinect.enablePointCloud(true);
  kinect.init();
  trackColor = color(242, 0, 255);
  kinect.setLowThresholdPC(minD);
  kinect.setHighThresholdPC(maxD);
}

void draw() {
  background(0);
  updateBlobs();
  background(0);
  image(background, imgX, imgY);  
  showBlobs();
  updateParticles();
}

void showBlobs() {
  for (Blob b : blobs) {
    if (b.size() > 500) {
      b.show();
    }
  }
}

void updateBlobs() {
  blobs.clear();
  copy(kinect.getPointCloudDepthImage(), 0, 0, kinect.getPointCloudDepthImage().width, kinect.getPointCloudDepthImage().height, 0, 0, width, height);
  //raw Data int valeus from [0 - 4500]
  loadPixels();
  // Begin loop to walk through every pixel
  for (int x = 0; x < width; x++ ) {
    for (int y = 0; y < height; y++ ) {
      int loc = x + y * width;
      // What is current color
      color currentColor = pixels[loc];
      float bright = brightness(currentColor);


      if (bright != 0) {
        pixels[loc] = trackColor;
        boolean found = false;
        for (Blob b : blobs) {
          if (b.isNear(x, y)) {
            b.add(x, y);
            found = true;
            break;
          }
        }

        if (!found && blobs.size() <= 500 ) {
          Blob b = new Blob(x, y, distThreshold);
          blobs.add(b);
        }
      }
    }
  }
  updatePixels();
}


void updateParticles() {
  for (int i = 0; i < particles.length; i++) {
    particles[i].update();
  }
}

void createParticles(int size, float vel, float cd) {

  particles = new Particle [size];
  connections = new int [size][size];

  for (int i = 0; i < particles.length; i++) {
    float rot = random(0, TWO_PI);
    float radius = random(0, 360);
    float x = width/2 + cos(rot)*radius;
    float y = height/2 + sin(rot)*radius;
    //float x = random(0,width);
    //float y = random(0,height);
    //vel = random(0,vel);
    PVector v = new PVector(vel, 0);
    rot = random(0, TWO_PI);
    float d = random(1,4); //random(2, 4);
    v.rotate(rot);
    float sw = random(0.5, 1);
    particles[i] = new Particle(x, y, v.x, v.y, d, i, sw, cd);
  }

  for (int i = 0; i < particles.length; i++) {
    for (int j = 0; j < particles.length; j++) {
      if (i==j) connections[i][j] = 1;
      else connections[i][j] = 0;
    }
  }
}



void pointGrid() {
  //background(0);
  noStroke();
  fill(0);
  rect(0, 0, width, height);
  int steps = 20;
  float stepX = width/steps;
  float stepY = height/steps;
  for (int i = 1; i < steps; i++) {
    float y = stepY*i;
    for (int j = 1; j < steps; j++) {
      float x = stepX*j;
      stroke(255);
      strokeWeight(1);
      point(x, y);
    }
  }
}