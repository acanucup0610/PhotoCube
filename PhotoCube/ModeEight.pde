//Display of edited/filtered photo

public void editedPhoto(){
  text("Filtered Photo", (width/2)+150, 70);
  
 
  textSize(50);
  
  thumbRatio = width/height;


  resizeImage(newEdit);
  imageMode(CENTER);
  
  image(newEdit, (width/4) + 30, height/2, thumbWidth, thumbHeight);
  
}
