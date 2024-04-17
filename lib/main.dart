import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:viami/constant.dart';
import 'package:viami/firebase_api.dart';
import 'package:viami/screens/allPopularActivities.dart';
import 'package:viami/screens/drawer.dart';
import 'package:viami/screens/faqDetails.dart';
import 'package:viami/screens/introduction.dart';
import 'package:viami/screens/login.dart';
import 'package:viami/screens/messenger.dart';
import 'package:viami/screens/profile.dart';
import 'package:viami/screens/allRecommendedActivities.dart';
import 'package:viami/screens/register.dart';
import 'package:viami/screens/search.dart';
import 'package:viami/screens/start.dart';
import 'package:viami/screens/settings.dart';
import 'package:viami/screens/notifications.dart';
import 'package:viami/screens/updatePassword.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:viami/store_config.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isIOS || Platform.isMacOS) {
    StoreConfig(
      store: Store.appStore,
      apiKey: appleApiKey,
    );
  } else if (Platform.isAndroid) {
    const useAmazon = bool.fromEnvironment("amazon");
    StoreConfig(
      store: useAmazon ? Store.amazon : Store.playStore,
      apiKey: useAmazon ? amazonApiKey : googleApiKey,
    );
  }

  await _configureSDK();

  await dotenv.load(fileName: "lib/.env");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseApi().initNotifications();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: const IntroductionPage(),
        initialRoute: "/",
        title: 'Viami',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('fr')],
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
          "/notifications": (context) => const NotificationsPage(),
          "/login": (context) => const LoginPage(),
          "/profile": (context) => const ProfilePage(),
          "/updatePassword": (context) => const UpdatePassword(),
          "/search": (context) => const SearchPage(),
          "/activities/popular": (context) => const AllPopularActivitiesPage(),
          "/activities/recommend": (context) =>
              const AllRecommendedActivitiesPage(),
          "/messages": (context) => const MessengerPage(),
          "faqDetails": (context) => const FaqDetailsPage()
        });
  }
}

Future<void> _configureSDK() async {
  await Purchases.setLogLevel(LogLevel.debug);

  PurchasesConfiguration configuration;
  if (StoreConfig.isForAmazonAppstore()) {
    configuration = AmazonConfiguration(StoreConfig.instance.apiKey);
  } else {
    configuration = PurchasesConfiguration(StoreConfig.instance.apiKey);
  }

  configuration.entitlementVerificationMode =
      EntitlementVerificationMode.informational;
  await Purchases.configure(configuration);

  await Purchases.enableAdServicesAttributionTokenCollection();
}
