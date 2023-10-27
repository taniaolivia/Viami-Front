import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:viami/screens/settings.dart';
import '../components/NavigationBarComponent.dart';
import '../models/menu_item.dart';
import '../models/menu_items.dart';
import '../widgets/menu_widget.dart';
import 'drawer.dart';
import 'menu.dart';
import 'message_page.dart';
import 'notifications_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'profile_page.dart';
import 'search_page.dart';
import 'vip_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 2;
  late PageController _pageController;
  MenuItem currentItem = MenuItems.home;

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
    return Scaffold(
      appBar: AppBar(
        leading: MenuWidget(),
        elevation: 0,
        backgroundColor: const Color(0xFFFAFAFA),
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/location.png',
                width: 20.0,
                height: 20.0,
                color: const Color(0xFF0081CF),
              ),
              const SizedBox(width: 8.0),
              const Text(
                "Paris",
                style: TextStyle(color: Color(0xFF000000)),
              ),
            ],
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF6D7D95)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 16.0,
            ),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFFFFFFF),
                  width: 2.0,
                ),
              ),
              child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/profile");
                  },
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                        '${dotenv.env['CDN_URL']}/assets/profil.png'),
                    radius: 16,
                  )),
            ),
          )
        ],
      ),
      body: PageView(
        controller: _pageController,
        children: [
          SearchPage(),
          VipPage(),
          Container(), // Page Home
          MessagePage(),
          ProfilePage(),
        ],
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      drawer: const DrawerPage(),
      bottomNavigationBar: CustomCurvedNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          });
        },
      ),
    );
  }
}
