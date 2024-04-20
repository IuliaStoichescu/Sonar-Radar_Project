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