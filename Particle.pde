class Particle {
  PVector pos;
  PVector vel;
  PVector acc;
  float diameter;
  int id;
  float connecting_diameter;
  float margin;
  float left, right, up, down;
  float vel_mag;
  float strokeW;
  float initial_cd;
  float max_dist;

  Particle(float x, float y, float vx, float vy, float d, int i, float sw, float cd) {
    pos = new PVector(x, y);
    vel = new PVector(vx, vy);
    acc = new PVector(0, 0);
    diameter = d;
    id = i;
    connecting_diameter = 10;   
    vel_mag = vel.mag();
    margin = 70;
    left = margin;
    right = width-margin;
    up = margin;
    down = height-margin;
    strokeW = sw;
    initial_cd = cd;
    max_dist = dist(width/2, height/2, width/2, 0);
  }

  void update() {
    if (vel.mag() > vel_mag) {
      acc = vel.copy();
      acc.normalize();
      acc.mult(-0.05);
    } else {
      acc.set(0, 0);
    }
    vel.add(acc);    
    vel.limit(10);
    pos.add(vel);
    
    //limite circular
    PVector center = new PVector(width/2, height/2);
    PVector radius = PVector.sub(pos, center);
    //diameter = map(radius.mag(),0,max_dist,8,2);
    //strokeW = map(radius.mag(),0,max_dist,3,0.5);

    if (radius.mag() >= diameter_canvas) {    
      pos.limit(center.mag()+diameter_canvas);
      vel.mult(-1);
      pos.add(vel);
    }

    //limite retangular
    //pos.x = constrain(pos.x, left, right);
    //pos.y = constrain(pos.y, up, down);
    //if (pos.x == left || pos.x == right) vel.x *= -1;
    //if (pos.y == up || pos.y == down) vel.y *= -1;


    updateConnectingDiameter();
    display();
  }

  void display() {
    //stroke(42, 162, 161, 150);
    stroke(0, 155, 151, 150);
    strokeWeight(strokeW);
    connect();
    noStroke();
    fill(255);
    ellipse(pos.x, pos.y, diameter, diameter);
  }


  void connect() {


    for (Blob b : blobs) {
      float distance = dist(pos.x, pos.y, b.cx, b.cy);
      if (distance < connecting_diameter) {
        //stroke(255, 0, 213, 120);
        //strokeWeight(0.8);
        line(pos.x, pos.y, b.cx, b.cy);
      }
    }


    for (int i = 0; i < particles.length; i++) {
      if (i==id) { //|| n_connections >= max_connections || particles[i].n_connections >= particles[i].max_connections 
        continue;
      } else {
        float distance = dist(pos.x, pos.y, particles[i].pos.x, particles[i].pos.y);
        if (distance <= connecting_diameter && connections[i][id] == 0) { //&& connections[i][id] == 0
          if (connections[i][id] == 0) {
            connections[id][i] = 1;
            connections[i][id] = 1;
          }
          //stroke(255, 40);
          //strokeWeight(strokeW);
          line(pos.x, pos.y, particles[i].pos.x, particles[i].pos.y);
          //TEXTO
          //fill(255, 150);
          //noStroke();
          //text(bairros[id%bairros.length], pos.x, pos.y-5); //+ " " + int(pos.x) + "," + int(pos.y
        } else {
          if (connections[i][id] == 1) {
            connections[id][i] = 0;
            connections[i][id] = 0;
          }
        }
      }
    }
  }

  void interactionMov(float x, float y, float d) {    

    //float vx = mouseX-pmouseX;
    //float vy = mouseY-pmouseY;
    //PVector add = new PVector(vx, vy);
    //add.mult(0.04);
    //vel.add(add);
    ////vel.limit(15);
    PVector blob = new PVector(x, y);
    PVector dif = PVector.sub(pos, blob);
    //dif.normalize();
    dif.div(d);
    vel.add(dif);
    vel.limit(6);
  }


  void updateConnectingDiameter() {

    for (Blob b : blobs) {
      float distance = dist(pos.x, pos.y, b.cx, b.cy);
      if (distance <= minimum_mouse_distance) {
        connecting_diameter = initial_cd;
        interactionMov(b.cx, b.cy, distance);
      } else if (connecting_diameter >= 5) {
        connecting_diameter -= 0.05;
      }
    }
  }
}