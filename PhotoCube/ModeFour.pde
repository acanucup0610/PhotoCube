//Overview of all collected Images

public void displayOverviewResult(){
  text("Overview of all collected photos", 50, 120);
  
  
  //Put inside a condition statement, to show up if face buttons are clicked
  text("Long press a photo to edit", (width/3), height - 80);
 
  textSize(50);
  
  try {

    displayOverviewThumbnails();
    
  }
  catch (Exception e) {
    print(e);
  }
  
}

void drawOverviewImages(int[] overviewThumbnail) {


  //The width being divided to 5 for each 5 images
  //while height/2 is so each of the images are at the center. 


  int offset;
  if (toOverviewRight) { //right animated transition
    offset = -5;
  } else {       //left animated transition
    offset = 5;
  }

  //Drawing each images
  int sizeThumbnail;
  if (overviewPhotoList.size() >= 5){
     sizeThumbnail = 5;
  }else {
      sizeThumbnail = overviewPhotoList.size();
  }
  
  for (int i = 0; i < sizeThumbnail; i++) {
    //first set of 5 images
    resizeImage(overviewPhotoList.get(currentOverviewThumbnails[i]));
    image((PImage) (overviewPhotoList.get(currentOverviewThumbnails[i])), ((offset + (animate/60)) * (width/5)) + ((width/5)/2), height/2, thumbWidth, thumbHeight);
    offset++; 

    //second set of 5 images, from either left or right
    resizeImage(overviewPhotoList.get(overviewThumbnail[i]));
    image((PImage) (overviewPhotoList.get(overviewThumbnail[i])), ((i + (animate/60)) * (width/5)) + ((width/5)/2), height/2, thumbWidth, thumbHeight);
  }
}

void displayOverviewThumbnails() {


  //Manually sets the 5 thumbnail images in an array and loops
  //it back once it reaches its end.

  //| 0 | 1 | 2 | 3 | 4 | 



  int [] overviewThumbnail = new int [5];
  imageMode(CENTER);

  if (leftmost >= 0 && leftmost <= overviewPhotoList.size() -5) {
    overviewThumbnail[0] = leftmost;
    overviewThumbnail[1] = leftmost + 1;
    overviewThumbnail[2] = leftmost + 2;
    overviewThumbnail[3] = leftmost + 3;
    overviewThumbnail[4] = leftmost + 4;
    drawOverviewImages(overviewThumbnail);
  } else if (leftmost==overviewPhotoList.size() -4) {
    overviewThumbnail[0] = leftmost;
    overviewThumbnail[1] = leftmost + 1;
    overviewThumbnail[2] = leftmost + 2;
    overviewThumbnail[3] = leftmost + 3;
    overviewThumbnail[4] = 0;
    drawOverviewImages(overviewThumbnail);
  } else if (leftmost==overviewPhotoList.size() -3) {
    overviewThumbnail[0] = leftmost;
    overviewThumbnail[1] = leftmost + 1;
    overviewThumbnail[2] = leftmost + 2;
    overviewThumbnail[3] = 0;
    overviewThumbnail[4] = 1;
    drawOverviewImages(overviewThumbnail);
  } else if (leftmost==overviewPhotoList.size() -2) {
    overviewThumbnail[0] = leftmost;
    overviewThumbnail[1] = leftmost + 1;
    overviewThumbnail[2] = 0;
    overviewThumbnail[3] = 1;
    overviewThumbnail[4] = 2;
    drawOverviewImages(overviewThumbnail);
  } else if (leftmost==overviewPhotoList.size() -1 || leftmost == -1) {
    leftmost = overviewPhotoList.size() - 1;
    overviewThumbnail[0] = leftmost;
    overviewThumbnail[1] = 0;
    overviewThumbnail[2] = 1;
    overviewThumbnail[3] = 2;
    overviewThumbnail[4] = 3;
    drawOverviewImages(overviewThumbnail);
  }

  //Iteration for animated transition
  //setting it up that when animate is equal to 0, the animation would stop
  //From http://unixlab.sfsu.edu/~whsu/csc690/P5AndroidEx/slidingBox.pde
  if (animate > 0) {
    animate -=20;
  } else if (animate < 0) {
    animate +=20;
  } else {
    currentOverviewThumbnails = overviewThumbnail;
  }
}

void nextOverviewRight() {

  toOverviewRight = true;
  animate = 300;
  leftmost = leftmost + 5;

  if (leftmost > overviewPhotoList.size() - 1) {
    leftmost = leftmost - overviewPhotoList.size();
  }
}

void nextOverviewLeft() {

  toOverviewRight = false;
  animate = -300;
  leftmost = leftmost - 5;
  if (leftmost < 0) {
    leftmost = overviewPhotoList.size() + leftmost;
  }
}
