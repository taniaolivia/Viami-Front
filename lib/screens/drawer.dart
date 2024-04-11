import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:viami/models-api/user/user.dart';
import 'package:viami/screens/notifications.dart';
import 'package:viami/screens/menus.dart';
import 'package:viami/screens/settings.dart';
import 'package:viami/services/user/user.service.dart';
import '../models/menu_item.dart';
import '../models/menu_items.dart';
import 'menu.dart';

class DrawerPage extends StatefulWidget {
  final bool? tokenExpired;
  const DrawerPage({super.key, this.tokenExpired});

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  MenuItem currentItem = MenuItems.home;
  final storage = const FlutterSecureStorage();

  String? token = "";
  String? userId = "";
  String? userProfile;
  bool? tokenExpired;

  Future<User> getUser() {
    Future<User> getConnectedUser() async {
      token = await storage.read(key: "token");
      userId = await storage.read(key: "userId");

      return UserService().getUserById(userId.toString(), token.toString());
    }

    return getConnectedUser();
  }

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
        style: DrawerStyle.Style1,
        borderRadius: 40,
        angle: -10,
        slideWidth: MediaQuery.of(context).size.width * 0.8,
        showShadow: true,
        mainScreen: getScreen(),
        menuScreen: Builder(
          builder: (context) => MenuPage(
            currentItem: currentItem,
            onSelectedItem: (item) {
              setState(() {
                currentItem = item;
              });

              ZoomDrawer.of(context)!.close();
            },
          ),
        ));
  }

  Widget getScreen() {
    switch (currentItem) {
      case MenuItems.notification:
        return const NotificationsPage();
      case MenuItems.settings:
        return const SettingsPage();
      default:
        return const MenusPage();
    }
  }
}
