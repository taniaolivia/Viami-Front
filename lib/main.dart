import 'package:flutter/material.dart';
import 'package:viami/screens/drawer.dart';
import 'package:viami/screens/introduction.dart';
import 'package:viami/screens/register.dart';

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
      initialRoute: "/register",
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        "/home": (context) => const DrawerPage(),
        "/register": (context) => const RegisterPage(),
      }
    );
  }
}
