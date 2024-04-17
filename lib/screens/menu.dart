import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:viami/components/dialogMessage.dart';
import 'package:viami/models-api/userImage/usersImages.dart';
import 'package:viami/screens/payment.dart';
import 'package:viami/screens/showProfile.dart';
import 'package:viami/services/user/auth.service.dart';
import 'package:viami/services/user/user.service.dart';
import 'package:viami/services/userImage/usersImages.service.dart';
import '../components/pageTransition.dart';
import '../models-api/user/user.dart';
import '../models/menu_item.dart';
import '../models/menu_items.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuPage extends StatelessWidget {
  final MenuItem currentItem;
  final ValueChanged<MenuItem> onSelectedItem;
  final storage = const FlutterSecureStorage();

  MenuPage(
      {super.key, required this.currentItem, required this.onSelectedItem});

  String? token = "";
  String? userId = "";
  final Uri _emailLaunchUri = Uri(
    scheme: 'mailto',
    path: '${dotenv.env['EMAIL_VIAMI']}',
  );

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

  void socialMediasUrls(String socmed) async {
    if (socmed == 'instagram') {
      await launchUrl(Uri.parse('${dotenv.env['INSTA_URL']}'));
    } else if (socmed == 'facebook') {
      await launchUrl(Uri.parse('${dotenv.env['FACEBOOK_URL']}'));
    } else if (socmed == 'tiktok') {
      await launchUrl(Uri.parse('${dotenv.env['TIKTOK_URL']}'));
    } else if (socmed == 'youtube') {
      await launchUrl(Uri.parse('${dotenv.env['YOUTUBE_URL']}'));
    }
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
            color: currentItem == item ? const Color(0xFF0081CF) : Colors.white,
          ),
          title: AutoSizeText(item.title,
              minFontSize: 10,
              maxFontSize: 14,
              style: TextStyle(
                  fontFamily: "Poppins",
                  color: currentItem == item
                      ? const Color(0xFF0081CF)
                      : Colors.white)),
          onTap: () {
            if (item.title == "Nous contacter") {
              onSelectedItem(item);

              showDialogMessage(
                  context,
                  "Information",
                  const Text(
                      'Veuillez utiliser votre mail inscrit à Viami pour nous contacter !'),
                  TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    child: const Text("Annuler",
                        style: TextStyle(color: Colors.black)),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await launchUrlString(_emailLaunchUri.toString());
                    },
                    child: const Text("D'accord",
                        style: TextStyle(color: Colors.black)),
                  ));
            } else if (item.title == "Paiement") {
              onSelectedItem(item);

              Navigator.push(context, FadePageRoute(page: const PaymentPage()));
            } else {
              onSelectedItem(item);
            }
          },
        );

    return Theme(
        data: ThemeData.dark(),
        child: Scaffold(
            backgroundColor: const Color(0xFF0081CF),
            body: FutureBuilder<List<Object>>(
              future: Future.wait([getUser(), getUserImages()]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const Text(
                    '',
                    textAlign: TextAlign.center,
                  );
                } else if (!snapshot.hasData) {
                  return const Text('');
                }
                var user = snapshot.data![0] as User;
                var images = snapshot.data![1] as UsersImages;
                var firstName = user.firstName;
                var idUser = user.id;

                return Stack(children: [
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
                                          userId: userId!,
                                          showComment: false,
                                        )));
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              child: Row(children: [
                                GestureDetector(
                                  onTap: () {
                                    socialMediasUrls('instagram');
                                  },
                                  child: Image.network(
                                    '${dotenv.env['CDN_URL']}/assets/social-media/instagram.png',
                                    width: 36,
                                    height: 36,
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    socialMediasUrls('facebook');
                                  },
                                  child: Image.network(
                                    '${dotenv.env['CDN_URL']}/assets/social-media/facebook.png',
                                    width: 35,
                                    height: 35,
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    socialMediasUrls('tiktok');
                                  },
                                  child: Image.network(
                                    '${dotenv.env['CDN_URL']}/assets/social-media/tiktok.png',
                                    width: 35,
                                    height: 35,
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    socialMediasUrls('youtube');
                                  },
                                  child: Column(children: [
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Image.network(
                                      '${dotenv.env['CDN_URL']}/assets/social-media/youtube.png',
                                      width: 40,
                                      height: 40,
                                    )
                                  ]),
                                ),
                              ])),
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
