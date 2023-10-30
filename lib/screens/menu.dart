import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:viami/screens/show_profile_page.dart';
import 'package:viami/services/user/auth.service.dart';
import 'package:viami/services/user/user.service.dart';
import '../models-api/user/user.dart';
import '../models/menu_item.dart';
import '../models/menu_items.dart';

class MenuPage extends StatelessWidget {
  final MenuItem currentItem;
  final ValueChanged<MenuItem> onSelectedItem;
  final storage = const FlutterSecureStorage();

  MenuPage(
      {super.key, required this.currentItem, required this.onSelectedItem});

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

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData.dark(),
        child: Scaffold(
            backgroundColor: Color(0xFF0081CF),
            body: FutureBuilder<User>(
              future: getUser(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var user = snapshot.data!;
                  var firstName = user.firstName;
                  var idUser = user.id;

                  return Stack(children: [
                    // Menu Content
                    SafeArea(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Spacer(),
                            Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ShowProfilePage(
                                                      userId: userId!)));
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: const Color(0xFFFFFFFF),
                                            width: 3.0,
                                          ),
                                        ),
                                        child: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              '${dotenv.env['CDN_URL']}/assets/profil.png'),
                                          radius: 50.0,
                                        )))),
                            const SizedBox(height: 10.0),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 40.0, top: 10.0),
                              child: Text(
                                toBeginningOfSentenceCase(firstName)!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 19.0,
                                ),
                              ),
                            ),
                            const Spacer(),
                            ...MenuItems.all.map(buildMenuItem).toList(),
                            const Spacer(flex: 2),
                            const Spacer(),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: OutlinedButton.icon(
                                onPressed: () async {
                                  //change id after with get id by provider when connect user  is done
                                  bool logoutSuccess =
                                      await AuthService().logout(idUser);
                                  if (logoutSuccess) {
                                    Navigator.pushNamed(context, '/login');
                                  }
                                },
                                icon: const Icon(Icons.logout,
                                    color: Colors.white),
                                label: const Text(
                                  "Se déconnecter",
                                  style: TextStyle(color: Colors.white),
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
                          ]),
                    ),
                  ]);
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
