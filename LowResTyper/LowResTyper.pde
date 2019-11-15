import controlP5.*;
import processing.serial.*;
import java.text.Normalizer;

final int NUM_TILES_X   = 10; // The number of tiles, make sure that the NUM_TILES const
final int NUM_TILES_Y   = 1; // has the correct value in the slave program
final int NUM_TILES = NUM_TILES_X * NUM_TILES_Y;
final int MATRIX_WIDTH  = 32;
final int MATRIX_HEIGHT = 32;
final int NUM_CHANNELS  = 3;

// Offset and size of the preview
int preview_size = 4;
int ox = 120;
int oy = 60;

int scroll_speed = 15;

ArrayList<Serial> serials;
PGraphics tex;

// Max letters
int max_keys = 30;
LetterManager manager;
HashMap<String, ArrayList> sequences = new HashMap<String, ArrayList>();

PApplet parent = this;
// GUI options
Boolean raster = false;
int raster_threshold = 100;

ControlP5 cp5;
boolean synced = false;
boolean smooth_scrolling = false;
boolean kinetic = false;
int kinetic_delay = 20;

byte[][] buffers;
boolean[] buffer_flags;
int currentThread = 0;

void setup() {
  size(1440, 420, P2D);
  noSmooth();
  textFont(loadFont("mono.vlw"));
  
  tex = createGraphics(NUM_TILES_X * MATRIX_WIDTH, NUM_TILES_Y * MATRIX_HEIGHT, P2D);
  manager = new LetterManager();

  // Init serial(s)
  serials = new ArrayList<Serial>();
  scanSerial();
  // serial = new Serial(this, "COM3"); // Windows

  // Init buffer(s) and flag(s)
  buffers = new byte[serials.size()][];
  buffer_flags = new boolean[serials.size()];

  for (int k = 0; k < serials.size(); k++) 
    buffer_flags[k] = true;


  folderRetrieve(); //Retrieve images from folders
  setupGUI(); // Init GUI
}

void draw() {
  // Render something to a render target
  tex.beginDraw();
  tex.background(0);

  manager.update();
  manager.display(tex);

  tex.endDraw();
  tex.loadPixels();

  if (serials.size() > 0) {
    int even_split = ceil((float)NUM_TILES/serials.size()); //serial size instead
    int split = floor((float)NUM_TILES/serials.size()); //serial size instead

    for (int k = 0; k < serials.size(); k++) {
      if (serials.get(k) != null) {
        int start_range = k == 0 ? 0 : even_split + ((k-1) * split);
        int end_range = even_split + (k * split);

        int buffer_length = (end_range-start_range) * MATRIX_WIDTH * MATRIX_HEIGHT * NUM_CHANNELS;

        buffers[k] = new byte[buffer_length];

        int idx = 0;
        for (int i=start_range; i<end_range; i++) {
          int x_index = i % NUM_TILES_X;
          int y_index = (floor(i/NUM_TILES_X));
          PImage tmp = tex.get(x_index * MATRIX_WIDTH, y_index * MATRIX_HEIGHT, MATRIX_WIDTH, MATRIX_HEIGHT);

          for (color c : tmp.pixels) {
            if (raster)
              c = brightness(c) > raster_threshold ? color(255) : color(0);
            buffers[k][idx++] = (byte)(c >> 16 & 0xFF);
            buffers[k][idx++] = (byte)(c >> 8 & 0xFF);
            buffers[k][idx++] = (byte)(c & 0xFF);
          }
        }
        
        if (buffer_flags[k]) {
          buffer_flags[k] = false;
          currentThread = k;
          thread("serialWrite"); 
        }
      }
    }
  }

  // Preview
  background(80);

  // Grid background
  fill(0);
  noStroke();
  rect(ox, oy, tex.width * preview_size, tex.height * preview_size);

  // LEDs

  for (int j=0; j<tex.height; j++) {
    for (int i=0; i<tex.width; i++) {
      int idx = i + j * tex.width;
      color c = tex.pixels[idx];

      if (raster)
        c = brightness(c) > raster_threshold ? color(255) : color(0);     // CHange to color pixels

      fill(c);
      int x = ox + i * preview_size;
      int y = oy + j * preview_size;
      rect(x, y, preview_size-1, preview_size-1);
    }
  }
  // Matrix outline
  noFill();
  for (int j=0; j<NUM_TILES_Y; j++) {
    for (int i=0; i<NUM_TILES_X; i++) {
      int x = i * MATRIX_WIDTH * preview_size + ox;
      int y = j * MATRIX_HEIGHT * preview_size + oy;
      stroke(255);
      rect(x, y, MATRIX_WIDTH * preview_size, MATRIX_HEIGHT * preview_size);
    }
  }

  // Oscillator - No display Oscillator in Smooth Scrolling Mode
  if (!smooth_scrolling) {
    if (manager.keys.size() == 0 || manager.last_element_index > 0 && manager.last_element_index < NUM_TILES) {
      float oscillator = abs(sin(frameCount * 0.075) * 255);
      stroke(255, oscillator, oscillator);
      int x = ox + (manager.last_element_index % NUM_TILES_X) * (MATRIX_WIDTH * preview_size);
      int y = oy + (manager.last_element_index / NUM_TILES_X) * (MATRIX_HEIGHT * preview_size);
      rect(x, y, 1, MATRIX_HEIGHT * preview_size);
    }
  }

  updateGUI();
}

void keyPressed()
{
  if (key == BACKSPACE) {
    manager.removeLetter();
  } else if (key == ' ') {
    manager.addLetter("-");
  } else if (Character.isLetter(key) || Character.isDigit(key) || key == '\'') {
    
    String ck = key == '\'' ? "'": stripAccents(Character.toString(key).toUpperCase());
    manager.addLetter(ck);
  }
}

void serialWrite() {
  int thread = currentThread;
  serials.get(thread).write('*');      // The 'data' command
  serials.get(thread).write(buffers[thread]);      // ...and the pixel values
  buffer_flags[thread] = true;
}
