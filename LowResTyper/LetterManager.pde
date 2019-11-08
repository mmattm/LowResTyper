import java.util.*;

class LetterManager {
  ArrayList<Key> keys;
  int start_index = 0;
  int last_element_index = 0;
  float pos_offset = 0;
  int smooth_scrolling_clones = 3;

  LetterManager()
  {
    keys = new ArrayList<Key>();
  }

  void addLetter(String id)
  {
    if (single_mode) {
      keys = new ArrayList<Key>();
      Key symbol = new Letter(id);
      keys.add(symbol);
    } else {
      if (keys.size() <= max_keys)
        keys.add(id.equals("-") ? new Space(id) : new Letter(id));
    }
  }

  void removeLetter()
  {
    //LETTER
    if (keys.size() > 0) {
      keys.remove(keys.size()-1);
    }
  }

  void update()
  {
    boolean allMoviesEnded = true;

    for (int k = 0; k < keys.size(); k++) {
      keys.get(k).update();
      keys.get(k).visible = false;

      // Check if it is a movie or continue
      if (!keys.get(k).isMovie())
        continue;

      // Check if all movies are ended
      if (!keys.get(k).isEnded())
        allMoviesEnded = false;
    }

    if (synced && allMoviesEnded) {
      for (int k = 0; k < keys.size(); k++) {
        keys.get(k).sync();
      }
    }

    // Each interval of scroll speed shifting the list
    if (frameCount % scroll_speed == 0 )
      start_index = keys.size() > NUM_TILES ? (start_index + 1) % keys.size() : 0;
  }

  void display(PGraphics target)
  {
    pushMatrix();
    //LETTERS
    last_element_index = 0;
    if (smooth_scrolling && keys.size() > 2) {
      
      float x = 0;
      
      for (int i=0; i<smooth_scrolling_clones; i++) {
        for (int k = 0; k < keys.size(); k++) {
          PVector keyPosition = new PVector((k* MATRIX_WIDTH) + x -pos_offset, 0);
          if (keyPosition.x > 0 && keyPosition.x < NUM_TILES * MATRIX_WIDTH)
            keys.get(k).visible = true;

          keys.get(k).display(target, keyPosition);
        }
        x += keys.size()*MATRIX_WIDTH;
      }
      pos_offset += scroll_speed*0.05;
      float tw1 = keys.size()*MATRIX_WIDTH;
      if (pos_offset >= tw1) {
        pos_offset -= tw1;
      }
    } else {
      pos_offset = 0;
      for (int k = 0; k < min(keys.size(), NUM_TILES); k++) {
        int current_index = (start_index + k) % keys.size();
        PVector keyPosition = new PVector((k % NUM_TILES_X) * MATRIX_WIDTH, (k / NUM_TILES_X) * MATRIX_HEIGHT);
        keys.get(current_index).display(target, keyPosition);
        keys.get(current_index).visible = true;

        if (keys.get(current_index) == keys.get(keys.size()-1))
          last_element_index = k+1;
      }
    }

    popMatrix();
  }

  void syncLetters()
  {
    for (int k = 0; k < keys.size(); k++) {
      keys.get(k).sync();
    }
  }
}
