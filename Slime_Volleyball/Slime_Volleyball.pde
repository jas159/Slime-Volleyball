import fisica.*;

boolean up, down, left, right, wkey, akey, skey, dkey;
boolean leftCanJump, rightCanJump, lresetGame, rresetGame;
FBox lground, rground, lwall, rwall, ceiling, net;
FCircle lplayer, rplayer, ball;
int timer, rscore, lscore;

color blue   = color(29, 178, 242);
color brown  = color(166, 120, 24);
color green  = color(74, 163, 57);
color red    = color(224, 80, 61);
color yellow = color(242, 215, 16);

FWorld world;

PImage sky, vball, earth, moon, space,sun;


void setup() {
  size(800, 600);

  vball = loadImage("vball.png");
  vball.resize(30, 30);
  sky = loadImage("sky.jpg");
  earth = loadImage("earth.png");
  earth.resize(75, 75);
  moon = loadImage("moon.png");
  moon.resize(75, 75);
  sun = loadImage("sun.png");
  sun.resize(75,75);
  space = loadImage("space.jpg");
  space.resize(400, 100);
  timer= 60;

  Fisica.init(this);
  world = new FWorld();
  world.setGravity(0, 900);

  //setup terrain
  lground = new FBox(400, 100);
  lground.setNoStroke();
  lground.setPosition(200, 575);
  lground.setStatic(true);
  lground.attachImage(space);
  world.add(lground);

  rground = new FBox(400, 100);
  rground.setNoStroke();
  rground.setPosition(600, 575);
  rground.setStatic(true);
  rground.attachImage(space);
  world.add(rground);

  lwall = new FBox (50, 1200);
  lwall.setNoStroke();
  lwall.setPosition(-25, 0);
  lwall.setStatic(true);
  lwall.setFill(0);
  world.add(lwall);

  rwall = new FBox (50, 1200);
  rwall.setNoStroke();
  rwall.setPosition(825, 0);
  rwall.setStatic(true);
  rwall.setFill(0);
  world.add(rwall);

  lplayer = new FCircle(75);
  lplayer.setNoStroke();
  lplayer.setPosition(200, 400);
  lplayer.setFill(224, 239, 241);
  lplayer.attachImage(earth);
  lplayer.setRotatable(false);
  lplayer.setFriction(0.9);
  world.add(lplayer);

  rplayer = new FCircle(75);
  rplayer.setNoStroke();
  rplayer.setPosition(600, 400);
  rplayer.setFill(6, 71, 128);
  rplayer.attachImage(moon);
  rplayer.setRotatable(false);
  rplayer.setFriction(0.9);
  world.add(rplayer);

  ball = new FCircle(30);
  ball.setNoStroke();
  ball.setRestitution(1);
  ball.setPosition(lplayer.getX(), 100);
  ball.setFill(255);
  ball.attachImage(vball);
  world.add(ball);

  net = new FBox(10, 75);
  net.setFill(255);
  net.setNoStroke();
  net.setPosition(400, 500);
  net.setStatic(true);
  world.add(net);

  ceiling = new FBox(800, 100);
  ceiling.setNoStroke();
  ceiling.setPosition(400, -50);
  ceiling.setStatic(true);
  world.add(ceiling);
}

void draw() {


  timer--;
  if (timer<0) {
    background(sky);


    leftCanJump = false;
    ArrayList<FContact> lcontacts = lplayer.getContacts();

    int i = 0;
    while (i < lcontacts.size()) {
      FContact c = lcontacts.get(i);
      if (c.contains(lground)) leftCanJump = true;
      i++;
    }
    //for (FContact c : contacts) {
    //  if (c.contains(lground)) leftCanJump = true;
    //}

    if (wkey && leftCanJump) lplayer.addImpulse(0, -2500);
    if (akey) lplayer.addImpulse(-200, 0);
    if (skey) ;
    if (dkey) lplayer.addImpulse(200, 0);

    rightCanJump = false;
    ArrayList<FContact> rcontacts = rplayer.getContacts();

    int j = 0;
    while (j < rcontacts.size()) {
      FContact c = rcontacts.get(j);
      if (c.contains(rground)) rightCanJump = true;
      j++;
    }

    if (lplayer.getX()>=375) {
      lplayer.setPosition(375, lplayer.getY());
    }

    if (rplayer.getX()<=425) {
      rplayer.setPosition(425, rplayer.getY());
    }

    if (up && rightCanJump) rplayer.addImpulse(0, -2500);
    if (left) rplayer.addImpulse(-200, 0);
    if (down) ;
    if (right) rplayer.addImpulse(200, 0);

    ArrayList<FContact> ballcontacts = ball.getContacts();

    int q = 0;
    while (q < ballcontacts.size()) {
      FContact c = ballcontacts.get(q);
      if (c.contains(lground)) {
        rscore++;
        ball.setVelocity(0, 0);
       timer = 60;
        if (timer>= 0) {
          ball.setPosition(600, 100);
          lplayer.setPosition(200, 485);
          lplayer.setVelocity(0, 0);
          rplayer.setPosition(600, 485 );
          rplayer.setVelocity(0, 0);
   
        }
      }
      if (c.contains(rground)) {
        lscore++;
        ball.setVelocity(0, 0);
             timer=60;
        if (timer >= 0) {
          ball.setPosition(200, 100);
          lplayer.setPosition(200, 485);
          lplayer.setVelocity(0, 0);
          rplayer.setPosition(600, 485 );
          rplayer.setVelocity(0, 0);
     
        }
      }
      q++;
    }
    world.step();
    world.draw();
  }

  fill(255);
  textSize(25);
  text("EARTH:"+lscore, 100, 100);
  text("MOON:"+rscore, 600, 100);

  if (lscore==3) {
    text("EARTH WINS", 320, 250);
    timer=100;
    timer++;
    text("restart", 350, 400);
    if (mousePressed) {
      lscore=0;
      rscore=0;
      lplayer.setPosition(200, 485);
      rplayer.setPosition(600, 485);
      ball.setPosition(200, 100);
      timer=60;
    }
  }
  if (rscore==3) {
    text("MOON WINS", 320, 250);
    text("restart", 350, 400);
    if (mousePressed) { 
      lscore=0;
      rscore=0;
      lplayer.setPosition(200, 485);
      rplayer.setPosition(600, 485);
      ball.setPosition(600, 100);
      timer=60;
    }

    timer=100;
    timer++;
  }
}



void keyPressed() {
  if (key == 'W' || key == 'w' ) wkey = true;
  if (key == 'S' || key == 's' ) skey = true;
  if (key == 'A' || key == 'a' ) akey = true;
  if (key == 'D' || key == 'd' ) dkey = true;
  if (keyCode == UP) up = true;
  if (keyCode == DOWN) down = true;
  if (keyCode == LEFT) left = true;
  if (keyCode == RIGHT) right = true;
}

void keyReleased() {
  if (key == 'W' || key == 'w' ) wkey = false;
  if (key == 'S' || key == 's' ) skey = false;
  if (key == 'A' || key == 'a' ) akey = false;
  if (key == 'D' || key == 'd' ) dkey = false;
  if (keyCode == UP) up = false;
  if (keyCode == DOWN) down = false;
  if (keyCode == LEFT) left = false;
  if (keyCode == RIGHT) right = false;
}
