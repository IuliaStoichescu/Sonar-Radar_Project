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

PFont orcFont;

void setup() 
{
 size (1920, 1080); //rezolutia ecranului
 smooth(); //pt ca liniile si marginile desenate sa fie mai netede
 
 serialPort = new Serial(this, "COM3", 9600); //comunicatie seriala cu un dispozitiv conectat la portul COM3
 serialPort.bufferUntil('.'); //citeste datele (unghiul si distanta) de la portul serial pana la '.'
 
 orcFont = loadFont("OCRAExtended-30.vlw"); //incarcă un font specific
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
  
  translate(960,1000); // radarul va fi desenat în partea de jos a ecranului
  
  noFill(); // formele nu vor fi umplute cu culoare, ci doar contururile lor vor fi desenate
  strokeWeight(3); // grosime de 3 pixeli a liniilor
  stroke(122,229,255); // culoare random
  
  // deseneaza liniile arcului
  arc(0,0,1800,1800,PI,TWO_PI); // deseneaza un arc incepand de la pozitia (0, 0), avand un diametru de 1800 pixeli si acoperind un unghi de la PI (180 de grade) la TWO_PI (360 de grade)
  arc(0,0,1400,1400,PI,TWO_PI); // deseneaza un alt arc cu un diametru mai mic de 1400 de pixeli, acoperind acelasi interval de unghiuri
  arc(0,0,1000,1000,PI,TWO_PI); 
  arc(0,0,600,600,PI,TWO_PI); // doua arce cu diametre si mai mici, reprezentand concentric cercuri in radar
  
  // deseneaza liniile unghiului 
  line(-960,0,960,0); // deseneaza axa orizontala a radarului
  line(0,0,-960*cos(radians(30)),-960*sin(radians(30))); // deseneaza o linie care porneste de la origine si se extinde catre directia la un unghi de 30 de grade
  line(0,0,-960*cos(radians(60)),-960*sin(radians(60)));
  line(0,0,-960*cos(radians(90)),-960*sin(radians(90)));
  line(0,0,-960*cos(radians(120)),-960*sin(radians(120)));
  line(0,0,-960*cos(radians(150)),-960*sin(radians(150))); // linii similare sunt desenate pentru unghiuri de 60, 90, 120 si 150 de grade
  line(-960*cos(radians(30)),0,960,0);
  
  popMatrix(); // "scoate" matricea de transformare de pe stiva, restaurand starea anterioara a sistemului de coordonate
}

void drawLine() 
{
  pushMatrix();
  
  strokeWeight(8);
  stroke(216,248,255); // culoare random
  translate(960,1000); // muta coordonatele de inceput la o noua locatie
  
  line(0,0,950*cos(radians(receivedAngle)),-950*sin(radians(receivedAngle))); // deseneaza linia in functie de unghi
  popMatrix();
}