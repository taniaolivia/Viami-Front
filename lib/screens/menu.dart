import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models-api/user.dart';
import '../models/menu_item.dart';
import '../models/menu_items.dart';
import '../services/user.service.dart';
import '../services/auth.service.dart';

class MenuPage extends StatelessWidget {
  final MenuItem currentItem;
  final ValueChanged<MenuItem> onSelectedItem;
  final storage = const FlutterSecureStorage();

  String? token = "";
  String? userId = "";

  Future<User> getUser() {
    Future<User> getConnectedUser() async {
      token = await storage.read(key: "token");
      userId = await storage.read(key: "userId");

      return UserService().getUserById(userId.toString(), token.toString());
    }

    return getConnectedUser();
  }

  MenuPage(
      {super.key, required this.currentItem, required this.onSelectedItem});
  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData.dark(),
        child: Scaffold(
            body: FutureBuilder<User>(
          future: getUser(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var user = snapshot.data!;
              var firstName = user.firstName ?? "Default Name";
              var idUser = user.id;
              print("Assigned firstName: $firstName");
              return Stack(
                children: [
                  // Background Image
                  Positioned.fill(
                    child: Image.asset(
                      'assets/drawerHeader.png',
                      fit: BoxFit.cover,
                    ),
                  ),

                  // Menu Content
                  SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFFFFFFFF),
                                width: 3.0,
                              ),
                            ),
                            child: const CircleAvatar(
                              backgroundImage: AssetImage('assets/profil.png'),
                              radius: 50.0,
                            ),
                          ),
                        ),
                        const SizedBox(
                            height:
                                10.0), // Add some space between CircleAvatar and Text
                        Padding(
                          padding: EdgeInsets.only(left: 17.0),
                          child: Text(
                            firstName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 19.0,
                            ),
                          ),
                        ),
                        const Spacer(),
                        ...MenuItems.all.map(buildMenuItem).toList(),
                        const Spacer(flex: 2),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              //change id after with get id by provider when connect user  is done
                              bool logoutSuccess =
                                  await AuthService().logout(idUser);
                              if (logoutSuccess) {
                                Navigator.pushReplacementNamed(
                                    context, '/login');
                              } else {
                                print('Logout failed');
                              }
                            },
                            icon: const Icon(Icons.logout,
                                color: Colors.white), // Set icon color
                            label: const Text(
                              "Logout",
                              style: TextStyle(
                                  color: Colors.white), // Set text color
                            ),
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              side: const BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        )));
  }

  Widget buildMenuItem(MenuItem item) => ListTile(
        selectedTileColor: Colors.white,
        selected: currentItem == item,
        minLeadingWidth: 20,
        leading: Icon(item.icon),
        title: Text(item.title),
        onTap: () => onSelectedItem(item),
      );
}
