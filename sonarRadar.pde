import processing.serial.*; //libraria pentru comunicarea seriala
import java.awt.event.KeyEvent; //libraria penntru cititrea datelor de la portul serial
import java.io.IOException;

Serial serialPort; 
String noDataReceived;

float pixelDistance;
int receivedAngle , receivedDistance;
int index1 = 0;
int index2 = 0;

String angle = "";
String distance = "";
String data = "";

void setup() 
{
 size (1200, 700); //rezolutia ecranului
 smooth(); //pt ca liniile si marginile desenate sa fie mai netede
 
 serialPort = new Serial(this, "COM4", 9600); //comunicatie seriala cu un dispozitiv conectat la portul COM3
 serialPort.bufferUntil('.'); //citeste datele (unghiul si distanta) de la portul serial pana la '.'
}

void serialEvent(Serial serialPort) 
{ 
  //incepe sa citeasca date de la portul serial
  data = serialPort.readStringUntil('.'); //citeste datele de la portul serial pana la '.'
  data = data.substring(0,data.length()-1); //datele citite sunt puse in 'data'
  
  index1 = data.indexOf(","); //gaseste ',' si o pune in 'index1'
  angle= data.substring(0, index1); //citeste datele de la pozitia 0 pana la ',' (index1) => valoarea unghiului trimis de placa arduino prin portul serial
  distance= data.substring(index1+1, data.length()); //citeste datele de la pozitia ',' (index1) pana la final => valoarea distantei trimisa de placa arduino prin portul serial
  
  //converteste unghiul si distanta din string in intreg
  receivedAngle  = int(angle);
  receivedDistance = int(distance);
}

void drawRadar() 
{
  pushMatrix(); // "pune" matricea curenta de transformare pe o stiva, permitandu-ne sa o modificăm fara a afecta alte desene
  
  translate(width/2, height-height*0.074); // radarul va fi desenat în partea de jos a ecranului
  
  noFill(); // formele nu vor fi umplute cu culoare, ci doar contururile lor vor fi desenate
  strokeWeight(3); // grosime de 3 pixeli a liniilor
  stroke(122,229,255); // culoare random
  
  // deseneaza liniile arcului
  arc(0, 0, (width-width*0.0625), (width-width*0.0625), PI, TWO_PI);
  arc(0, 0, (width-width*0.27), (width-width*0.27), PI, TWO_PI);
  arc(0, 0, (width-width*0.479), (width-width*0.479), PI, TWO_PI);
  arc(0, 0, (width-width*0.687), (width-width*0.687), PI, TWO_PI);
  
  // deseneaza liniile unghiului 
  line(-width/2, 0, width/2, 0);
  line(0, 0, (-width/2)*cos(radians(30)), (-width/2)*sin(radians(30)));
  line(0, 0, (-width/2)*cos(radians(60)), (-width/2)*sin(radians(60)));
  line(0, 0, (-width/2)*cos(radians(90)), (-width/2)*sin(radians(90)));
  line(0, 0, (-width/2)*cos(radians(120)), (-width/2)*sin(radians(120)));
  line(0, 0, (-width/2)*cos(radians(150)), (-width/2)*sin(radians(150)));
  line((-width/2)*cos(radians(30)), 0, width/2, 0);
  
  popMatrix(); // "scoate" matricea de transformare de pe stiva, restaurand starea anterioara a sistemului de coordonate
}

void drawLine() 
{
  pushMatrix();
  
  strokeWeight(8);
  stroke(216,248,255); // culoare random
  translate(width/2, height-height*0.074); // muta coordonatele de inceput la o noua locatie
  
  line(0, 0, (height-height*0.12)*cos(radians(receivedAngle)), -(height-height*0.12)*sin(radians(receivedAngle))); // deseneaza linia in functie de unghi
  popMatrix();
}

void drawObject() 
{
  pushMatrix();
  
  translate(width/2, height-height*0.074); //muta coordonatele de inceput la o noua locatie
  strokeWeight(9); //grosime de 9 pixeli a liniilor
  stroke(35,166,242); //culoarea albastru
  
  pixelDistance = receivedDistance * ((height-height*0.1666)*0.025); //transforma distanta de la senzor din centimetri in pixeli
  
  if(receivedDistance < 40) //limiteaza intervalul la 40 cm
  {
    //deseneaza obiectul conform unghiului si a distantei
    line(pixelDistance*cos(radians(receivedAngle)), -pixelDistance*sin(radians(receivedAngle)), (width-width*0.505)*cos(radians(receivedAngle)), -(width-width*0.505)*sin(radians(receivedAngle)));
  }
  
  popMatrix();
}

void drawText() 
{ 
  //deseneaza textul de ecran
  pushMatrix();
  
  if(receivedDistance > 40) 
  {
    noDataReceived = "Out of range";
  }
  else 
  {
    noDataReceived = "In range";
  }
  
  fill(0,0,0); //deseneaza un dreptunghi negru in partea de jos a ecranului pentru a afisa textul
  noStroke();
  rect(0, height-height*0.0648, width, height);
  
  //afiseaza marcajele de pe axa distantelor: "10cm", "20cm", "30cm", "40cm", pentru a indica intervalul de distanta pe ecran
  fill(255);
  textSize(25); 
  text("10cm", width-width*0.3854, height-height*0.0833);
  text("20cm", width-width*0.281, height-height*0.0833);
  text("30cm", width-width*0.177, height-height*0.0833);
  text("40cm", width-width*0.0729, height-height*0.0833);
  
  //afiseaza starea obiectului detectat, care poate fi "Out of range" sau "In range"
  textSize(40);
  text("Radar ", width-width*0.875, height-height*0.0277);
  text("Angle: " + receivedAngle +" ", width-width*0.48, height-height*0.0277);
  text("Distance: ", width-width*0.26, height-height*0.0277);
  
  //afiseaza distanta numai daca este in limitele acceptabile
  if(receivedDistance < 40) 
  {
    text("               " + receivedDistance +" cm", width-width*0.225, height-height*0.0277);
  }
  
  //plaseaza si roteaza marcajele pentru unghiuri la pozitiile corecte pe ecran
  textSize(25);
  fill(255);
  translate((width-width*0.4994)+width/2*cos(radians(30)), (height-height*0.0907)-width/2*sin(radians(30)));
  rotate(-radians(-60));
  text("30", 0, 0);
  resetMatrix();
  translate((width-width*0.503)+width/2*cos(radians(60)), (height-height*0.0888)-width/2*sin(radians(60)));
  rotate(-radians(-30));
  text("60", 0, 0);
  resetMatrix();
  translate((width-width*0.507)+width/2*cos(radians(90)), (height-height*0.0833)-width/2*sin(radians(90)));
  rotate(radians(0));
  text("90", 0, 0);
  resetMatrix();
  translate(width-width*0.513+width/2*cos(radians(120)), (height-height*0.07129)-width/2*sin(radians(120)));
  rotate(radians(-30));
  text("120", 0, 0);
  resetMatrix();
  translate((width-width*0.5104)+width/2*cos(radians(150)), (height-height*0.0574)-width/2*sin(radians(150)));
  rotate(radians(-60));
  text("150", 0, 0);
  
  popMatrix(); 
}

void draw() 
{
  fill(98,245,31); 
  
  noStroke(); //simularea estomparii miscarii și a diminuarii treptate a liniei in miscare 
  fill(0,4); 
  rect(0, 0, width, height-height*0.065); 
  
  fill(98,245,31); 
  
  drawRadar(); //desenarea radarului
  drawLine();
  drawObject();
  drawText();
}
