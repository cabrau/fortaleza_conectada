//Lucas Cabral e Lia Aguiar - 2019
//colisão entre particulas?

Particle[] particles;
int[][] connections;
float global_diameter = 0;
float minimum_mouse_distance = 40;
float mouse_ellipse = minimum_mouse_distance*2;
String[] bairros;
PFont f;
PImage background;
float imgX, imgY;
float diameter_canvas;

void setup() {
  size(1280, 720);
  //size(640, 360);
  background(0);  
  createParticles(500, 0.2, 50); //1000,0.5,50
  diameter_canvas = height/2;
  background = loadImage("fdc3.png");
  background.resize(0,650);
  imgX = width/2 - background.width/2;
  imgY = height/2 - background.height/2;
  //bairros = loadStrings("bairros.csv");
  //f = createFont("data/Courier10PitchBT-Roman-10.vlw",8,true);
  //f = loadFont("DejaVuSans-ExtraLight-10.vlw");
  //textFont(f, 8);
  
}

void draw() {
  //noStroke();
  //fill(0);
  //rect(0, 0, width, height);
  //pointGrid();
  background(0); 
  image(background,imgX,imgY);  
  updateParticles();
  //fill(255, 20);
  //noStroke();  
  //ellipse(mouseX, mouseY, mouse_ellipse, mouse_ellipse);
}

void mousePressed() {
}

void mouseReleased() {
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
    float radius = random(0,360);
    float x = width/2 + cos(rot)*radius;
    float y = height/2 + sin(rot)*radius;
    //float x = random(0,width);
    //float y = random(0,height);
    //vel = random(0,vel);
    PVector v = new PVector(vel, 0);
    rot = random(0, TWO_PI);
    float d = 3; //random(2, 4);
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
