#include <WiFi.h>
#include <esp_wifi.h> //Needs this for setting custom MAC Addr
#include <ESPmDNS.h>
#include <WiFiUdp.h>
#include <ArduinoOTA.h>
#include "RGB.h"
#include "WifiEspNow.h"
#include "Adafruit_FONA.h" // https://github.com/botletics/SIM7000-LTE-Shield/tree/master/Code
#include <HardwareSerial.h>
// ===================
// Settings

// OTA Setting
const char* ssid = "ESOTA";
bool OTAMode = true;
bool sosPending = false;
// Periphral Setting
#define ES_LED_PIN 13
#define FONA_PWRKEY 18
#define FONA_RST 5
#define FONA_TX 16 // ESP32 hardware serial RX2 (GPIO16)
#define FONA_RX 17 // ESP32 hardware serial TX2 (GPIO17)
RGB led(ES_LED_PIN);
HardwareSerial fonaSS(1);
Adafruit_FONA_LTE fona = Adafruit_FONA_LTE();
uint8_t readline(char *buff, uint8_t maxbuff, uint16_t timeout = 0);
uint8_t type;
char replybuffer[255]; // this is a large buffer for replies
char imei[16] = {0}; // MUST use a 16 character buffer for IMEI!


// Debug Setting
static uint8_t DEBUG_MAC_WALKER[] = {0x36, 0x00, 0x00, 0x66, 0x66, 0x33};
static uint8_t NECKLACE[] = {0x36, 0x00, 0x00, 0x66, 0x66, 0x34};
static uint8_t DEBUGGER[] {0x36, 0x00, 0x00, 0x66, 0x66, 0x40};

void sos() {
  uint16_t statuscode;
  int16_t len;
  char url[] = "easystroll.appspot.com/sos?ccid=8944501810180175785f";
  char buf[1000];
  Serial.println("Trying to get");
  if (!fona.HTTP_GET_start(url, &statuscode, (uint16_t *)&len)) {
    sendMsg("GET Failed!");
  }
  int16_t counter = len;
  while (len > 0) {
    while (fona.available()) {
      buf[counter - len] = fona.read();
      len--;
      if (!len) break;
    }
  }
  buf[counter] = '\0';
  //  sendMsg(buf);
  fona.HTTP_GET_end();
}

void printReceivedMessage(const uint8_t mac[6], const uint8_t* buf, size_t count, void* cbarg) {
  Serial.printf("Message from %02X:%02X:%02X:%02X:%02X:%02X\n", mac[0], mac[1], mac[2], mac[3], mac[4], mac[5]);
  Serial.println("Message received");
  if (mac[5] == NECKLACE[5]) {
    Serial.println("Send");
    sosPending = true;
  }
  //  Serial.println();
}

void normalModeSetup() {
  OTAMode = false;
  Serial.println("Normal mode initializing ...");

  // Set AP Mode MAC
  Serial.print("Setting up ESPNow. My MAC: ");
  WiFi.mode(WIFI_AP);
  esp_wifi_set_mac(ESP_IF_WIFI_AP, DEBUG_MAC_WALKER);
  Serial.println(WiFi.softAPmacAddress());


  // Set ESPNow for debug
  if (!WifiEspNow.begin()) {
    Serial.println("ESPNow init failed!");
    ESP.restart();
  }

  WifiEspNow.onReceive(printReceivedMessage, nullptr);
  if (!WifiEspNow.addPeer(DEBUGGER)) {
    Serial.println("Add peer debugger failed!");
    ESP.restart();
  }

  if (!WifiEspNow.addPeer(NECKLACE)) {
    Serial.println("Add peer necklace failed!");
    ESP.restart();
  }

  // -----------------------------------
  // Setup LTE Module
  pinMode(FONA_RST, OUTPUT);
  digitalWrite(FONA_RST, HIGH); // Default state
  pinMode(FONA_PWRKEY, OUTPUT);
  // >> Power on LTE Module
  digitalWrite(FONA_PWRKEY, LOW);
  delay(100);
  digitalWrite(FONA_PWRKEY, HIGH);
  // >> Establish connection to LTE
  fonaSS.begin(115200, SERIAL_8N1, FONA_TX, FONA_RX); // baud rate, protocol, ESP32 RX pin, ESP32 TX pin
  sendMsg("Configuring to 9600 baud");
  fonaSS.println("AT+IPR=9600"); // Set baud rate
  delay(100); // Short pause to let the command run
  fonaSS.begin(9600, SERIAL_8N1, FONA_TX, FONA_RX); // Switch to 9600
  if (! fona.begin(fonaSS)) {
    sendMsg("Couldn't find FONA");
    ESP.restart(); // Don't proceed if it couldn't find the device
  }

  fona.setFunctionality(1); // AT+CFUN=1
  fona.setNetworkSettings(F("hologram")); // For Hologram SIM card

  fona.getSIMCCID(replybuffer);  // make sure replybuffer is at least 21 bytes!
  sendMsg("SIM CCID = "); sendMsg(replybuffer);
  pinMode(19, OUTPUT);

  // >> Turn on GPRS
  while (!fona.enableGPRS(true)) {
    sendMsg("Failed to turn on GPRS");
    fona.enableGPRS(false);
    delay(100);
  }
  sendMsg("GPRS turned on");
  // >> Turn on GPS
  while (!fona.enableGPS(true)) {
    sendMsg("Failed to turn on GPS");
    fona.enableGPS(false);
    delay(100);
  }
  sendMsg("GPS on");
  sendMsg("Setup done!");
}

void sendMsg(char* message) {
  char msg[60];
  int len = snprintf(msg, sizeof(msg), message);
  //  int len = snprintf(msg, sizeof(msg), "hello ESP-NOW from %s at %lu", WiFi.softAPmacAddress().c_str(), millis());
  WifiEspNow.send(DEBUGGER, reinterpret_cast<const uint8_t*>(msg), len);
}

void normalModeLoop() {
  if (!sosPending) {
    delay(1000);
    uint16_t year;
    uint8_t month, day, hour, minute;
    float latitude = 0, longitude = 0, speed_kph = 0, heading = 0, altitude = 0, second = 0;
    sendMsg("Preparing to get GPS");
    if (fona.getGPS(&latitude, &longitude, &speed_kph, &heading, &altitude)) { // Use this line instead if you don't want UTC time
      sendMsg("GPS Data success");


      char lat[15]; char lon[15];
      dtostrf(latitude, 10, 6, lat);
      dtostrf(longitude, 10, 6, lon);


      uint16_t statuscode;
      int16_t len;
      char url[500];
      char buf[5000];
      sprintf(url, "easystroll.appspot.com/gps?lat=%s&lon=%s&ccid=8944501810180175785f", lat, lon);
      if (!fona.HTTP_GET_start(url, &statuscode, (uint16_t *)&len)) {
        sendMsg("GET Failed!");
      }
      int16_t counter = len;
      while (len > 0) {
        while (fona.available()) {
          buf[counter - len] = fona.read();
          len--;
          if (!len) break;
        }
      }
      buf[counter] = '\0';
      sendMsg(buf);
      fona.HTTP_GET_end();

      //    Serial.println(F("---------------------"));
      //    Serial.print(F("Latitude: ")); Serial.println(latitude, 6);
      //    Serial.print(F("Longitude: ")); Serial.println(longitude, 6);
      //    Serial.print(F("Speed: ")); Serial.println(speed_kph);
      //    Serial.print(F("Heading: ")); Serial.println(heading);
      //    Serial.print(F("Altitude: ")); Serial.println(altitude);
    }
    else
      sendMsg("GPS Failed");

    yield();
  }
  else {
    sos();
    sosPending = false;
  }
  yield();
}

// OTA Firmware below ... DO NOT EDIT!!!

void setup() {
  Serial.begin(115200);
  Serial.println("Booting");
  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid);
  while (WiFi.waitForConnectResult() != WL_CONNECTED) {
    normalModeSetup();
    return;
  }

  ArduinoOTA.setHostname("EasyStroll-Walker1");
  ArduinoOTA
  .onStart([]() {
    String type;
    if (ArduinoOTA.getCommand() == U_FLASH)
      type = "sketch";
    else // U_SPIFFS
      type = "filesystem";

    // NOTE: if updating SPIFFS this would be the place to unmount SPIFFS using SPIFFS.end()
    Serial.println("Start updating " + type);
  })
  .onEnd([]() {
    Serial.println("\nEnd");
  })
  .onProgress([](unsigned int progress, unsigned int total) {
    Serial.printf("Progress: %u%%\r", (progress / (total / 100)));
  })
  .onError([](ota_error_t error) {
    Serial.printf("Error[%u]: ", error);
    if (error == OTA_AUTH_ERROR) Serial.println("Auth Failed");
    else if (error == OTA_BEGIN_ERROR) Serial.println("Begin Failed");
    else if (error == OTA_CONNECT_ERROR) Serial.println("Connect Failed");
    else if (error == OTA_RECEIVE_ERROR) Serial.println("Receive Failed");
    else if (error == OTA_END_ERROR) Serial.println("End Failed");
  });

  ArduinoOTA.begin();

  Serial.println("Ready");
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());
}

void loop() {
  if (OTAMode)
    ArduinoOTA.handle();
  else {
    normalModeLoop();
  }
}
