public abstract class Key {
String id;
int pos;
boolean visible;

public Key(String _id)
{
	id = _id;
}

abstract void update();
abstract void display(PGraphics target, PVector position);
abstract void sync();
abstract void syncKinetic(int position);
abstract boolean isEnded();
abstract boolean isMovie();
}
