import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print("Handling a background title: ${message.notification?.title}");
  print("Handling a background body: ${message.notification?.body}");
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  var storage = const FlutterSecureStorage();

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
    await storage.write(key: "fcmToken", value: fcmToken);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}
