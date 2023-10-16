import 'package:flutter/material.dart';
import 'package:viami/screens/drawer.dart';
import 'package:viami/screens/introduction.dart';
import 'package:viami/screens/register.dart';
import 'package:viami/screens/start.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: const IntroductionPage(),
        initialRoute: "/",
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.blue,
            snackBarTheme: const SnackBarThemeData(
                contentTextStyle: TextStyle(fontFamily: "Poppins")),
            fontFamily: "Poppins"),
        routes: {
          "/home": (context) => const DrawerPage(),
          "/start": (context) => const StartPage(),
          "/register": (context) => const RegisterPage(),
        });
  }
}
