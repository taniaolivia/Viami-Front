import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:viami/screens/home.dart';
import 'package:viami/screens/message_page.dart';
import 'package:viami/screens/profile_page.dart';
import 'package:viami/screens/search_page.dart';
import 'package:viami/screens/travel_page.dart';

class NavigationBarComponent extends StatefulWidget {
  @override
  State<NavigationBarComponent> createState() => __NavigationBarComponent();
}

class __NavigationBarComponent extends State<NavigationBarComponent> {
  int _currentIndex = 2;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      const Icon(
        Icons.search,
        size: 30,
      ),
      const Icon(
        Icons.card_travel_rounded,
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

    final screens = [
      SearchPage(),
      TravelPage(),
      Home(),
      MessagePage(),
      ProfilePage()
    ];
    return Scaffold(
        body: PageView(
          controller: _pageController,
          children: screens,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.transparent,
          animationCurve: Curves.bounceInOut,
          animationDuration: Duration(milliseconds: 300),
          items: items,
          height: 75,
          index: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              _pageController.animateToPage(
                index,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            });
          },
        ));
  }
}
