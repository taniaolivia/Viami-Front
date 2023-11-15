import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:viami/models-api/userImage/usersImages.dart';
import 'package:viami/screens/showProfile.dart';
import 'package:viami/services/user/auth.service.dart';
import 'package:viami/services/user/user.service.dart';
import 'package:viami/services/userImage/usersImages.service.dart';
import '../components/pageTransition.dart';
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

  Future<UsersImages> getUserImages() async {
    token = await storage.read(key: "token");
    userId = await storage.read(key: "userId");

    return UsersImagesService()
        .getUserImagesById(userId.toString(), token.toString());
  }

  @override
  Widget build(BuildContext context) {
    Widget buildMenuItem(MenuItem item) => ListTile(
          selectedTileColor: Colors.white,
          selected: currentItem == item,
          minLeadingWidth: 20,
          leading: Icon(
            item.icon,
            size: MediaQuery.of(context).size.width <= 320 ? 20 : 25,
          ),
          title: AutoSizeText(item.title,
              minFontSize: 10,
              maxFontSize: 14,
              style: const TextStyle(fontFamily: "Poppins")),
          onTap: () => onSelectedItem(item),
        );

    return Theme(
        data: ThemeData.dark(),
        child: Scaffold(
            backgroundColor: const Color(0xFF0081CF),
            body: FutureBuilder<List<Object>>(
              future: Future.wait([getUser(), getUserImages()]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("");
                }

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (!snapshot.hasData) {
                  return Text('');
                }

                var user = snapshot.data![0] as User;
                var images = snapshot.data![1] as UsersImages;
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
                                        FadePageRoute(
                                            page: ShowProfilePage(
                                                showButton: true,
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
                                      width:
                                          MediaQuery.of(context).size.width <=
                                                  320
                                              ? 80
                                              : 100,
                                      child: images.userImages.length != 0
                                          ? CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  images.userImages[0].image),
                                              radius: 50.0,
                                            )
                                          : CircleAvatar(
                                              radius: 50.0,
                                              child: Icon(
                                                Icons.person,
                                                size: MediaQuery.of(context)
                                                            .size
                                                            .width <=
                                                        320
                                                    ? 50
                                                    : 70,
                                              ))))),
                          SizedBox(
                              height: MediaQuery.of(context).size.width <= 320
                                  ? 0.0
                                  : 10.0),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 40.0, top: 10.0),
                            child: AutoSizeText(
                              toBeginningOfSentenceCase(firstName)!,
                              minFontSize: 16,
                              maxFontSize: 19,
                              style: const TextStyle(
                                  color: Colors.white, fontFamily: "Poppins"),
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
                                bool logoutSuccess =
                                    await AuthService().logout(idUser);
                                if (logoutSuccess) {
                                  Navigator.pushNamed(context, '/login');
                                }
                              },
                              icon: Icon(
                                Icons.logout,
                                color: Colors.white,
                                size: MediaQuery.of(context).size.width <= 320
                                    ? 20
                                    : 25,
                              ),
                              label: const AutoSizeText(
                                "Se déconnecter",
                                minFontSize: 10,
                                maxFontSize: 12,
                                style: TextStyle(
                                    color: Colors.white, fontFamily: "Poppins"),
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
              },
            )));
  }
}
