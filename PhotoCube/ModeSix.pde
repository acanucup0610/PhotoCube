//Photo editing mode

public void editDisplay(){
  text("Edit a Photo", (width/2)+150, 70);
  
 
  textSize(50);
  
  thumbRatio = width/height;


  resizeImage(overviewPhotoList.get(photoToEdit));
  imageMode(CENTER);
  
  image(overviewPhotoList.get(photoToEdit), (width/4) + 30, height/2, thumbWidth, thumbHeight);
  
}





