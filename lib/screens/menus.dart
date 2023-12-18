import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:viami/components/NavigationBarComponent.dart';
import 'package:viami/components/dialogMessage.dart';
import 'package:viami/models-api/requestMessage/requests_messages.dart';
import 'package:viami/models-api/user/user.dart';
import 'package:viami/models/menu_item.dart';
import 'package:viami/models/menu_items.dart';
import 'package:viami/screens/home.dart';
import 'package:viami/screens/showProfile.dart';
import 'package:viami/screens/explore.dart';
import 'package:viami/services/requestMessage/requests_messages_service.dart';
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
  int requests = 0;

  Future<User> getUser() {
    Future<User> getConnectedUser() async {
      token = await storage.read(key: "token");
      userId = await storage.read(key: "userId");

      //bool isTokenExpired = AuthService().isTokenExpired(token!);

      //tokenExpired = isTokenExpired;

      return UserService().getUserById(userId.toString(), token.toString());
    }

    return getConnectedUser();
  }

  Future<RequestsMessages> getAllRequestsByUser() async {
    token = await storage.read(key: "token");
    userId = await storage.read(key: "userId");

    return RequestsMessageService()
        .getAllRequestsMessagesByUser(token.toString(), userId.toString());
  }

  void fetchData() async {
    await getUser();
    var allRequests = await getAllRequestsByUser();

    setState(() {
      requests = allRequests.requestsMessages.length;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();

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
      /*WidgetsBinding.instance.addPostFrameCallback((_) {
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
      });*/
    }
    ;
    return Scaffold(
      extendBody: true,
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
                          return BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height));
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData) {
                          return const Text('');
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
                GestureDetector(
                    onTap: () async {
                      Navigator.pushNamed(context, "/notifications");
                    },
                    child: FutureBuilder<RequestsMessages>(
                        future: getAllRequestsByUser(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height:
                                        MediaQuery.of(context).size.height));
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (!snapshot.hasData) {
                            return const Text('');
                          }
                          var requestsList = snapshot.data!;

                          requests = requestsList.requestsMessages.length;

                          return Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: requests != 0
                                  ? Stack(children: [
                                      const Icon(Icons.notifications_outlined,
                                          color: Color(0xFF0081CF), size: 32),
                                      Positioned(
                                        right: 0,
                                        top: 6,
                                        child: CircleAvatar(
                                          backgroundColor: const Color.fromARGB(
                                              255, 207, 0, 0),
                                          radius: 9,
                                          child: Text(
                                            requests > 99
                                                ? "99+"
                                                : requests.toString(),
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 8,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ])
                                  : const Icon(Icons.notifications_outlined,
                                      color: Color(0xFF0081CF), size: 32));
                        })),
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
            ShowProfilePage(
              showButton: true,
              userId: userId!,
              showComment: false,
            ),
          ]),
      drawer: const DrawerPage(),
      bottomNavigationBar: CustomCurvedNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) async {
          var allRequests = await getAllRequestsByUser();

          setState(() {
            requests = allRequests.requestsMessages.length;
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
