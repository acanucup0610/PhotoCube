//Display Mode

public void displayLoadCube() {
  
  text("Displaying Cube", 50, 120); 
  textSize(50);

  translate(width/2, height/2);

  rotateX(rotX + distY);
  rotateY(rotY + distX);

  scale(300, 300, 300);
  
  displayCube.display();
  if (!beg) {
    for (int i = 0; i < 6; i++) {

      if (selectedImages[i] != -1) {
        try {  
          displayCube.setTexture(i, overviewPhotoList.get(selectedImages[i]));
        }
        catch (Exception e) {
          print(e);
        }
      }
    }
  } else {
    

    
    displayCube.setTexture(0, f1);
    displayCube.setTexture(1, f2);
    displayCube.setTexture(2, f3);
    displayCube.setTexture(3, f4);
    displayCube.setTexture(4, f5);
    displayCube.setTexture(5, f6);
  }





  //   displayCube.setTexture(1, overviewPhotoList.get(currentOverviewThumbnails[selectedImage]));
}

