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
    try {
      await _firebaseMessaging.requestPermission();

      final apnsToken = await _firebaseMessaging.getAPNSToken();
      await storage.write(key: "apnsToken", value: apnsToken);

      final fcmToken = await _firebaseMessaging.getToken();
      await storage.write(key: "fcmToken", value: fcmToken);

      FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    } catch (e) {
      print("Error initializing notifications: $e");
      // Handle error gracefully, such as displaying an error message to the user
    }
  }
}
