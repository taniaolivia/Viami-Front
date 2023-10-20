import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models-api/user.dart';
import '../services/user.service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
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

  bool startAnimation = false;
  final List<String> items = [
    "Supprimer le compte ",
    "item 2 ",
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
                  height: MediaQuery.of(context).size.height / 6,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/home');

                                //Navigator.pop(context);
                              },
                              child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 30, left: 20),
                                  child: Image.asset("assets/return.png"))),
                          const SizedBox(
                            width: 30,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 60),
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
                              bool logoutSuccess =
                                  await deleteUserById(userId, token);
                              if (logoutSuccess) {
                                Navigator.pushReplacementNamed(
                                    context, '/login');
                              } else {
                                print('Logout failed');
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
              //border: Border.all(color: Color.fromARGB(255, 9, 10, 10)
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
