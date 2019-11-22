PVector fontSize = new PVector(MATRIX_WIDTH, MATRIX_HEIGHT);
int gliph_w = 5;
int gliph_h = 8;
ArrayList<PImage> font_table;

void setupGUI() {
  int space = 50;
  cp5 = new ControlP5(this);
  cp5.setColorBackground(color(255, 255, 255, 30)).setColorActive(color(255)).setColorForeground(color(255, 255, 255, 60));
  cp5.addToggle("synced").setPosition(20, oy).setSize(20, 20).setCaptionLabel("Synchronize");
  cp5.addToggle("smooth_scrolling").setPosition(20, oy + space).setSize(20, 20).setCaptionLabel("Smooth Scrolling");
  cp5.addSlider("scroll_speed").setPosition(20, oy + space*1.75).setSize(80, 10).setRange(40, 5).setCaptionLabel("Speed").setSliderMode(0);
  cp5.addToggle("raster").setPosition(20, oy + space*2.5).setSize(20, 20).setCaptionLabel("Rasterize");
  cp5.addSlider("raster_threshold").setPosition(20, oy + space*3.25).setSize(80, 10).setRange(255, 10).setCaptionLabel("Threshold").setSliderMode(0);
  cp5.addToggle("kinetic").setPosition(20, oy + space*4).setSize(20, 20).setCaptionLabel("Kinetic");
  //cp5.addSlider("kinetic_delay").setPosition(20, oy + space*4.75).setSize(80, 10).setRange(60, 0).setCaptionLabel("Delay").setSliderMode(0).setValue(kinetic_delay);

  // reposition the Label for controller 'slider'
  cp5.getController("scroll_speed").getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  cp5.getController("scroll_speed").getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);

  cp5.getController("raster_threshold").getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  cp5.getController("raster_threshold").getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);

  //cp5.getController("kinetic_delay").getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  //cp5.getController("kinetic_delay").getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);

  // Default font
  font_table = new ArrayList();
  PImage lcd = loadImage("lcd.png");
  for (int j=0; j<16; j++) {
    for (int i=0; i<8; i++) {
      PImage t = lcd.get(1 + i * (gliph_w + 1), 1 + j * (gliph_h + 1), gliph_w, gliph_h);
      font_table.add(t);
    }
  }
}

void updateGUI() {
  pushStyle();
  fill(255);
  noStroke();
  ellipseMode(CENTER);

  text(frameRate, 20, 30);

  cp5.getController("raster_threshold").hide();
  if (raster)
    cp5.getController("raster_threshold").show();
  
  /*
  cp5.getController("kinetic_delay").hide();
  if (kinetic)
    cp5.getController("kinetic_delay").show();
  */

  int pills_space = 8;
  for (int k = manager.keys.size() - 1; k >= 0; k--) {
    fill(255, 255, 255, 100);

    if (manager.keys.get(k).visible)
      fill(255);

    ellipse(ox + pills_space*k, 30, 4, 4);

    if (k == manager.keys.size() - 1) {
      fill(255, 0, 0);
      ellipse(pills_space + ox + pills_space*k, 30, 4, 4);
    }
  }
  popStyle();
}

void synced() {
  synced = !synced;
  if (synced)
    manager.syncLetters();
}

void raster() {
  raster = !raster;
}

void smooth_scrolling() {
  smooth_scrolling = !smooth_scrolling;
}

void kinetic() {
  kinetic = !kinetic;
  if (kinetic)
    manager.syncKinetic();
}

void kinetic_delay() {
  manager.syncKinetic();
}
