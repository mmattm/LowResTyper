public class Space extends Key {

  public Space(String _id)
  {
    super(_id);
    println("add space");
  }

  void update()
  {
  }

  void display(PGraphics target, PVector position)
  {
  }

  void sync() {
  }
  
  void syncKinetic(int position) {
}

  boolean isEnded() {
    return false;
  }

  boolean isMovie() {
    return false;
  }
}
