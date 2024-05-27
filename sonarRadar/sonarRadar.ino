#include<Servo.h> //biblioteca necesara pentru a controla un servomotor

#define trigPin 10 //pinul conectat la pinul de trimitere (TRIG) al senzorului
#define echoPin 11 // pinul conectat la pinul de recepție (ECHO) al senzorului

long duration; //durata timpului între trimiterea și primirea semnalului
int distance ; //distanța calculată în centimetri

Servo myservo;

int calculateDistance()
{
  digitalWrite(trigPin,LOW); //seteaza pinul trigPin la nivel scazut (LOW), pregatindu-l pentru a trimite semnalul
  delayMicroseconds(2); //ne asiguram ca semnalul de trimitere este stabilit la nivel scazut înainte de a-l face sa creasca
  digitalWrite(trigPin,HIGH); ///trimite semnalul
  delayMicroseconds(10); //durata în care semnalul este transmis
  digitalWrite(trigPin,LOW); // se termina trimiterea semnalului
  duration = pulseIn(echoPin, HIGH); //durata timpului în care semnalul de intoarcere (ECHO) este la nivel inalt (HIGH)
  //aceasta durata este proportionala cu timpul necesar pentru ca semnalul sa se intoarca de la obiectul detectat
  distance = duration*0.034/2;
  //formula este derivata din viteza ultrasunetelor în aer (aproximativ 0.034 cm/microsecunda) si 
  //faptul ca semnalul parcurge distanta de intoarcere de doua ori (dus-intors)
  return distance;
}

void setup() //inițializare Arduino
{
  pinMode(trigPin , OUTPUT); //seteaza pinul trigPin ca iesire pentru a trimite semnalul 
  pinMode(echoPin, INPUT); //seteaza pinul echoPin ca intrare pentru a citi semnalul de intoarcere 
  myservo.attach(12); //ataseaza pinul de control la pinul 11
  Serial.begin(9600); //initializeaza comunicarea seriala la o rata de transfer de 9600 de biti pe secunda
}

void loop()
{
 int i ;// pozitia servomotorului de la 15 la 165 grade in sensul acelor de ceasornic
 for (i=15; i<=165; i++) // spre dreapta
 {
  myservo.write(i);//seteaza unghiul servomotorului la valoarea i
  delay(15); //asteapta 15 milisecunde pentru ca servomotorul sa ajunga la noua pozitie
  calculateDistance();
  Serial.print(i);
  Serial.print(",");
  Serial.print(distance);
  Serial.print(".");
 }
 for(i=165; i>=15; i--) // spre stanga
 {
  myservo.write(i);
  delay(15);
  calculateDistance();
  Serial.print(i); //valoarea unghiului
  Serial.print(",");
  Serial.print(distance);
  Serial.print(".");
 }
}

