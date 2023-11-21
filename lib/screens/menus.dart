import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:viami/components/NavigationBarComponent.dart';
import 'package:viami/components/dialogMessage.dart';
import 'package:viami/models-api/user/user.dart';
import 'package:viami/models/menu_item.dart';
import 'package:viami/models/menu_items.dart';
import 'package:viami/screens/home.dart';
import 'package:viami/screens/showProfile.dart';
import 'package:viami/screens/explore.dart';
import 'package:viami/services/user/auth.service.dart';
import 'package:viami/services/user/user.service.dart';
import 'package:viami/widgets/menu_widget.dart';
import 'drawer.dart';
import 'messenger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'searchTravel.dart';

class MenusPage extends StatefulWidget {
  final int? currentIndex;

  const MenusPage({super.key, this.currentIndex});

  @override
  _MenusPageState createState() => _MenusPageState();
}

class _MenusPageState extends State<MenusPage> {
  int _currentIndex = 2;
  late PageController _pageController;
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

      bool isTokenExpired = AuthService().isTokenExpired(token!);

      tokenExpired = isTokenExpired;

      return UserService().getUserById(userId.toString(), token.toString());
    }

    return getConnectedUser();
  }

  @override
  void initState() {
    super.initState();
    getUser();
    _currentIndex = widget.currentIndex ?? _currentIndex;
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
        Icons.explore,
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

    if (tokenExpired == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialogMessage(
            context,
            "Connectez-vous",
            const Text("Veuillez vous reconnecter !"),
            TextButton(
              child: const Text("Se connecter"),
              onPressed: () {
                Navigator.pushNamed(context, "/login");
              },
            ),
            null);
      });
    }
    ;
    return Scaffold(
      appBar: _currentIndex == 2
          ? AppBar(
              leading: MenuWidget(),
              elevation: 0,
              backgroundColor: Colors.white,
              title: Center(
                  child: FutureBuilder<User>(
                      future: getUser(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text("");
                        }

                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        if (!snapshot.hasData) {
                          return Text('');
                        }
                        var user = snapshot.data!;

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(
                              '${dotenv.env['CDN_URL']}/assets/location.png',
                              width: 20.0,
                              height: 20.0,
                              color: const Color(0xFF0081CF),
                            ),
                            const SizedBox(width: 8.0),
                            AutoSizeText(
                              user.location.split(',')[0],
                              minFontSize: 11,
                              maxFontSize: 13,
                              style: const TextStyle(color: Color(0xFF000000)),
                            ),
                          ],
                        );
                      })),
              iconTheme: const IconThemeData(color: Color(0xFF6D7D95)),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(
                    right: 16.0,
                  ),
                  child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/home");
                      },
                      child: const Icon(Icons.favorite_border_outlined,
                          color: Color(0xFF0081CF))),
                ),
              ],
            )
          : null,
      body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            const SearchTravelPage(),
            ExplorePage(),
            const HomePage(),
            const MessengerPage(),
            ShowProfilePage(showButton: true, userId: userId!),
          ]),
      drawer: const DrawerPage(),
      bottomNavigationBar: CustomCurvedNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 10),
              curve: Curves.easeInOut,
            );
          });
        },
      ),
    );
  }
}
