import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class NavigationBarComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      const Icon(
        Icons.home,
        size: 30,
      ),
      const Icon(
        Icons.search,
        size: 30,
      ),
      const Icon(
        Icons.message,
        size: 30,
      ),
      const Icon(
        Icons.person,
        size: 30,
      ),
      const Icon(
        Icons.home,
        size: 30,
      ),
    ];
    int index = 2;
    return CurvedNavigationBar(
      backgroundColor: Colors.transparent,
      items: items,
      height: 60,
      index: index,
    );
  }
}
