import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:viami/screens/notifications_page.dart';
import 'package:viami/screens/home.dart';
import 'package:viami/screens/settings.dart';

import '../models/menu_item.dart';
import '../models/menu_items.dart';
import 'menu.dart';

class DrawerPage extends StatefulWidget {
  const DrawerPage({super.key});

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  MenuItem currentItem = MenuItems.home;
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
        return const HomePage();
    }
  }
}
