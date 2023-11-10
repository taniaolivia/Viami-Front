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
      Icon(
        Icons.search,
        size: MediaQuery.of(context).size.width <= 320 ? 25 : 30,
        color: Colors.white,
      ),
      Icon(
        Icons.star,
        size: MediaQuery.of(context).size.width <= 320 ? 25 : 30,
        color: Colors.white,
      ),
      Icon(
        Icons.home,
        size: MediaQuery.of(context).size.width <= 320 ? 25 : 30,
        color: Colors.white,
      ),
      Icon(
        Icons.message,
        size: MediaQuery.of(context).size.width <= 320 ? 25 : 30,
        color: Colors.white,
      ),
      Icon(
        Icons.person,
        size: MediaQuery.of(context).size.width <= 320 ? 25 : 30,
        color: Colors.white,
      ),
    ];

    return CurvedNavigationBar(
      backgroundColor: Colors.white,
      buttonBackgroundColor: const Color(0xFF0081CF),
      color: const Color(0xFF0081CF),
      animationCurve: Curves.bounceInOut,
      animationDuration: const Duration(milliseconds: 300),
      items: items,
      height: MediaQuery.of(context).size.width <= 320 ? 55 : 65,
      index: currentIndex,
      onTap: onTap,
    );
  }
}
