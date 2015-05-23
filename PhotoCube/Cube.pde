//Creation process of the cube

public class Cube {
  float grp;
  PImage img;
  
  
public void display()
{
  
  beginShape(QUADS);

  strokeWeight(1);
  
  //+z front
  vertex(-1, -1, 1, 0, 0);
  vertex(1, -1, 1, 1, 0);
  vertex(1, 1, 1, 1, 1);
  vertex(-1, 1, 1, 0, 1);
  
  //-z back
  vertex(1, -1, -1, 0, 0);
  vertex(-1, -1, -1, 1, 0);
  vertex(-1, 1, -1, 1, 1);
  vertex(1, 1, -1, 0, 1);
  
  //+y bottom
  vertex(-1, 1, 1, 0, 0);
  vertex(1, 1, 1, 1, 0);
  vertex(1, 1, -1, 1, 1);
  vertex(-1, 1, -1, 0, 1);
  
  //-y top
  vertex(-1, -1, -1, 0, 0);
  vertex(1, -1, -1, 1, 0);
  vertex(1, -1, 1, 1, 1);
  vertex(-1, -1, 1, 0, 1);
  
  //+x right
  vertex(1, -1, 1, 0, 0);
  vertex(1, -1, -1, 1, 0);
  vertex(1, 1, -1, 1, 1);
  vertex(1, 1, 1, 0, 1);
  
  //-x left
  vertex(-1, -1, -1, 0, 0);
  vertex(-1, -1, 1, 1, 0);
  vertex(-1, 1, 1, 1, 1);
  vertex(-1, 1, -1, 0, 1);
  
  endShape();
  }


public void setTexture(float grp, PImage img)
  {   
      this.grp = grp;
      this.img = img;
      
      if (this.grp == 0){
        beginShape(QUADS);
        texture(this.img);
        vertex(-1, -1, 1, 0, 0);
        vertex(1, -1, 1, 1, 0);
        vertex(1, 1, 1, 1, 1);
        vertex(-1, 1, 1, 0, 1);
        endShape();
      }
      else if (this.grp == 1){
        beginShape(QUADS);
        texture(this.img);
        vertex(1, -1, -1, 0, 0);
        vertex(-1, -1, -1, 1, 0);
        vertex(-1, 1, -1, 1, 1);
        vertex(1, 1, -1, 0, 1);
        endShape();
      }
      else if (this.grp == 2){
        beginShape(QUADS);
        texture(this.img);
        vertex(-1, 1, 1, 0, 0);
        vertex(1, 1, 1, 1, 0);
        vertex(1, 1, -1, 1, 1);
        vertex(-1, 1, -1, 0, 1);
        endShape();
      }
       else if (this.grp == 3){
        beginShape(QUADS);
        texture(this.img);
        vertex(-1, -1, -1, 0, 0);
        vertex(1, -1, -1, 1, 0);
        vertex(1, -1, 1, 1, 1);
        vertex(-1, -1, 1, 0, 1);
        endShape();
      }
      else if (this.grp == 4){
        beginShape(QUADS);
        texture(this.img);
        vertex(1, -1, 1, 0, 0);
        vertex(1, -1, -1, 1, 0);
        vertex(1, 1, -1, 1, 1);
        vertex(1, 1, 1, 0, 1);
        endShape();
      }
      else if (this.grp == 5){
        beginShape(QUADS);
        texture(this.img);
        vertex(-1, -1, -1, 0, 0);
        vertex(-1, -1, 1, 1, 0);
        vertex(-1, 1, 1, 1, 1);
        vertex(-1, 1, -1, 0, 1);
        endShape();
      }else {
        display();
      } 
  
  }
  
}
