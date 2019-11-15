import java.io.File;
import java.io.FileFilter;

char availables[] = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9','a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '-', '\''};
boolean spaceExists;

String myFolder = "sequences";

void folderRetrieve()
{
  String path = sketchPath() + "/data/" + myFolder;

  FileFilter fileFilter;

  fileFilter = new FileFilter() {
    public boolean accept(File file) {
      return file.isDirectory();
    }
  };

  File file = new File(path);
  File[] folders = file.listFiles(fileFilter);

  fileFilter = new FileFilter() {
    public boolean accept(File file) {
      boolean bol = false;
      if (file.getName().toLowerCase().endsWith(".jpg") || file.getName().toLowerCase().endsWith(".png") || file.getName().toLowerCase().endsWith(".gif")) bol = true;
      return bol;
    }
  };

  for (int k = 0; k < folders.length; k++) {
    for (int l = 0; l < availables.length; l++) {
      String available = Character.toString(availables[l]);
      if (folders[k].getName().equals(available)) {
        println("Load : " + available);

        ArrayList temp_images = new ArrayList<PImage>();

        File[] images = folders[k].listFiles(fileFilter);

        if (images.length > 0) {

          String[] paths;
          paths = new String[images.length];

          for (int f = 0; f < images.length; f++) {
            String fPath = myFolder + "/" + folders[k].getName() + "/" + images[f].getName();
            paths[f] = fPath;
          }
          Arrays.sort(paths); 

          for (int f = 0; f < paths.length; f++) {
            temp_images.add(loadImage(paths[f]));
          }
          //Collections.sort(temp_images); 

          sequences.put(available, temp_images);
        } else {
          println ("-> No images in this folder");
        }
      }
    }
  }
}
