//Mode 5 Display Preview and assign faces

public void assignFaces() {
  text("Preview", 50, 120);

  translate(width/3, height/2);
  noStroke();
  previewCube.display();
  fill(255, 255, 255);


  rotateX(rotX + distY);
  rotateY(rotY + distX);
  scale(200, 200, 200);

  previewCube.setTexture(0, one);
  previewCube.setTexture(1, two);
  previewCube.setTexture(2, three);
  previewCube.setTexture(3, four);
  previewCube.setTexture(4, five);
  previewCube.setTexture(5, six);

 

  //Previewing new texture
  for (int i = 0; i < 6; i++) {
    if (selectedImages[i] != -1) {
      try {  
        PImage img = overviewPhotoList.get(selectedImages[i]);
        int w = img.width;
        int h = img.height;
        PImage newImage = createImage(w, h, RGB);
        newImage = img.get();
        newImage.save("outputImage" + i + ".jpg");
        
        previewCube.setTexture(i, overviewPhotoList.get(selectedImages[i]));
      }
      catch (Exception e) {
        print(e);
      }
    }
  }
}

