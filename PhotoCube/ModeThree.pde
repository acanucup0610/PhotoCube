//Flickr Mode Result

public void displayFlickrResult() {
  
  textSize(60);
  text("Flickr Photos", (width/2) - 100, 100);
  textSize(40);
  text("Filter Photos by date", 55, 130);
  text("Double tap a photo to add to collected photos", (width/3)+100, height - 80);
  text("From:", 200, 250);
  text("Til:", 830, 250);
  textSize(30);
  text("Date format: (YYYY-MM-DD)", 55, 165);

 

  try {

    displayFlickrThumbnails();
  }
  catch (Exception e) {
    //print(e);
  }
}



void getFlickrData() {

  String api  = "https://api.flickr.com/services/rest/?method=flickr.photos.search&";
  //tag = searchFlickr.getText();
  print(tag);
  print(sort);
  print("User id is: " + userID);
  print("minimum date " + minDate);
  print("maximum date " + maxDate);
  // next line gets recently uploaded photos
  //api  = "https://api.flickr.com/services/rest/?method=flickr.photos.getRecent&";
  String request = api + "&per_page=12&format=json&nojsoncallback=1&extras=geo";
  request += "&api_key=" + "7370c9aad12736d88bf11a8fe485dae5"; 

  //String userId = "88935360@N05"; // 690 test
  request += "&user_id=" + userID;
  request += "&max_upload_date=" + minDate;
  request += "&min_upload_date=" + maxDate;
  //request += "&bbox=-125,32,-120,40";
  //request += "&lat=38";
  //request += "&lon=-122";
 
  request += "&sort=" + sort;
  request += "&tags=" + tag;
  println("Sent request: " + request);
  JSONObject json = JSONObject.parse(loadStrings(request)[0]);
  println("Received from flickr: " + json);

  JSONObject photos = json.getJSONObject("photos");
  JSONArray photo = photos.getJSONArray("photo");
  println("Found " + photo.size() + " photos");
  for (int i=0; i<photo.size (); i++) {
    JSONObject pic = photo.getJSONObject(i);
    // get parameters to construct url
    int farm = pic.getInt("farm");
    String server = pic.getString("server");
    String id = pic.getString("id");
    String secret = pic.getString("secret");
    String url = "http://farm"+farm+".static.flickr.com/"+server+"/"+id+"_"+secret+".jpg";
    String title = pic.getString("title");
    println("Photo " + i + " " + title + " " + url);
    PImage img = loadImage(url);

    resizeImage(img);
    img.loadPixels();

    flickrPhotoList.add(img);
  }
  println("Added " + photo.size() + " photos");
}

void drawFlickrImages(int[] flickrThumbnail) {


  //The width being divided to 5 for each 5 images
  //while height/2 is so each of the images are at the center. 


  int offset;
  if (toFlickrRight) { //right animated transition
    offset = -5;
  } else {       //left animated transition
    offset = 5;
  }

  //Drawing each images
  for (int i = 0; i < 5; i++) {
    //first set of 5 images
    resizeImage(flickrPhotoList.get(currentFlickrThumbnails[i]));
    image((PImage) (flickrPhotoList.get(currentFlickrThumbnails[i])), ((offset + (animate/60)) * (width/5)) + ((width/5)/2), height/2, thumbWidth, thumbHeight);
    offset++; 

    //second set of 5 images, from either left or right
    resizeImage(flickrPhotoList.get(flickrThumbnail[i]));
    image((PImage) (flickrPhotoList.get(flickrThumbnail[i])), ((i + (animate/60)) * (width/5)) + ((width/5)/2), height/2, thumbWidth, thumbHeight);
  }
}

void displayFlickrThumbnails() {


  //Manually sets the 5 thumbnail images in an array and loops
  //it back once it reaches its end.

  //| 0 | 1 | 2 | 3 | 4 | 



  int [] flickrThumbnail = new int [5];
  imageMode(CENTER);

  if (leftmost >= 0 && leftmost <= flickrPhotoList.size() -5) {
    flickrThumbnail[0] = leftmost;
    flickrThumbnail[1] = leftmost + 1;
    flickrThumbnail[2] = leftmost + 2;
    flickrThumbnail[3] = leftmost + 3;
    flickrThumbnail[4] = leftmost + 4;
    drawFlickrImages(flickrThumbnail);
  } else if (leftmost==flickrPhotoList.size() -4) {
    flickrThumbnail[0] = leftmost;
    flickrThumbnail[1] = leftmost + 1;
    flickrThumbnail[2] = leftmost + 2;
    flickrThumbnail[3] = leftmost + 3;
    flickrThumbnail[4] = 0;
    drawFlickrImages(flickrThumbnail);
  } else if (leftmost==flickrPhotoList.size() -3) {
    flickrThumbnail[0] = leftmost;
    flickrThumbnail[1] = leftmost + 1;
    flickrThumbnail[2] = leftmost + 2;
    flickrThumbnail[3] = 0;
    flickrThumbnail[4] = 1;
    drawFlickrImages(flickrThumbnail);
  } else if (leftmost==flickrPhotoList.size() -2) {
    flickrThumbnail[0] = leftmost;
    flickrThumbnail[1] = leftmost + 1;
    flickrThumbnail[2] = 0;
    flickrThumbnail[3] = 1;
    flickrThumbnail[4] = 2;
    drawFlickrImages(flickrThumbnail);
  } else if (leftmost==flickrPhotoList.size() -1 || leftmost == -1) {
    leftmost = flickrPhotoList.size() - 1;
    flickrThumbnail[0] = leftmost;
    flickrThumbnail[1] = 0;
    flickrThumbnail[2] = 1;
    flickrThumbnail[3] = 2;
    flickrThumbnail[4] = 3;
    drawFlickrImages(flickrThumbnail);
  }

  //Iteration for animated transition
  //setting it up that when animate is equal to 0, the animation would stop
  //From http://unixlab.sfsu.edu/~whsu/csc690/P5AndroidEx/slidingBox.pde
  if (animate > 0) {
    animate -=20;
  } else if (animate < 0) {
    animate +=20;
  } else {
    currentFlickrThumbnails = flickrThumbnail;
  }
}

void nextFlickrRight() {

  toFlickrRight = true;
  animate = 300;
  leftmost = leftmost + 5;

  if (leftmost > flickrPhotoList.size() - 1) {
    leftmost = leftmost - flickrPhotoList.size();
  }
}

void nextFlickrLeft() {

  toFlickrRight = false;
  animate = -300;
  leftmost = leftmost - 5;
  if (leftmost < 0) {
    leftmost = flickrPhotoList.size() + leftmost;
  }
}

