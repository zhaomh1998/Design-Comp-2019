import 'package:firebase_messaging/firebase_messaging.dart';

FirebaseMessaging globalFCM = new FirebaseMessaging();

void notificationSubscribe(String walkerId) {
  print("Subscribed to notification channel $walkerId");
  globalFCM.subscribeToTopic(walkerId);
}