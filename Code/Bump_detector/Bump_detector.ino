#include <SoftwareSerial.h>
#include "TFMini.h"

#define COUNT 100
#define TX 10
#define RX 11
#define LED 8
#define BUMP_THRESHOLD 15

int readings[COUNT];
int count = -1;

// Setup software serial port
SoftwareSerial mySerial(TX, RX);
//create tfmini LiDAR object
TFMini tfmini;

void setup() {
  //define vars needed for reading and calculations

  // Step 1: Initialize hardware serial port (serial debug port)
  Serial.begin(115200);
  // wait for serial port to connect. Needed for native USB port only
  while (!Serial);

  Serial.println ("Initializing...");

  // Step 2: Initialize the data rate for the SoftwareSerial port
  //  mySerial.listen();
  mySerial.begin(TFMINI_BAUDRATE);

  // Step 3: Initialize the TF Mini sensor
  tfmini.begin(&mySerial);
  pinMode(LED, OUTPUT);
  digitalWrite(LED, HIGH);
  initialize();

}


void loop() {
  //define vars needed for reading and calculations


  int avg;

  // Take one TF Mini distance measurement
  int dist = tfmini.getDistance();
  updateArray(dist);

  //  uint16_t strength = tfmini.getRecentSignalStrength();

  // Display the measurement
  Serial.println("Distance: ");
  Serial.print(dist);
  //  reading[count] = dist;
  //  count++;
  Serial.print("\t");
  //  delay(1000);
  //  Serial.println("sigstr: ");
  //  Serial.print(strength);
  Serial.print("\t");
  //  delay(1000);
  Serial.print("\t");
  Serial.print("Average: ");
  avg = calcAvg();
  Serial.println(avg);
  if (abs(avg - dist) > BUMP_THRESHOLD)
    digitalWrite(8, HIGH);
  else
    digitalWrite(8, LOW);

  //calculate the average of the every 20 readings

  // Wait some short time before taking the next measurement
}

void initialize() {
  Serial.println("Initialize readings:");
  for (int i = 0; i < COUNT; i++) {
    int dist = tfmini.getDistance();
    Serial.println(dist);
    readings[i] = dist;
  }
}

void updateArray(int reading) {
  count += 1;
  readings[count % COUNT] = tfmini.getDistance();
}

int calcAvg() {
  long long sum = 0;
  for (int i = 0; i < COUNT; i++) {
    sum += readings[i];
  }
  return sum / COUNT;
}
