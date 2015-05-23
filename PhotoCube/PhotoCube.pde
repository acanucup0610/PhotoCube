/**
 Title: PhotoCube (Milestone 2) Final Project
 Author: Angelo Nucup
 
 */

import android.text.InputType;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputMethodManager;
import android.content.Context;

import apwidgets.*;
import java.util.*;
import java.io.*;
import android.os.Environment;

import android.view.MotionEvent;
import ketai.ui.*;
import ketai.camera.*;
KetaiCamera cam;

import android.content.SharedPreferences;

//For Mode 5 - Saving the Cube
SharedPreferences settings;
boolean beg = true;
String face1;
String face2;
String face3;
String face4;
String face5;
String face6;

PImage f1, f2, f3, f4, f5, f6;

KetaiGesture Gesture;

//Modes
boolean modeZero = true;    //Start Page
boolean modeOne = false;    //Add photos 
boolean modeTwo = false;    //Gallery mode
boolean modeThree = false;  //Flickr mode
boolean modeFour = false;   //List overview of phots collected
boolean modeFive = false;   //Preview of cube & Assign faces
boolean modeSix = false;    //Edit and Layering
boolean modeSeven = false;  //Display
boolean modeEight = false; //New edited

boolean isVisible;

//Cube manipulation
float rotX = 0.0;
float rotY = 0.0;
int lastX, lastY;
float distX = 0.0;
float distY = 0.0;

//Cubes
Cube startCube = new Cube();   //Start page cube
Cube previewCube = new Cube(); //Preview cube
Cube displayCube = new Cube();

//Face guides
PImage one, two, three, four, five, six;
PImage newEdit;

//modeThree [Flickr]
ArrayList <PImage> flickrPhotoList;

//modeFour [Overview list]
ArrayList <PImage> overviewPhotoList;

//modeTwo [Gallery list]
ArrayList <PImage> galleryPhotoList;

ArrayList<String> fileNames;

//Resizing the images
float thumbHeight;
float thumbWidth;
float thumbRatio;

//Gesture animation
float animate = 0.0;
int[] currentFlickrThumbnails = new int[5];
int[] currentOverviewThumbnails = new int[5];
int[] currentGalleryThumbnails = new int[5];
boolean toFlickrRight = true;
boolean toOverviewRight = true;
boolean toGalleryRight = true;
int leftmost = 0;
int selectedImage = 0;
int photoToEdit = 0;
int[] selectedImages = {
  -1, -1, -1, -1, -1, -1
};

int groupNumber = 7;

int cameraID = 0;

//Flickr request filter
String userID;
boolean isUserid;
String tag; 
String sort;
String minDate;
String maxDate;


//Mode widget containers
APWidgetContainer mode0widgetContainer;
APWidgetContainer mode1widgetContainer;
APWidgetContainer mode3widgetContainer;
APWidgetContainer backwidgetContainer;
APWidgetContainer mode4widgetContainer;
APWidgetContainer mode5widgetContainer;
APWidgetContainer mode6widgetContainer;
APWidgetContainer mode8widgetContainer;

//Mode 0 Buttons
APButton startButton;
APButton loadButton;

//Mode 1 Widgets
APButton captureButton;
APButton switchButton; //camera switch
APButton flickrButton; //tag
APButton userIdButton; //userId
APButton galleryButton;
APEditText searchFlickr; // Tag text field


//Mode 3 [Flickr] Widgets
APEditText enterMinDate; //Date text field
APEditText enterMaxDate; //Date text field
APButton refresh;        //Refresh Button
APCheckBox checkbox;      //sort checkbox

//Mode 2 & 3 [backwidgetContainer]
APButton backButton;
APButton mode7backButton;

//Mode 4 Buttons
APButton addmoreButton;
APButton assignButton;


//Mode 5 Buttons 
APButton oneButton;   //face 1
APButton twoButton;   //face 2
APButton threeButton; //face 3
APButton fourButton;  //face 4
APButton fiveButton;  //face 5
APButton sixButton;   //face 6
APButton saveButton;  //save button

//Mode 6 Buttons
APButton changeButton;
APRadioGroup radioGroup;
APRadioButton threshold;
APRadioButton gray;
APRadioButton invert;
APRadioButton posterize;

//Mode 6 Buttons
APButton addButton;
APButton saveFaceButton;

//Mode 8 Buttons
APButton saveEditButton;

void setup() {

  orientation(LANDSCAPE);
  cam = new KetaiCamera(this, 560, 480, 60);
  size(displayWidth, displayHeight, P3D);
  noStroke();

  settings = getPreferences(MODE_PRIVATE);
  userID = "";
  tag = "test";
  sort = "date-posted-desc";
  minDate = "";
  maxDate = "";
  beg = true;


  //Guide images
  one = loadImage("1.png");
  two = loadImage("2.png");
  three = loadImage("3.png");
  four = loadImage("4.png");
  five = loadImage("5.png");
  six = loadImage("6.png");

  Gesture = new KetaiGesture(this);

  //Flickr
  flickrPhotoList = new ArrayList <PImage> ();

  //Overview
  overviewPhotoList = new ArrayList <PImage> ();

  //Gallery
  galleryPhotoList = new ArrayList <PImage> ();

  fileNames = new ArrayList<String>();
  
  



  //work with cube texture coordinates from (0,0) to (1,1)
  textureMode(NORMAL);

  widgets();
  textSize(50);
  searchFlickr.setImeOptions(EditorInfo.IME_FLAG_NO_EXTRACT_UI);
  enterMinDate.setImeOptions(EditorInfo.IME_FLAG_NO_EXTRACT_UI);
  enterMaxDate.setImeOptions(EditorInfo.IME_FLAG_NO_EXTRACT_UI);
}

void widgets() {

  mode0widgetContainer = new APWidgetContainer(this);
  startButton = new APButton((width/2)+ 600, (height/2) -100, "Start");
  loadButton = new APButton((width/2)+ 600, (height/2) +100, "Load");
  mode0widgetContainer.addWidget(startButton);
  mode0widgetContainer.addWidget(loadButton);

  mode1widgetContainer = new APWidgetContainer(this);
  captureButton = new APButton(1200, (height/2) - 400, "Capture");
  switchButton = new APButton(1500, (height/2)-400, "Front/Back cam");
  flickrButton = new APButton(1500, (height/2)+150, " By Tag");
  userIdButton = new APButton(1200, (height/2)+150, "By User Id");
  searchFlickr = new APEditText(1200, (height/2)-200, width/4, 150); 
  galleryButton = new APButton(1200, (height/2) + 300, "Gallery");
  mode1widgetContainer.addWidget(captureButton);
  mode1widgetContainer.addWidget(switchButton);
  mode1widgetContainer.addWidget(flickrButton);
  mode1widgetContainer.addWidget(userIdButton);
  mode1widgetContainer.addWidget(galleryButton);
  mode1widgetContainer.addWidget(searchFlickr);

  mode3widgetContainer = new APWidgetContainer(this);
  enterMinDate = new APEditText(300, 200, width/5, 150);
  enterMaxDate = new APEditText(900, 200, width/5, 150);
  checkbox = new APCheckBox(1300, 200, "Check for ascending order.");
  refresh = new APButton(300, (height - 200), "Refresh");
  mode3widgetContainer.addWidget(enterMaxDate);
  mode3widgetContainer.addWidget(enterMinDate);
  mode3widgetContainer.addWidget(checkbox);
  mode3widgetContainer.addWidget(refresh);


  backwidgetContainer = new APWidgetContainer(this);
  backButton = new APButton(100, (height - 200), "Back");
  backwidgetContainer.addWidget(backButton);

  mode4widgetContainer = new APWidgetContainer(this);
  addmoreButton = new APButton(100, (height - 200), "Add more");
  assignButton = new APButton(width-400, (height - 200), "Assign faces");
  mode4widgetContainer.addWidget(addmoreButton);
  mode4widgetContainer.addWidget(assignButton);

  mode5widgetContainer = new APWidgetContainer(this);
  oneButton = new APButton(width/2 + 200, height/2 - 200, "Face 1");
  twoButton = new APButton(width/2 + 200, height/2, "Face 2");
  threeButton = new APButton(width/2 + 200, height/2 + 200, "Face 3");
  fourButton = new APButton(width/2 + 500, height/2 - 200, "Face 4");
  fiveButton = new APButton(width/2 + 500, height/2, "Face 5");
  sixButton = new APButton(width/2 + 500, height/2 + 200, "Face 6");
  saveButton = new APButton(width/2 + 300, height/2 + 400, "Save");
  mode5widgetContainer.addWidget(oneButton);
  mode5widgetContainer.addWidget(twoButton);
  mode5widgetContainer.addWidget(threeButton);
  mode5widgetContainer.addWidget(fourButton);
  mode5widgetContainer.addWidget(fiveButton);
  mode5widgetContainer.addWidget(sixButton);
  mode5widgetContainer.addWidget(saveButton);
  
  mode6widgetContainer = new APWidgetContainer(this);
  radioGroup = new APRadioGroup(width/2 +300, height/2-300);
  radioGroup.setOrientation(APRadioGroup.VERTICAL);
  threshold = new APRadioButton("Threshold"); 
  gray = new APRadioButton("Gray"); 
  invert = new APRadioButton("Invert");
  posterize = new APRadioButton("Posterize");
  radioGroup.addRadioButton(threshold); //place radiobutton in radiogroup
  radioGroup.addRadioButton(gray); //place radiobutton in radiogroup
  radioGroup.addRadioButton(invert); //place radiobutton in radiogroup
  radioGroup.addRadioButton(posterize);
  
  changeButton = new APButton(width/2 + 450, height/2 +350, "Change");
  
  mode6widgetContainer.addWidget(radioGroup);
  
  mode6widgetContainer.addWidget(changeButton);
  
  //Mode 8
  mode8widgetContainer = new APWidgetContainer(this);
  saveEditButton = new APButton(width/2 + 370, height/2 +200, "Add to list");
  mode8widgetContainer.addWidget(saveEditButton);
}

void onClickWidget(APWidget widget) {
  if (widget == startButton) {

    modeOne = true;
    modeZero = false;
    modeTwo = false;
    modeThree = false;
    modeFour = false;
    modeFive = false;
    modeSix = false;
    modeSeven = false;
    modeEight = false;
  }

  if (widget == searchFlickr && isVisible == false) {
    showVirtualKeyboard();
    cam.stop();
  }

  if (widget == captureButton && (cam.isStarted())) {

    cam.savePhoto();
    overviewPhotoList.add(cam.get());

    modeZero = false;
    modeTwo = false;
    modeThree = false;
    modeOne = false;
    modeSeven = false;
    modeFive = false;
    modeSix = false;
    modeEight = false;
    modeFour = true;

    
  }

  if (widget == galleryButton) {
    modeZero = false;
    modeOne = false;
    modeTwo = true;
    modeThree = false;
    modeFour = false;
    modeFive = false;
    modeSix = false;
    modeSeven = false;
    modeEight = false;
  }

  if (widget == backButton) {

    userID = "";
    modeZero = false;
    modeTwo = false;
    modeThree = false;
    modeOne = true;
    modeFour = false;
    modeFive = false;
    modeSix = false;
    modeSeven = false;
    modeEight = false;
  }


  if (widget == addmoreButton) {

    flickrPhotoList.clear();

    modeZero = false;
    modeTwo = false;
    modeThree = false;
    modeOne = true;
    modeFour = false;
    modeFive = false;
    modeSix = false;
    modeSeven = false;
    modeEight = false;
  }

  if (widget == assignButton) {

    flickrPhotoList.clear();
    modeZero = false;
    modeTwo = false;
    modeThree = false;
    modeOne = false;
    modeFour = false;
    modeFive = true;
    modeSix = false;
    modeSeven = false;
    modeEight = false;
  }

  if (widget == saveButton) {
    
    //Will save the currently done cube
    SharedPreferences.Editor editor = settings.edit();
    editor.putString("face1", "outputImage0.jpg");
    editor.putString("face2", "outputImage1.jpg");
    editor.putString("face3", "outputImage2.jpg");
    editor.putString("face4", "outputImage3.jpg");
    editor.putString("face5", "outputImage4.jpg");
    editor.putString("face6", "outputImage5.jpg");
    editor.commit();
    
    beg = false;


    modeZero = true;
    modeTwo = false;
    modeThree = false;
    modeOne = false;
    modeFour = false;
    modeFive = false;
    modeSix = false;
    modeSeven = false;
    modeEight = false;
  }

  if (widget == loadButton) {
      
    //Will load the recently done Cube
    if (beg) {
      
      face1 = settings.getString("face1", "outputImage0.jpg");
      face2 = settings.getString("face2", "outputImage1.jpg");
      face3 = settings.getString("face3", "outputImage2.jpg");
      face4 = settings.getString("face4", "outputImage3.jpg");
      face5 = settings.getString("face5", "outputImage4.jpg");
      face6 = settings.getString("face6", "outputImage5.jpg");
      
      f1 = loadImage(face1);
      f2 = loadImage(face2);
      f3 = loadImage(face3);
      f4 = loadImage(face4);
      f5 = loadImage(face5);
      f6 = loadImage(face6);
    
    }

    modeZero = false;
    modeTwo = false;
    modeThree = false;
    modeOne = false;
    modeFour = false;
    modeFive = false;
    modeSix = false;
    modeSeven = true;
    modeEight = false;
  }

  if (widget == searchFlickr && 
    widget == enterMinDate &&
    widget == enterMaxDate && isVisible == false) {
    showVirtualKeyboard();
  }

  if (widget == flickrButton) {
    flickrPhotoList.clear();
    isUserid = false;
    hideVirtualKeyboard();
    tag = searchFlickr.getText();    

    modeZero = false;
    modeTwo = false;
    modeOne = false;
    modeFour = false;
    modeFive = false;
    modeSix = false;
    modeSeven = false;
    modeEight = false;
    modeThree = true;
    ThreadThing tt = new ThreadThing(this);
    tt.start();
  }

  if (widget == userIdButton) {
    flickrPhotoList.clear();
    isUserid = true;
    hideVirtualKeyboard();
    userID = searchFlickr.getText();    

    modeZero = false;
    modeTwo = false;
    modeOne = false;
    modeFour = false;
    modeFive = false;
    modeSix = false;
    modeSeven = false;
    modeEight = false;
    modeThree = true;
    ThreadThing tt = new ThreadThing(this);
    tt.start();
  }

  if (widget == switchButton && (cam.isStarted())) {

    if (cameraID == 0) {
      cameraID = 1;
    } else {
      cameraID = 0;
    }

    cam.stop();
    cam.setCameraID(cameraID);
    cam.start();
  }


  if (widget == refresh) {

    if (isUserid) { //if searched by user id
      userID = searchFlickr.getText();
      tag ="";
    } else {        //if searched by tags
      tag = searchFlickr.getText();
      userID = "";
    }

    flickrPhotoList.clear();

    if (checkbox.isChecked()) {
      sort = "date-posted-asc";
    } else {
      sort = "date-posted-desc";
    }

    minDate = enterMinDate.getText();
    maxDate = enterMaxDate.getText();

    modeZero = false;
    modeTwo = false;
    modeOne = false;
    modeFour = false;
    modeFive = false;
    modeSix = false;
    modeSeven = false;
    modeEight = false;
    modeThree = true;
    ThreadThing tt = new ThreadThing(this);
    tt.start();
  }
  
  if (widget == changeButton){
  
    PImage editImg = overviewPhotoList.get(photoToEdit);
        int wid = editImg.width;
        int hei = editImg.height;
        newEdit = createImage(wid, hei, RGB);
        newEdit = editImg.get();
        
        if (threshold.isChecked()){
          newEdit.filter(THRESHOLD, 0.5);
        }else if (gray.isChecked()){
          newEdit.filter(GRAY);
        }else if (invert.isChecked()){
          newEdit.filter(INVERT);
        }else if (posterize.isChecked()){
          newEdit.filter(POSTERIZE, 3);
        }else{
          newEdit.filter(ERODE);
        }
  
    
    
  modeOne = false;
  modeTwo = false;
  modeThree = false;
  modeFour = false;
  modeFive = false;
  modeSix = false;
  modeSeven = false;
  modeEight = true;
  }
  
  if (widget == saveEditButton){
  
  overviewPhotoList.add(newEdit);  
    
  modeOne = false;
  modeTwo = false;
  modeThree = false;
  modeFour = true;
  modeFive = false;
  modeSix = false;
  modeSeven = false;
  modeEight = false;
  }
  

  if (widget == oneButton) {
    groupNumber = 0;

    modeZero = false;
    modeTwo = false;
    modeThree = false;
    modeOne = false;
    modeSeven = false;
    modeFive = false;
    modeSix = false;
    modeEight = false;
    modeFour = true;
  }

  if (widget == twoButton) {
    groupNumber = 1;

    modeZero = false;
    modeTwo = false;
    modeThree = false;
    modeOne = false;
    modeSeven = false;
    modeFive = false;
    modeSix = false;
    modeEight = false;
    modeFour = true;
  }

  if (widget == threeButton) {
    groupNumber = 2;

    modeZero = false;
    modeTwo = false;
    modeThree = false;
    modeOne = false;
    modeSeven = false;
    modeFive = false;
    modeSix = false;
    modeEight = false;
    modeFour = true;
  }
  if (widget == fourButton) {
    groupNumber = 3;

    modeZero = false;
    modeTwo = false;
    modeThree = false;
    modeOne = false;
    modeSeven = false;
    modeFive = false;
    modeSix = false;
    modeEight = false;
    modeFour = true;
  }
  if (widget == fiveButton) {
    groupNumber = 4;

    modeZero = false;
    modeTwo = false;
    modeThree = false;
    modeOne = false;
    modeSeven = false;
    modeFive = false;
    modeSix = false;
    modeEight = false;
    modeFour = true;
  }
  if (widget == sixButton) {
    groupNumber = 5;

    modeZero = false;
    modeTwo = false;
    modeThree = false;
    modeOne = false;
    modeSeven = false;
    modeFive = false;
    modeSix = false;
    modeEight = false;
    modeFour = true;
  }
}

void draw() {
  background(0);

  if (modeZero) {
    displayStartPage();
    mode0widgetContainer.show();
    mode1widgetContainer.hide();
    mode3widgetContainer.hide();
    backwidgetContainer.hide();
    mode4widgetContainer.hide();
    mode5widgetContainer.hide();
     mode6widgetContainer.hide();
     mode8widgetContainer.hide();
  } else if (modeOne) {
    displaySearchPage();
    mode0widgetContainer.hide();
    mode3widgetContainer.hide();
    mode1widgetContainer.show();
    backwidgetContainer.hide();
    mode4widgetContainer.hide();
    mode5widgetContainer.hide();
    mode6widgetContainer.hide();
    mode8widgetContainer.hide();
//  } else if (modeTwo) {
//    //displayGallery();
//    mode0widgetContainer.hide();
//    mode1widgetContainer.hide();
//    mode3widgetContainer.hide();
//    backwidgetContainer.show();
//    mode4widgetContainer.hide();
//    mode5widgetContainer.hide();
//    mode6widgetContainer.hide();
  } else if (modeThree) {

    thumbRatio = (width/5)/( height/4);

    displayFlickrResult();
    mode0widgetContainer.hide();
    mode1widgetContainer.hide();
    mode3widgetContainer.show();
    backwidgetContainer.show();
    mode4widgetContainer.hide();
    mode5widgetContainer.hide();
    mode6widgetContainer.hide();
    mode8widgetContainer.hide();
  } else if (modeFour) {
    thumbRatio = (width/5)/( height/4);
    displayOverviewResult();
    mode0widgetContainer.hide();
    mode1widgetContainer.hide();
    mode3widgetContainer.hide();
    backwidgetContainer.hide();
    mode4widgetContainer.show();
    mode5widgetContainer.hide();
    mode6widgetContainer.hide();
    mode8widgetContainer.hide();
  } else if (modeFive) {
    assignFaces();


    mode0widgetContainer.hide();
    mode1widgetContainer.hide();
    backwidgetContainer.hide();
    mode4widgetContainer.hide();
    mode3widgetContainer.hide();
    mode6widgetContainer.hide();
    mode8widgetContainer.hide();
    mode5widgetContainer.show();
  } else if (modeSix) {
//    thumbRatio = width/height;
   
    editDisplay();

    mode0widgetContainer.hide();
    mode1widgetContainer.hide();
    mode3widgetContainer.hide();
    backwidgetContainer.hide();
    mode4widgetContainer.hide();
    mode5widgetContainer.hide();
    mode8widgetContainer.hide();
    mode6widgetContainer.show();
  } else if (modeSeven) {
    displayLoadCube();

    mode0widgetContainer.hide();
    mode1widgetContainer.hide();
    mode3widgetContainer.hide();
    backwidgetContainer.hide();
    mode4widgetContainer.hide();
    mode5widgetContainer.hide();
    mode8widgetContainer.hide();
    mode6widgetContainer.hide();
  }else if (modeEight) {
//    thumbRatio = width/height;
    editedPhoto();

    mode0widgetContainer.hide();
    mode1widgetContainer.hide();
    mode3widgetContainer.hide();
    backwidgetContainer.hide();
    mode4widgetContainer.hide();
    mode5widgetContainer.hide();
    mode6widgetContainer.hide();
    mode8widgetContainer.show();
    
  }
}

void onSavePhotoEvent(String filename) {
  cam.addToMediaLibrary(filename);
}

void onCameraPreviewEvent() {
  cam.read();
}

void mousePressed() {
  hideVirtualKeyboard();

  if ((modeOne) || (isVisible)) {
    hideVirtualKeyboard();

    modeOneMousePressed();
  }


  if (modeFive) {
    lastX = mouseX;
    lastY = mouseY;
  }

  if (modeSeven) {
    lastX = mouseX;
    lastY = mouseY;
  }
}

void mouseDragged() {
  if (modeFive) {
    distX = radians(mouseX - lastX);
    distY = radians(lastY - mouseY);
  }

  if (modeSeven) {
    distX = radians(mouseX - lastX);
    distY = radians(lastY - mouseY);
  }
}

void mouseReleased() {
  if (modeFive) {
    rotX += distY;
    rotY += distX;
    distX = distY = 0.0;
  }
}

void onLongPress(float x, float y) {
  if (modeFour) {

    int fourPosition; // variable use to go each image location

      for (fourPosition = 0; fourPosition < 5; fourPosition++) {


      if (mouseX > ((width/5)*fourPosition) &&
        mouseX < (((width/5)*fourPosition) + (width/5)) &&
        mouseY < ((height/2)+(height/5)) &&
        mouseY > ((height/2)-(height/5))) {


        selectedImage = leftmost + fourPosition;

        if (selectedImage > overviewPhotoList.size() - 1) {
          selectedImage = selectedImage - overviewPhotoList.size();
        } 
        photoToEdit = selectedImage;

        modeFour = false;
        modeThree = false;
        modeTwo = false;
        modeOne = false;
        modeFive = false;
        modeSix = true;
        modeZero = false;
        modeEight = false;



        //break;
      }
    }
  }
}

void onDoubleTap(float x, float y) {

  //    if (modeTwo) {
  //      modeFour = true;
  //      modeThree = false;
  //      modeTwo = false;
  //      modeOne = false;
  //      modeZero = false;
  //    }

  if (modeThree) {

    int threePosition; // variable use to go each image location

      for (threePosition = 0; threePosition < 5; threePosition++) {


      if (mouseX > ((width/5)*threePosition) &&
        mouseX < (((width/5)*threePosition) + (width/5)) &&
        mouseY < ((height/2)+(height/5)) &&
        mouseY > ((height/2)-(height/5))) {


        selectedImage = leftmost + threePosition;
        //        if (selectedImage > flickrPhotoList.size() - 1) {
        //          selectedImage = selectedImage - flickrPhotoList.size();
        //        } 
        //        break;
      }
    }    
    println("Selected Image " + selectedImage);

    try {
      //overviewPhotoList.add(flickrPhotoList.get(currentFlickrThumbnails[selectedImage]));
      overviewPhotoList.add(flickrPhotoList.get(selectedImage));
    }
    catch (Exception e) {
      print(e);
    }


    modeFour = true;
    modeThree = false;
    modeTwo = false;
    modeOne = false;
    modeFive = false;
    modeSix = false;
    modeZero = false;
    modeEight = false;
  }

  if (modeFour) {

    int fourPosition; // variable use to go each image location

      for (fourPosition = 0; fourPosition < 5; fourPosition++) {


      if (mouseX > ((width/5)*fourPosition) &&
        mouseX < (((width/5)*fourPosition) + (width/5)) &&
        mouseY < ((height/2)+(height/5)) &&
        mouseY > ((height/2)-(height/5))) {


        selectedImage = leftmost + fourPosition;

        if (selectedImage > overviewPhotoList.size() - 1) {
          selectedImage = selectedImage - overviewPhotoList.size();
        } 
        selectedImages[groupNumber] = selectedImage;
        //break;
      }
    }    
    //println("Selected Image " + selectedImage);
    println("Selected Image " + selectedImages[groupNumber]);
    print("The group number: " + groupNumber);
    println("Overlist size" + overviewPhotoList.size());
  }
  modeZero = false;
  modeTwo = false;
  modeThree = false;
  modeOne = false;
  modeFour = false;
  modeFive = true;
  modeSeven = false;
  modeEight = false;
}

void onFlick(float x, float y, float px, float py, float v) {

  if ((modeThree == true) && (modeFour == false)) {
    if (px < x) { //left

      nextFlickrLeft();
      selectedImage = leftmost;
      displayFlickrThumbnails();
    } else if (px > x) { //right

      nextFlickrRight();
      selectedImage = leftmost;
      displayFlickrThumbnails();
    }
  }

  if ((modeFour == true) && (modeThree == false)) {
    if (px < x) { //left

      nextOverviewLeft();
      selectedImage = leftmost;
      displayOverviewThumbnails();
    } else if (px > x) { //right

      nextOverviewRight();
      selectedImage = leftmost;
      displayOverviewThumbnails();
    }
  }
}

void resizeImage(PImage image) {
  float imageHeight = image.height;
  float imageWidth = image.width;
  float imageRatio = imageWidth/imageHeight;

  //CONDITION STATEMENT

  if (modeThree) {
    if (thumbRatio > imageRatio) {
      thumbHeight = (height/4) - (50/2);
      thumbWidth = (((height/4) - (50/2)) * imageRatio);
    } else if (thumbRatio < imageRatio) {
      thumbHeight = ((width/5) * (1/imageRatio));
      thumbWidth = ((width/5) - (50/2));
    } else {
      thumbHeight = ((width/5) - (50/2));
      thumbWidth = ((width/5) - (50/2));
    }
  }else if(modeFour){
    if (thumbRatio > imageRatio) {
      thumbHeight = (height/4) - (50/2);
      thumbWidth = (((height/4) - (50/2)) * imageRatio);
    } else if (thumbRatio < imageRatio) {
      thumbHeight = ((width/5) * (1/imageRatio));
      thumbWidth = ((width/5) - (50/2));
    } else {
      thumbHeight = ((width/5) - (50/2));
      thumbWidth = ((width/5) - (50/2));
    }
 
  }else if (modeSix) { //Editing a photo
    if (thumbRatio > imageRatio) {
      thumbHeight = height-200;
      thumbWidth = (height-100) * imageRatio;
    } else if (thumbRatio < imageRatio) {
      thumbHeight = (width - 800) * (1/imageRatio);
      thumbWidth = width - 800;
    } else {
      thumbHeight = height - 200;
      thumbWidth = (width/2) - 50;
    }
  }else if (modeEight) { //Editing a photo
    if (thumbRatio > imageRatio) {
      thumbHeight = height-200;
      thumbWidth = (height-100) * imageRatio;
    } else if (thumbRatio < imageRatio) {
      thumbHeight = (width - 800) * (1/imageRatio);
      thumbWidth = width - 800;
    } else {
      thumbHeight = height - 200;
      thumbWidth = (width/2) - 50;
    }
  }
}

File getSketchDir() {
  File extDir = Environment.getExternalStorageDirectory();
  //String sketchName = this.getClass().getSimpleName();
  //String sketchName = "Pictures/DCIM/Camera";
  //return new File(extDir, sketchName);
  return extDir;
}



//Virtual Keyboard hide/show methods

void showVirtualKeyboard() {
  InputMethodManager imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
  imm.toggleSoftInput(InputMethodManager.SHOW_FORCED, 0);
  isVisible = true;
}

void hideVirtualKeyboard() {
  InputMethodManager imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
  imm.hideSoftInputFromWindow(searchFlickr.getView().getWindowToken(), 0);
  imm.hideSoftInputFromWindow(enterMinDate.getView().getWindowToken(), 0);
  imm.hideSoftInputFromWindow(enterMaxDate.getView().getWindowToken(), 0);
  isVisible = false;
}

public boolean surfaceTouchEvent(MotionEvent event) {

  //call to keep mouseX, mouseY, etc updated
  super.surfaceTouchEvent(event);

  //forward event to class for processing
  return Gesture.surfaceTouchEvent(event);
}

