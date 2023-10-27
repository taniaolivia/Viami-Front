import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class CustomCurvedNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomCurvedNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      const Icon(
        Icons.search,
        size: 30,
      ),
      const Icon(
        Icons.star,
        size: 30,
      ),
      const Icon(
        Icons.home,
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
    ];

    return CurvedNavigationBar(
      backgroundColor: Colors.transparent,
      animationCurve: Curves.bounceInOut,
      animationDuration: Duration(milliseconds: 300),
      items: items,
      height: 75,
      index: currentIndex,
      onTap: onTap,
    );
  }
}
