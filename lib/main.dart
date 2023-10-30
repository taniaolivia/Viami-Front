import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:viami/screens/drawer.dart';
import 'package:viami/screens/introduction.dart';
import 'package:viami/screens/login.dart';
import 'package:viami/screens/profile_page.dart';
import 'package:viami/screens/register.dart';
import 'package:viami/screens/start.dart';
import 'package:viami/screens/settings.dart';
import 'package:viami/screens/notifications_page.dart';
import 'package:viami/screens/updatePassword.dart';

void main() async {
  await dotenv.load(fileName: "lib/.env");
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
          "/settings": (context) => const SettingsPage(),
          "/notif": (context) => const NotificationsPage(),
          "/login": (context) => const LoginPage(),
          "/profile": (context) => const ProfilePage(),
          "/updatePassword": (context) => const UpdatePassword(),
        });
  }
}
