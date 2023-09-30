import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:viami/screens/notifications_page.dart';
import 'package:viami/screens/secondPage.dart';

import 'menu.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  MenuItem cuurentItem = MenuItems.payment;
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
      case MenuItems.payment:
        return SecondPage();
      default:
        return NotificationPage();
    }
  }
}
