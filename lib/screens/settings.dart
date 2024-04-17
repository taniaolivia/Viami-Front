import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:viami/models-api/user/user.dart';
import '../services/user/user.service.dart';

class SettingsPage extends StatefulWidget {
  final bool? tokenExpired;
  const SettingsPage({super.key, this.tokenExpired});

  @override
  State<StatefulWidget> createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  final storage = const FlutterSecureStorage();
  String? token = "";
  String? userId = "";
  bool passwordVisible = false;
  TextEditingController passwordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();
  FocusNode focusNode = FocusNode();
  //bool? tokenExpired;

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

  bool startAnimation = false;
  final List<String> items = [
    "Supprimer mon compte ",
    "Changer mon mot de passe ",
  ];
  final List<IconData> icons = [
    Icons.delete,
    Icons.password,
    Icons.delete,
    Icons.delete,
    Icons.delete,
    Icons.delete,
    Icons.delete,
    Icons.delete,
    Icons.delete,
    Icons.delete,
    Icons.delete,
    Icons.delete,
    Icons.delete,
  ];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        startAnimation = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const AutoSizeText(
            'Paramètres',
            minFontSize: 16,
            maxFontSize: 18,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
          ),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, "/home");
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 20,
              )),
          backgroundColor: const Color(0xFF0081CF),
        ),
        body: FutureBuilder<User>(
          future: getUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("");
            }

            if (snapshot.hasError) {
              return const Text(
                '',
                textAlign: TextAlign.center,
              );
            }

            if (!snapshot.hasData) {
              return const Text('');
            }
            var user = snapshot.data!;

            return SafeArea(
                child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(children: [
                const SizedBox(
                  height: 15,
                ),
                ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return item(index, token!, userId);
                  },
                ),
              ]),
            ));
          },
        ));
  }

  bool validatePasswordChange(
      String oldPassword, String newPassword, String confirmPassword) {
    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      return false;
    }

    if (newPassword != confirmPassword) {
      return false;
    }

    return true;
  }

  Widget item(int index, String token, String? userId) {
    return GestureDetector(
        onTap: () {
          if (index == 0) {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      surfaceTintColor: Colors.white,
                      actions: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    'Non',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  )),
                              TextButton(
                                  onPressed: () async {
                                    bool logoutSuccess = await UserService()
                                        .deleteUserById(userId!, token);

                                    if (logoutSuccess) {
                                      Navigator.pushNamed(context, '/login');
                                    }
                                  },
                                  child: const Text(
                                    'Oui',
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w600),
                                  )),
                            ])
                      ],
                      title: const Text(
                        "Suppression du compte",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      content: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                                "Êtes-vous sûr de vouloir supprimer votre compte ?"),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Attention : La suppression de votre compte entraînera la perte définitive de toutes vos données, y compris les éléments achetés, la progression du jeu, les messages, les commentaires et tout autre contenu que vous avez créé ou enregistré. Cette action est irréversible. Veuillez réfléchir attentivement avant de continuer.",
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Color.fromARGB(255, 226, 1, 1)),
                            )
                          ]),
                    ));
          }
          if (index == 1) {
            Navigator.pushReplacementNamed(context, '/updatePassword');
          }
        },
        child: AnimatedContainer(
            height: 65,
            curve: Curves.easeInOut,
            duration: Duration(milliseconds: 300 + (index * 100)),
            transform: Matrix4.translationValues(
                startAnimation ? 0 : MediaQuery.of(context).size.width, 0, 0),
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.all(5),
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 40,
            ),
            decoration: BoxDecoration(
              color: const Color.fromARGB(137, 248, 244, 244),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Card(
                surfaceTintColor: Colors.white,
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                        color: Color.fromARGB(255, 55, 55, 55), width: 1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  title: Text(
                    " ${items[index]}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  trailing: Icon(icons[index]),
                ))));
  }
}
