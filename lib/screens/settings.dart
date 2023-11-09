import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:viami/components/dialogMessage.dart';
import 'package:viami/models-api/user/user.dart';
import 'package:viami/services/user/auth.service.dart';
import '../services/user/user.service.dart';

class SettingsPage extends StatefulWidget {
  final bool? tokenExpired;
  const SettingsPage({super.key, this.tokenExpired});

  @override
  State<StatefulWidget> createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  final storage = const FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();

  String? token = "";
  String? userId = "";
  bool passwordVisible = false;
  TextEditingController passwordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();
  FocusNode focusNode = FocusNode();
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

  bool startAnimation = false;
  final List<String> items = [
    "Supprimer le compte ",
    "Changer le mot de passe ",
    "item3",
    "item 2 ",
    "item 2 ",
    "item 2 ",
    "item 2 ",
    "item 2 ",
    "item 2 ",
    "item 2 ",
    "item 2 ",
    "item 2 ",
    "item 2 ",
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
    if (widget.tokenExpired == true) {
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
    return Scaffold(
        body: FutureBuilder<User>(
      future: getUser(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var user = snapshot.data!;
          return SafeArea(
              child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(children: [
              Container(
                  decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      )),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                size: 20,
                                color: Colors.white,
                              )),
                          const SizedBox(
                            width: 30,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 40),
                            child: Text(
                              "Paramètres",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 35),
                            ),
                          )
                        ],
                      )
                    ],
                  )),
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
        } else {
          return const CircularProgressIndicator();
        }
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
                      actions: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Non')),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green),
                            onPressed: () async {
                              bool logoutSuccess = await UserService()
                                  .deleteUserById(userId!, token);

                              if (logoutSuccess) {
                                Navigator.pushNamed(context, '/login');
                              }
                            },
                            child: const Text(
                              'Oui',
                            )),
                      ],
                      title: const Text("Suppression du compte"),
                      content: const Text(
                          "Êtes-vous sûr de vouloir supprimer votre compte ?"),
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
                child: ListTile(
              title: Text(
                " ${items[index]}",
                style: const TextStyle(fontSize: 16),
              ),
              trailing: Icon(icons[index]),
            ))));
  }
}
