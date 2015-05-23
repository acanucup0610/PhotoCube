//Mode Zero - Start Page

public void displayStartPage() {
  
  text("PhotoCube", 50, 120);
 
  textSize(150);
  
  //Drawing centered in (0, 0, 0)
  translate(width/2, height/2);
  lights();
  fill(255, 255, 255);
  
  rotateX(frameCount*PI/100.0);
  rotateY(frameCount*PI/170.0);
  rotateZ(frameCount*PI/200.0);
  box(400, 400, 400);

}

public void modeZeroWidgets() {
  mode0widgetContainer = new APWidgetContainer(this);
  startButton = new APButton((width/2)+ 600, (height/2) -100, "Start");
  loadButton = new APButton((width/2)+ 600, (height/2) +100, "Load");
  mode0widgetContainer.addWidget(startButton);
  mode0widgetContainer.addWidget(loadButton);

}


