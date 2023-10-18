import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:viami/screens/notifications_page.dart';
import 'package:viami/screens/home.dart';
import 'package:viami/screens/settings.dart';

import 'menu.dart';

class DrawerPage extends StatefulWidget {
  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  MenuItem cuurentItem = MenuItems.home;
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
            cuurentItem: cuurentItem,
            onSelectedItem: (item) {
              setState(() {
                cuurentItem = item;
              });

              ZoomDrawer.of(context)!.close();
            },
          ),
        ));
  }

  Widget getScreen() {
    switch (cuurentItem) {
      case MenuItems.notification:
        return NotificationPage();
      case MenuItems.settings:
        return SettingsPage();
      default:
        return Home();
    }
  }
}
