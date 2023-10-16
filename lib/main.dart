import 'package:flutter/material.dart';
import 'package:viami/screens/drawer.dart';
import 'package:viami/screens/home.dart';
import 'package:viami/screens/introduction.dart';
import 'package:viami/screens/settings.dart';
import 'package:viami/screens/notifications_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: IntroductionPage(),
        initialRoute: "/",
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          "/home": (context) => const DrawerPage(),
          "/settings": (context) => const SettingsPage()
          "/notif": (context) => const NotificationPage()
        });
  }
}
