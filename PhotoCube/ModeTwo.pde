//Gallery of all collected Images

public void displayGallery(){
  text("Gallery photos", 50, 120);
  
  
  //Put inside a condition statement, to show up if face buttons are clicked
  //text("Double tap a photo to add to collected photos", (width/3), height - 80);
 
  textSize(50);
  
  try {

    displayGalleryThumbnails();
    
  }
  catch (Exception e) {
    print(e);
  }
  
}

void drawGalleryImages(int[] galleryThumbnail) {


  //The width being divided to 5 for each 5 images
  //while height/2 is so each of the images are at the center. 


  int offset;
  if (toGalleryRight) { //right animated transition
    offset = -5;
  } else {       //left animated transition
    offset = 5;
  }

//  //Drawing each images
//  int sizeThumbnail;
//  if (galleryPhotoList.size() >= 5){
//     sizeThumbnail = 5;
//  }else {
//      sizeThumbnail = galleryPhotoList.size();
//  }
  
  for (int i = 0; i < 5; i++) {
    //first set of 5 images
    resizeImage(galleryPhotoList.get(currentGalleryThumbnails[i]));
    image((PImage) (galleryPhotoList.get(currentGalleryThumbnails[i])), ((offset + (animate/60)) * (width/5)) + ((width/5)/2), height/2, thumbWidth, thumbHeight);
    offset++; 

    //second set of 5 images, from either left or right
    resizeImage(galleryPhotoList.get(galleryThumbnail[i]));
    image((PImage) (galleryPhotoList.get(galleryThumbnail[i])), ((i + (animate/60)) * (width/5)) + ((width/5)/2), height/2, thumbWidth, thumbHeight);
  }
}

void displayGalleryThumbnails() {


  //Manually sets the 5 thumbnail images in an array and loops
  //it back once it reaches its end.

  //| 0 | 1 | 2 | 3 | 4 | 



  int [] galleryThumbnail = new int [5];
  imageMode(CENTER);

  if (leftmost >= 0 && leftmost <= galleryPhotoList.size() -5) {
    galleryThumbnail[0] = leftmost;
    galleryThumbnail[1] = leftmost + 1;
    galleryThumbnail[2] = leftmost + 2;
    galleryThumbnail[3] = leftmost + 3;
    galleryThumbnail[4] = leftmost + 4;
    drawGalleryImages(galleryThumbnail);
  } else if (leftmost==galleryPhotoList.size() -4) {
    galleryThumbnail[0] = leftmost;
    galleryThumbnail[1] = leftmost + 1;
    galleryThumbnail[2] = leftmost + 2;
    galleryThumbnail[3] = leftmost + 3;
    galleryThumbnail[4] = 0;
    drawGalleryImages(galleryThumbnail);
  } else if (leftmost==galleryPhotoList.size() -3) {
    galleryThumbnail[0] = leftmost;
    galleryThumbnail[1] = leftmost + 1;
    galleryThumbnail[2] = leftmost + 2;
    galleryThumbnail[3] = 0;
    galleryThumbnail[4] = 1;
    drawGalleryImages(galleryThumbnail);
  } else if (leftmost==galleryPhotoList.size() -2) {
    galleryThumbnail[0] = leftmost;
    galleryThumbnail[1] = leftmost + 1;
    galleryThumbnail[2] = 0;
    galleryThumbnail[3] = 1;
    galleryThumbnail[4] = 2;
    drawGalleryImages(galleryThumbnail);
  } else if (leftmost==galleryPhotoList.size() -1 || leftmost == -1) {
    leftmost = galleryPhotoList.size() - 1;
    galleryThumbnail[0] = leftmost;
    galleryThumbnail[1] = 0;
    galleryThumbnail[2] = 1;
    galleryThumbnail[3] = 2;
    galleryThumbnail[4] = 3;
    drawGalleryImages(galleryThumbnail);
  }

  //Iteration for animated transition
  //setting it up that when animate is equal to 0, the animation would stop
  //From http://unixlab.sfsu.edu/~whsu/csc690/P5AndroidEx/slidingBox.pde
  if (animate > 0) {
    animate -=20;
  } else if (animate < 0) {
    animate +=20;
  } else {
    currentGalleryThumbnails = galleryThumbnail;
  }
}

void nextGalleryRight() {

  toGalleryRight = true;
  animate = 300;
  leftmost = leftmost + 5;

  if (leftmost > galleryPhotoList.size() - 1) {
    leftmost = leftmost - galleryPhotoList.size();
  }
}

void nextGalleryLeft() {

  toGalleryRight = false;
  animate = -300;
  leftmost = leftmost - 5;
  if (leftmost < 0) {
    leftmost = galleryPhotoList.size() + leftmost;
  }
}
