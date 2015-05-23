//Search page

public void displaySearchPage() {

  imageMode(CENTER);

  text("Tap square box to on/off camera", 50, 50);
  text("Search Flickr: ", 1200, (height/2) - 200);
  text("* If searcing a specific user's photos, input user's id number then", 1200, height/2);
  text("click 'By User id'.", 1220, (height/2) + 30);
  text("* If by tag, use '+' to separate tags (if more than one), then", 1200, (height/2)+100); 
  text("click 'By Tag'.", 1220, (height/2)+130);
  textSize(25);

  noFill();


  if (cam.isStarted()) {
    

    image(cam, 600, height/2, 1000, 800);
  }


  rectMode(CENTER);
  stroke(0, 255, 255);
  strokeWeight(10);
  rect(600, (height/2), 1100, 900);
}

public void modeOneWidgets() {
  mode1widgetContainer = new APWidgetContainer(this);
  captureButton = new APButton(1200, (height/2) - 200, "Capture");
  flickrButton = new APButton(1600, (height/2), "Flickr Search");
  searchFlickr = new APEditText(1200, (height/2), width/5, 150); 
  galleryButton = new APButton(1200, (height/2) + 200, "Gallery");
  mode1widgetContainer.addWidget(captureButton);
  mode1widgetContainer.addWidget(flickrButton);
  mode1widgetContainer.addWidget(galleryButton);
  mode1widgetContainer.addWidget(searchFlickr);
}

public void modeOneMousePressed() {

  //hideVirtualKeyboard();

  if (mouseX >= 0 && mouseX <= 1000 &&
    mouseY >= 100 && mouseY <= (height - 100)) {
    if (cam.isStarted()) {
      cam.stop();
    } else { 
      cam.start();
      cam.setCameraID(cameraID);
    }

    
  }
}

