#include <ESP8266WiFi.h>
#include "WifiEspNow.h"
extern "C" {
#include <user_interface.h>  // For setting MAC
}

static uint8_t MAC_WALKER[] = {0x36, 0x00, 0x00, 0x66, 0x66, 0x33};
static uint8_t NECKLACE[] {0x36, 0x00, 0x00, 0x66, 0x66, 0x34};

void printReceivedMessage(const uint8_t mac[6], const uint8_t* buf, size_t count, void* cbarg) {
  Serial.printf("Message from %02X:%02X:%02X:%02X:%02X:%02X\n", mac[0], mac[1], mac[2], mac[3], mac[4], mac[5]);
  for (int i = 0; i < count; ++i) {
    Serial.print(static_cast<char>(buf[i]));
  }
  Serial.println();
}

void setup() {
  // Set AP Mode MAC
  Serial.print("Setting up ESPNow. My MAC: ");
  WiFi.mode(WIFI_AP);
  wifi_set_macaddr(SOFTAP_IF, NECKLACE);
  Serial.println(WiFi.softAPmacAddress());


  // Set ESPNow for debug
  if (!WifiEspNow.begin()) {
    Serial.println("ESPNow init failed!");
    ESP.restart();
  }

  WifiEspNow.onReceive(printReceivedMessage, nullptr);
  if (!WifiEspNow.addPeer(MAC_WALKER)) {
    Serial.println("Add peer failed!");
    ESP.restart();
  }

  pinMode(2, OUTPUT);
  sendMsg("SOS");
  digitalWrite(2, HIGH);
  delay(500);
  digitalWrite(2, LOW);
  Serial.println("Setup done!");
}

void sendMsg(const char* message) {
  Serial.println("Sending msg to walker...");
  char msg[60];
  int len = snprintf(msg, sizeof(msg), message);
  //  int len = snprintf(msg, sizeof(msg), "hello ESP-NOW from %s at %lu", WiFi.softAPmacAddress().c_str(), millis());
  WifiEspNow.send(MAC_WALKER, reinterpret_cast<const uint8_t*>(msg), len);
  Serial.println("Msg send!");
}

void loop() {
  ESP.deepSleep(999999999 * 999999999U, WAKE_NO_RFCAL); // shut down until reset
}
