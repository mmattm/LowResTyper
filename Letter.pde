public class Letter extends Key {

  PFont font;
  int anim_pos;
  float scroll_position = 0;

  public Letter(String _id)
  {
    super(_id);
    println("add letter: " + id);
  }

  void update()
  {
    if (sequences.get(id.toLowerCase()) != null) {
      if (anim_pos == sequences.get(id.toLowerCase()).size()-1 && !synced) 
        anim_pos = 0;

      //if (frameCount % 2 == 0)
      anim_pos++;

      anim_pos = min(anim_pos, sequences.get(id.toLowerCase()).size()-1);
    }
  }

  void display(PGraphics target, PVector position)
  {
    PVector center = single_mode ? new PVector((NUM_TILES_X*MATRIX_WIDTH)/2, (NUM_TILES_Y*MATRIX_HEIGHT)/2) : new PVector(position.x + (MATRIX_WIDTH/2 - gliph_w/2), position.y + (MATRIX_HEIGHT/2 - gliph_h/2));

    target.image(font_table.get(id.charAt(0)), center.x, center.y);

    if (sequences.get(id.toLowerCase()) != null) {
      target.image((PImage)sequences.get(id.toLowerCase()).get(anim_pos), position.x, position.y, 32, 32);
    }
  }

  void sync() {
    anim_pos = 0;
  }

  boolean isEnded() {
    return anim_pos == sequences.get(id.toLowerCase()).size()-1 ? true : false;
  }

  boolean isMovie() {
    return sequences.get(id.toLowerCase()) != null ? true : false;
  }
}
