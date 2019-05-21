#include <WiFi.h>
#include <esp_wifi.h> //Needs this for setting custom MAC Addr
#include <ESPmDNS.h>
#include <WiFiUdp.h>
#include <ArduinoOTA.h>
#include "RGB.h"
#include "WifiEspNow.h"

const char* ssid = "ESOTA";
bool OTAMode = true;
RGB led(13);
static uint8_t DEBUG_MAC_WALKER[] = {0x36, 0x00, 0x00, 0x66, 0x66, 0x33};
static uint8_t DEBUGGER[] {0x36, 0x00, 0x00, 0x66, 0x66, 0x40};

void printReceivedMessage(const uint8_t mac[6], const uint8_t* buf, size_t count, void* cbarg) {
  Serial.printf("Message from %02X:%02X:%02X:%02X:%02X:%02X\n", mac[0], mac[1], mac[2], mac[3], mac[4], mac[5]);
  for (int i = 0; i < count; ++i) {
    Serial.print(static_cast<char>(buf[i]));
  }
  Serial.println();
}

void normalModeSetup() {
  OTAMode = false;
  Serial.println("Normal mode initializing ...");
  
  // Set AP Mode MAC
  Serial.print("Setting up ESPNow. My MAC: ");
  WiFi.mode(WIFI_AP);
  esp_wifi_set_mac(ESP_IF_WIFI_AP, DEBUGGER);
  Serial.println(WiFi.softAPmacAddress());


  // Set ESPNow for debug
  if (!WifiEspNow.begin()) {
    Serial.println("ESPNow init failed!");
    ESP.restart();
  }

  WifiEspNow.onReceive(printReceivedMessage, nullptr);
  if (!WifiEspNow.addPeer(DEBUG_MAC_WALKER)) {
    Serial.println("Add peer failed!");
    ESP.restart();
  }

  pinMode(18, OUTPUT);
  digitalWrite(18, LOW);
  delay(100);
  digitalWrite(18, HIGH);
  pinMode(19, OUTPUT);
  Serial.println("Setup done!");
}

void sendMsg(const char* message) {
  char msg[60];
  int len = snprintf(msg, sizeof(msg), message);
  //  int len = snprintf(msg, sizeof(msg), "hello ESP-NOW from %s at %lu", WiFi.softAPmacAddress().c_str(), millis());
  WifiEspNow.send(DEBUG_MAC_WALKER, reinterpret_cast<const uint8_t*>(msg), len);
}

void normalModeLoop() {
//  sendMsg("Hello");
//  delay(1000);
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
