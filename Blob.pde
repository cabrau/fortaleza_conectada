// Daniel Shiffman
// http://codingtra.in
// http://patreon.com/codingtrain
// Code for: https://youtu.be/ce-2l2wRqO8

class Blob {
  float minx;
  float miny;
  float maxx;
  float maxy;
  float distThreshold;
  float cx, cy, pcx, pcy;
  float vx, vy;
  //color c = color(0, 155, 151, 60); //0, 155, 151, 60
  color c = color(255,0,213,5);

  Blob(float x, float y, float d) {
    minx = x;
    miny = y;
    maxx = x;
    maxy = y;
    distThreshold = d;
    cx = x;
    cy = y;
    pcx = x;
    pcy = y;
  }

  void show() {
    //noFill();
    //stroke(255);
    //strokeWeight(1);
    //rectMode(CORNERS);
    //rect(minx, miny, maxx, maxy);

    for (Blob b : blobs) {
      float distance = dist(cx, cy, b.cx, b.cy);
      if (distance < 30) {
        //stroke(255,0,213,100);
        stroke(255,25);
        strokeWeight(1);
        line(cx, cy, b.cx, b.cy);
      }
    }

    noStroke();
    fill(c);
    ellipse(cx, cy, 50, 50);
    fill(255);
    //ellipse(cx, cy, 2, 2);
  }

  void add(float x, float y) {
    minx = min(minx, x);
    miny = min(miny, y);
    maxx = max(maxx, x);
    maxy = max(maxy, y);
    pcx = cx;
    pcy = cy;
    cx = (minx + maxx) / 2;
    cy = (miny + maxy) / 2;
  }

  float size() {
    return (maxx-minx)*(maxy-miny);
  }

  boolean isNear(float x, float y) {

    float d = distSq(cx, cy, x, y);
    if (d < distThreshold*distThreshold) {
      return true;
    } else {
      return false;
    }
  }
}

float distSq(float x1, float y1, float x2, float y2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1);
  return d;
}


float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
  return d;
}